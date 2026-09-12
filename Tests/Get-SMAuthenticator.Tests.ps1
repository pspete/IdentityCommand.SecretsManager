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

Describe 'Get-SMAuthenticator' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -MockWith {
            [pscustomobject]@{ authenticators = @([pscustomobject]@{ name = "my_jwt_authn1" }); count = 1 }
        }

        InModuleScope -ModuleName $Script:SMModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.secretsmgr.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Get-SMAuthenticator

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/authenticators'
            } -Times 1 -Exactly -Scope It
        }
        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends the application/x.secretsmgr.v2beta+json Accept header' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Accept -eq 'application/x.secretsmgr.v2beta+json'
            } -Times 1 -Exactly -Scope It
        }

    }

}
