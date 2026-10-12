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

Describe 'Set-SMAccessToken' {

    BeforeEach {

        InModuleScope -ModuleName $Script:SMModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = $null
                User       = 'someone'
                Subdomain  = 'sometenant'
                StartTime  = Get-Date '2026-01-01T09:00:00'
                WebSession = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        Mock -CommandName Resolve-ServiceUrl -ModuleName $Script:SMModuleName -MockWith {
            [pscustomobject]@{ ServiceUrl = 'https://somedomain.secretsmgr.cyberark.cloud' }
        }

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -MockWith { }

        $Script:Token = 'eyJhbGciOiJSUzI1NiJ9.test' | ConvertTo-SecureString -AsPlainText -Force

    }

    AfterEach {
        InModuleScope -ModuleName $Script:SMModuleName {
            Remove-Variable -Name IndependentSession -Scope Script -ErrorAction SilentlyContinue
        }
    }

    Context 'Subdomain' {

        It 'resolves the tenant url from the secrets_manager discovery key' {
            Set-SMAccessToken -tenant_subdomain 'somedomain' -ConjurAccessToken $Script:Token
            Should -Invoke -CommandName Resolve-ServiceUrl -ModuleName $Script:SMModuleName -ParameterFilter {
                $Service -eq 'secrets_manager' -and $Subdomain -eq 'somedomain'
            } -Times 1 -Exactly -Scope It
            InModuleScope -ModuleName $Script:SMModuleName {
                $ISPSSSession.tenant_url | Should -Be 'https://somedomain.secretsmgr.cyberark.cloud'
            }
        }

    }

    Context 'URL' {

        It 'removes a trailing slash from a supplied tenant_url' {
            Set-SMAccessToken -tenant_url 'https://somedomain.secretsmgr.cyberark.cloud/' -ConjurAccessToken $Script:Token
            InModuleScope -ModuleName $Script:SMModuleName {
                $ISPSSSession.tenant_url | Should -Be 'https://somedomain.secretsmgr.cyberark.cloud'
            }
        }

    }

    Context 'Session' {

        BeforeEach {
            Set-SMAccessToken -tenant_url 'https://somedomain.secretsmgr.cyberark.cloud' -ConjurAccessToken $Script:Token
        }

        It 'holds the supplied token on a new WebRequestSession' {
            InModuleScope -ModuleName $Script:SMModuleName {
                $ISPSSSession.WebSession | Should -BeOfType 'Microsoft.PowerShell.Commands.WebRequestSession'
                $ISPSSSession.WebSession.Headers['Authorization'] | Should -Be 'Token token="eyJhbGciOiJSUzI1NiJ9.test"'
            }
        }

        It 'does not exchange an IdentityCommand session' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -Times 0 -Exactly -Scope It
        }

        It 'marks the module session independent of IdentityCommand' {
            InModuleScope -ModuleName $Script:SMModuleName {
                $Script:IndependentSession | Should -BeTrue
            }
        }

        It 'clears the copied IdentityCommand session details' {
            InModuleScope -ModuleName $Script:SMModuleName {
                $ISPSSSession.User | Should -BeNullOrEmpty
                $ISPSSSession.Subdomain | Should -BeNullOrEmpty
                $ISPSSSession.StartTime | Should -BeNullOrEmpty
            }
        }

        It 'sends later requests to the supplied tenant_url without resolving it' {
            $null = Get-SMTrustDomain
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/swa/trust-domains'
            } -Times 1 -Exactly -Scope It
            Should -Invoke -CommandName Resolve-ServiceUrl -ModuleName $Script:SMModuleName -Times 0 -Exactly -Scope It
        }

    }

}
