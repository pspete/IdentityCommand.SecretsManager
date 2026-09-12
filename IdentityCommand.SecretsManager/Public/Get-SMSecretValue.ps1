# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMSecretValue {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('ids')]
        [ValidateCount(1, 250)]
        [String[]]$id,

        #Base64-encode every returned secret value.
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [switch]$encode_values
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/secrets/values"

        if ($encode_values.IsPresent) {
            $URI = Add-QueryString -URI $URI -Parameter @{ encode_values = 'base64' }
        }

        $body = @{ ids = @($id) }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 3) -Accept $(Get-SMApiHeader -Version Beta)

        if ($null -ne $result) {

            $result.secrets

        }

    }#process

    end { }#end

}
