# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMTrustDomain {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(1, 60)]
        [String]$name,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('EC_P256', 'EC_P384', 'EC_P521', 'RSA_2048', 'RSA_4096')]
        [String]$signing_key_type,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('ES256', 'ES384', 'ES512', 'RS256', 'RS384', 'RS512')]
        [String]$signature_algorithm,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateRange(3600, 2592000)]
        [int]$signing_key_ttl,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateRange(60, 86400)]
        [int]$token_ttl,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateRange(600, 86400)]
        [int]$workload_ttl
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains"

        $body = [ordered]@{ name = $name }

        $Jwt = [ordered]@{}
        foreach ($p in 'signing_key_type', 'signature_algorithm', 'signing_key_ttl', 'token_ttl') {
            if ($PSBoundParameters.ContainsKey($p)) { $Jwt[$p] = $PSBoundParameters[$p] }
        }
        if ($Jwt.Keys.Count -gt 0) { $body['jwt'] = $Jwt }

        if ($PSBoundParameters.ContainsKey('workload_ttl')) {
            $body['x509'] = [ordered]@{ workload_ttl = $workload_ttl }
        }

        if ($PSCmdlet.ShouldProcess($name, 'Register SWA trust domain')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 4) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
