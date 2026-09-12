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

Describe 'New-SMSignedCertificate' {

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

        $Script:response = New-SMSignedCertificate -issuerName 'issuer-1' -csr 'CSRDATA'

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/issuers/issuer-1/sign'
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
                $Parsed.csr -eq 'CSRDATA'
            } -Times 1 -Exactly -Scope It
        }
        It 'does not send a request when WhatIf is specified' {
            New-SMSignedCertificate -issuerName 'issuer-1' -csr 'CSRDATA' -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -Times 1 -Exactly -Scope It
        }

    }

}
