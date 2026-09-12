BeforeAll {
    #Get Current Directory
    $Here = Split-Path -Parent $PSCommandPath

    #Module Name
    $ModuleName = 'IdentityCommand.SecretsManager'

    #Resolve Path to Module Directory
    $ModulePath = Resolve-Path "$Here\..\$ModuleName"

    #Define Path to Module Manifest
    $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

    if ( -not (Get-Module -Name $ModuleName -All)) {

        Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

    }

}

Describe 'Get-SMModuleData' {

    InModuleScope 'IdentityCommand.SecretsManager' {

        BeforeEach {

            $ISPSSSession = [ordered]@{
                tenant_url  = 'https://somedomain.secretsmgr.cyberark.cloud'
                WebSession  = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                StartTime   = Get-Date
                ElapsedTime = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

        }

        It 'returns the session data typed as IdCmd.Session' {

            $response = Get-SMModuleData

            $response.PSObject.TypeNames | Should -Contain 'IdCmd.Session'
            $response.tenant_url | Should -Be 'https://somedomain.secretsmgr.cyberark.cloud'

        }

        It 'calculates elapsed time from StartTime' {

            $response = Get-SMModuleData

            $response.ElapsedTime | Should -Not -BeNullOrEmpty

        }

    }

}
