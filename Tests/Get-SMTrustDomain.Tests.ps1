BeforeAll {
    $Script:SMModuleName = 'IdentityCommand.SecretsManager'

    #Get Current Directory
    $Here = Split-Path -Parent $PSCommandPath

    #Resolve Path to Module Directory
    $ModulePath = Resolve-Path "$Here\..\$Script:SMModuleName"

    #Define Path to Module Manifest
    $ManifestPath = Join-Path "$ModulePath" "$Script:SMModuleName.psd1"

    if ( -not (Get-Module -Name $Script:SMModuleName -All)) {

        Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

    }
}

Describe 'Get-SMTrustDomain' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -MockWith {
            [pscustomobject]@{ trust_domains = @([pscustomobject]@{ name = "prod.example.com" }); count = 1 }
        }

        InModuleScope -ModuleName $Script:SMModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.secretsmgr.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Get-SMTrustDomain

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/swa/trust-domains'
            } -Times 1 -Exactly -Scope It
        }
        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends the application/x.secretsmgr.v2+json Accept header' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Accept -eq 'application/x.secretsmgr.v2+json'
            } -Times 1 -Exactly -Scope It
        }

    }

    Context 'Without a module session' {

        BeforeEach {

            InModuleScope -ModuleName $Script:SMModuleName {
                $ISPSSSession = [ordered]@{
                    tenant_url = $null
                    Subdomain  = $null
                    StartTime  = $null
                    WebSession = $null
                }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }

            Mock -CommandName Get-IDSession -ModuleName $Script:SMModuleName -MockWith {
                [ordered]@{
                    tenant_url = 'https://sometenant.id.cyberark.cloud'
                    Subdomain  = 'sometenant'
                    StartTime  = Get-Date '2026-01-01T09:00:00'
                    WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                }
            }

            Mock -CommandName Resolve-ServiceUrl -ModuleName $Script:SMModuleName -MockWith {
                [pscustomobject]@{ ServiceUrl = 'https://sometenant.secretsmgr.cyberark.cloud' }
            }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -like '*/api/authn-oidc/cyberark/conjur/authenticate*'
            } -MockWith {
                [pscustomobject]@{
                    protected = 'eyJhbGciOiJjb25qdXIub3JnL3Nsb3NpbG8vdjIifQ=='
                    payload   = 'eyJzdWIiOiJhZG1pbiJ9'
                    signature = 'c2ln'
                }
            }

            $null = Get-SMTrustDomain

        }

        It 'resolves the service URL from the secrets_manager discovery key' {
            Should -Invoke -CommandName Resolve-ServiceUrl -ModuleName $Script:SMModuleName -ParameterFilter {
                $Service -eq 'secrets_manager' -and $Subdomain -eq 'sometenant'
            } -Times 1 -Exactly -Scope It
        }

        It 'exchanges the IdentityCommand session for a Conjur access token' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Method -eq 'POST' -and
                $URI -eq 'https://sometenant.secretsmgr.cyberark.cloud/api/authn-oidc/cyberark/conjur/authenticate?set_conjur_cookie=true'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request to the resolved service URL' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://sometenant.secretsmgr.cyberark.cloud/api/swa/trust-domains'
            } -Times 1 -Exactly -Scope It
        }

        It 'holds the Conjur access token on the module WebSession' {
            InModuleScope -ModuleName $Script:SMModuleName {
                $ISPSSSession.WebSession.Headers['Authorization'] | Should -Match '^Token token="[A-Za-z0-9+/=]+"$'
            }
        }

    }

}
