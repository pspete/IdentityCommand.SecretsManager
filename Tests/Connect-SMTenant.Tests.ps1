Describe $($PSCommandPath -Replace '.Tests.ps1') {

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

    InModuleScope 'IdentityCommand.SecretsManager' {

        BeforeEach {

            $ISPSSSession = [ordered]@{
                tenant_url = $null
                WebSession = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Resolve-ServiceUrl -MockWith {
                [pscustomobject]@{
                    ServiceUrl  = 'https://somedomain.secretsmgr.cyberark.cloud'
                    IdentityUrl = 'https://aao4818.id.cyberark.cloud'
                }
            }

        }

        Context 'Subdomain resolution' {

            It 'resolves the tenant url from the secrets_manager discovery key' {

                Connect-SMTenant -tenant_subdomain 'somedomain'

                Should -Invoke -CommandName Resolve-ServiceUrl -ParameterFilter {
                    $Service -eq 'secrets_manager' -and $Subdomain -eq 'somedomain'
                } -Times 1 -Exactly -Scope It

                $ISPSSSession.tenant_url | Should -Be 'https://somedomain.secretsmgr.cyberark.cloud'

            }

        }

        Context 'URL' {

            It 'removes a trailing slash from a supplied tenant_url' {

                Connect-SMTenant -tenant_url 'https://somedomain.secretsmgr.cyberark.cloud/'
                $ISPSSSession.tenant_url | Should -Be 'https://somedomain.secretsmgr.cyberark.cloud'

            }

        }

        Context 'Conjur access token' {

            It 'builds an independent WebRequestSession carrying the Conjur Authorization header' {

                $Token = 'eyJhbGciOiJSUzI1NiJ9.test' | ConvertTo-SecureString -AsPlainText -Force

                Connect-SMTenant -tenant_subdomain 'somedomain' -ConjurAccessToken $Token

                $ISPSSSession.WebSession | Should -BeOfType 'Microsoft.PowerShell.Commands.WebRequestSession'
                $ISPSSSession.WebSession.Headers['Authorization'] | Should -Be 'Token token="eyJhbGciOiJSUzI1NiJ9.test"'

            }

            It 'warns and leaves WebSession unset when no token is supplied' {

                Mock Write-Warning -MockWith { }

                Connect-SMTenant -tenant_subdomain 'somedomain'

                Should -Invoke -CommandName Write-Warning -Times 1 -Exactly -Scope It
                $ISPSSSession.WebSession | Should -BeNullOrEmpty

            }

        }

    }

}
