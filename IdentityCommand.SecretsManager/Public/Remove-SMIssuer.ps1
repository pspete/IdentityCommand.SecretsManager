# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMIssuer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('id')]
        [String]$issuerName,

        #For AWS and GCP issuers only: keep the secrets (variables) associated with the issuer rather
        #than deleting them along with it.
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [switch]$keep_secrets
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/issuers/$([uri]::EscapeDataString($issuerName))"

        if ($keep_secrets.IsPresent) {
            $URI = Add-QueryString -URI $URI -Parameter @{ keep_secrets = $true }
        }

        if ($PSCmdlet.ShouldProcess($issuerName, 'Delete Secrets Manager issuer')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version V2)

        }

    }#process

    end { }#end

}
