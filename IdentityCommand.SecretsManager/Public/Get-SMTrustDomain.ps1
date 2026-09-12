# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMTrustDomain {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'ByName')]
        [Alias('name')]
        [String]$trustDomainName,

        #The response reports only the count of items in this page, not an overall total or a next
        #offset - so this command cannot page automatically. Increase -offset yourself until a page
        #comes back with fewer than -limit trust domains.
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'List')]
        [ValidateRange(1, 1000)]
        [int]$limit,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'List')]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$offset
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'ByName') {

            $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))"

            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result

            }

        } else {

            $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains"
            $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result.trust_domains

            }

        }

    }#process

    end { }#end

}
