# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMIssuedCertificate {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$issuerName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(1, 64)]
        [String]$common_name,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$organization,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$org_units,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$locality,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$state,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(2, 2)]
        [String]$country,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('RSA_2048', 'RSA_3072', 'RSA_4096', 'EC_P256', 'EC_P384', 'EC_P521', 'EC_ED25519')]
        [String]$key_type,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$dns_names,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$ip_addresses,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$email_addresses,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$uris,

        #ISO 8601 duration, e.g. P30D
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$ttl,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$zone,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [bool]$ignore_storage
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/issuers/$([uri]::EscapeDataString($issuerName))/issue"

        $Subject = [ordered]@{ common_name = $common_name }
        foreach ($p in 'organization', 'org_units', 'locality', 'state', 'country') {
            if ($PSBoundParameters.ContainsKey($p)) { $Subject[$p] = $PSBoundParameters[$p] }
        }

        $body = [ordered]@{ subject = $Subject }

        $AltNames = [ordered]@{}
        foreach ($p in 'dns_names', 'ip_addresses', 'email_addresses', 'uris') {
            if ($PSBoundParameters.ContainsKey($p)) { $AltNames[$p] = @($PSBoundParameters[$p]) }
        }
        if ($AltNames.Keys.Count -gt 0) { $body['alt_names'] = $AltNames }

        foreach ($p in 'key_type', 'ttl', 'zone', 'ignore_storage') {
            if ($PSBoundParameters.ContainsKey($p)) { $body[$p] = $PSBoundParameters[$p] }
        }

        if ($PSCmdlet.ShouldProcess($issuerName, "Issue certificate for '$common_name'")) {

            #The response can carry a private_key - convert to UTF8 bytes rather than a String
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-SecretBody -Depth 6) -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
