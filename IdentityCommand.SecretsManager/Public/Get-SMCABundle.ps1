# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMCABundle {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('der', 'pem')]
        [String]$format
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/.well-known/ca-bundles"

        if ($PSBoundParameters.ContainsKey('format')) {
            $URI = Add-QueryString -URI $URI -Parameter @{ format = $format }
        }

        #This endpoint is public - no authentication or Accept header is required.
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    end { }#end

}
