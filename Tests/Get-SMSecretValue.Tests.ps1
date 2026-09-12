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

Describe 'Get-SMSecretValue' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -MockWith {
            [pscustomobject]@{ secrets = @([pscustomobject]@{ id = "data/vault/mysafe/myaccount/password"; value = "cGFzcw=="; status = "200" }) }
        }

        InModuleScope -ModuleName $Script:SMModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.secretsmgr.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Get-SMSecretValue -id 'data/vault/mysafe/myaccount/password'

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/secrets/values'
            } -Times 1 -Exactly -Scope It
        }
        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends the application/x.secretsmgr.v2beta+json Accept header' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Accept -eq 'application/x.secretsmgr.v2beta+json'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends the expected request body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Parsed = $Body | ConvertFrom-Json
                $Parsed.ids[0] -eq 'data/vault/mysafe/myaccount/password'
            } -Times 1 -Exactly -Scope It
        }

    }

}
