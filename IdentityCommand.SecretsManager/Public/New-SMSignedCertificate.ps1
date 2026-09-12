# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMSignedCertificate {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$issuerName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$csr,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$zone,

        #ISO 8601 duration, e.g. P30D
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$ttl
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/issuers/$([uri]::EscapeDataString($issuerName))/sign"

        $body = $PSBoundParameters | Get-Parameter -ParametersToRemove issuerName

        if ($PSCmdlet.ShouldProcess($issuerName, 'Sign certificate from CSR')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 4) -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
