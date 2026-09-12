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

Describe 'Set-SMIssuer' {

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

        $Script:response = Set-SMIssuer -issuerName 'aws-issuer-1' -access_key_id 'AKJHSBG75FH4GG62' -secret_access_key ('1234567890123456789012345678901234567890' | ConvertTo-SecureString -AsPlainText -Force)

    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.secretsmgr.cyberark.cloud/api/issuers/aws-issuer-1'
            } -Times 1 -Exactly -Scope It
        }
        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Method -eq 'PATCH'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends the application/x.secretsmgr.v2+json Accept header' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Accept -eq 'application/x.secretsmgr.v2+json'
            } -Times 1 -Exactly -Scope It
        }
        It 'sends the expected request body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -ParameterFilter {
                $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                $Parsed.data.access_key_id -eq 'AKJHSBG75FH4GG62'
            } -Times 1 -Exactly -Scope It
        }
        It 'does not send a request when WhatIf is specified' {
            Set-SMIssuer -issuerName 'aws-issuer-1' -access_key_id 'AKJHSBG75FH4GG62' -secret_access_key ('1234567890123456789012345678901234567890' | ConvertTo-SecureString -AsPlainText -Force) -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SMModuleName -Times 1 -Exactly -Scope It
        }

    }

}
