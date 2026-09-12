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

Describe 'New-SMIssuedCertificate' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -MockWith {
            $null
        }

        InModuleScope -ModuleName $Script:SMModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.secretsmgr.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = New-SMIssuedCertificate -issuerName 'issuer-1' -common_name 'rest.example.com'

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/issuers/issuer-1/issue'
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
                $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                $Parsed.subject.common_name -eq 'rest.example.com'
            } -Times 1 -Exactly -Scope It
        }
        It 'does not send a request when WhatIf is specified' {
            New-SMIssuedCertificate -issuerName 'issuer-1' -common_name 'rest.example.com' -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -Times 1 -Exactly -Scope It
        }

    }

}
