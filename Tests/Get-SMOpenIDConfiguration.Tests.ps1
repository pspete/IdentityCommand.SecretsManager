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

Describe 'Get-SMOpenIDConfiguration' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -MockWith {
            [pscustomobject]@{ issuer = "https://api.example.com/api/issuers/id" }
        }

        InModuleScope -ModuleName $Script:SMModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.secretsmgr.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Get-SMOpenIDConfiguration -trustDomainName 'prod.example.com'

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/swa/trust-domains/prod.example.com/.well-known/openid-configuration'
            } -Times 1 -Exactly -Scope It
        }
        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends no Accept header' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $null -eq $Accept
            } -Times 1 -Exactly -Scope It
        }

    }

}
