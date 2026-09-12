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

        #The Conjur access token obtained from the CyberArk Identity -> Conjur exchange, formatted as
        #the raw JWT (without the surrounding Token token="..." wrapper - this command adds that).
        #Supplying this is currently the only supported way to authenticate: the exchange itself is
        #not implemented by this module - see CLAUDE.md
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

                #Secrets Manager/SWA authenticate with a Conjur access token, not the CyberArk Identity
                #bearer session every other companion module shares - building an independent
                #WebRequestSession here, rather than copying $IDSession.WebSession, keeps this
                #module's calls from mutating (or being mutated by) that shared session object.
                $WebSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
                $Token = ConvertTo-InsecureString -SecureString $ConjurAccessToken
                $WebSession.Headers['Authorization'] = "Token token=`"$Token`""

                $ISPSSSession.WebSession = $WebSession

            }

        } else {

            Write-Warning 'No -ConjurAccessToken was supplied. The CyberArk Identity -> Conjur access token exchange is not implemented by this module (see CLAUDE.md) - every request will fail until $ISPSSSession.WebSession carries a WebRequestSession with the Conjur Authorization header set, either by re-running this command with -ConjurAccessToken or by setting it directly.'

        }

    }#process

    end { }#end

}
