# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Connect-SMTenant {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Subdomain')]
    param(

        #subdomain
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Subdomain')]
        [ValidateNotNullOrEmpty()]
        [Alias('subdomain')]
        [String]$tenant_subdomain,

        #tenant_url
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'URL')]
        [ValidateNotNullOrEmpty()]
        [Alias('secretsmgr_url')]
        [String]$tenant_url,

        #A Conjur access token obtained some other way, as the exact value the API expects inside
        #Authorization: Token token="...". Supplying this skips the CyberArk Identity -> Conjur
        #exchange this command otherwise performs automatically.
        [parameter(Mandatory = $false)]
        [SecureString]$ConjurAccessToken

    )

    begin { }#begin

    process {

        $UsingSubdomain = $PSCmdlet.ParameterSetName -eq 'Subdomain'

        if ($UsingSubdomain) {

            $ServiceUrl = Resolve-ServiceUrl -Service secrets_manager -Subdomain $tenant_subdomain
            $tenant_url = $ServiceUrl.ServiceUrl

        } else {

            #Ensure URL is in expected format - remove trailing slash if provided in Url
            $tenant_url = $tenant_url -replace '/$', ''

        }

        $ISPSSSession.tenant_url = $tenant_url

        if ($PSBoundParameters.ContainsKey('ConjurAccessToken')) {

            if ($PSCmdlet.ShouldProcess($tenant_url, 'Set Conjur access token')) {

                $Token = ConvertTo-InsecureString -SecureString $ConjurAccessToken

            }

        } elseif ($PSCmdlet.ShouldProcess($tenant_url, 'Exchange CyberArk Identity session for a Conjur access token')) {

            #Conjur accepts the same bearer-authenticated WebSession every other companion module
            #copies from Get-IDSession - no id_token, cookie or CSRF header is required.
            $ExchangeUri = "$tenant_url/api/authn-oidc/cyberark/conjur/authenticate?set_conjur_cookie=true"
            $ConjurResponse = Invoke-IDRestMethod -Method POST -URI $ExchangeUri -WebSession (Get-IDSession).WebSession

            $Token = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(($ConjurResponse | ConvertTo-Json -Compress -Depth 3)))

        }

        if ($Token) {

            #Secrets Manager/SWA authenticate with a Conjur access token, not the CyberArk Identity
            #bearer session every other companion module shares - building an independent
            #WebRequestSession here, rather than copying $IDSession.WebSession, keeps this
            #module's calls from mutating (or being mutated by) that shared session object.
            $WebSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            $WebSession.Headers['Authorization'] = "Token token=`"$Token`""

            $ISPSSSession.WebSession = $WebSession

        }

    }#process

    end { }#end

}
