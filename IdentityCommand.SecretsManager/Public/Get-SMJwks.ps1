# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMJwks {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'JWKS is an acronym (JSON Web Key Set), not a plural noun')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/.well-known/jwks"

        #This endpoint is public - no authentication is required. Returned whole (not unwrapped to
        #just .keys) since it is a discovery document, not a list resource.
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) { $result }

    }#process

    end { }#end

}
