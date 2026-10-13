# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Set-SMAccessToken {

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
        #Authorization: Token token="...".
        [parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [SecureString]$ConjurAccessToken

    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'Subdomain') {

            $tenant_url = (Resolve-ServiceUrl -Service $ServiceKey -Subdomain $tenant_subdomain).ServiceUrl

        } else {

            #Ensure URL is in expected format - remove trailing slash if provided in Url
            $tenant_url = $tenant_url -replace '/$', ''

        }

        if ($PSCmdlet.ShouldProcess($tenant_url, 'Set Conjur access token')) {

            #Requests use this token until the module is imported again, whatever the IdentityCommand session
            $Script:IndependentSession = $true

            foreach ($key in 'User', 'TenantId', 'SessionId', 'Subdomain', 'StartTime') {
                $ISPSSSession[$key] = $null
            }

            $ISPSSSession.tenant_url = $tenant_url
            $ISPSSSession.WebSession = Get-SMConjurSession -Token (ConvertTo-InsecureString -SecureString $ConjurAccessToken)

        }

    }#process

    end { }#end

}
