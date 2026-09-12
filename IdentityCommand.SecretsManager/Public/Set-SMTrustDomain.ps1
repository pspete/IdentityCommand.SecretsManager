# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Set-SMTrustDomain {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('EC_P256', 'EC_P384', 'EC_P521', 'RSA_2048', 'RSA_4096')]
        [String]$signing_key_type,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('ES256', 'ES384', 'ES512', 'RS256', 'RS384', 'RS512')]
        [String]$signature_algorithm,

        #NOTE: the update range (3600-86400) is narrower than create's (3600-2592000) - a signing key
        #can only be extended up to 24 hours through this call.
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateRange(3600, 86400)]
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

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))"

        $body = [ordered]@{}

        $Jwt = [ordered]@{}
        foreach ($p in 'signing_key_type', 'signature_algorithm', 'signing_key_ttl', 'token_ttl') {
            if ($PSBoundParameters.ContainsKey($p)) { $Jwt[$p] = $PSBoundParameters[$p] }
        }
        if ($Jwt.Keys.Count -gt 0) { $body['jwt'] = $Jwt }

        #x509's workload_ttl is required if x509 is sent at all - update requests it directly.
        if ($PSBoundParameters.ContainsKey('workload_ttl')) {
            $body['x509'] = [ordered]@{ workload_ttl = $workload_ttl }
        }

        if ($body.Keys.Count -eq 0) {
            throw 'Supply at least one setting to update'
        }

        if ($PSCmdlet.ShouldProcess($trustDomainName, 'Update SWA trust domain')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body ($body | ConvertTo-Json -Depth 4) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
