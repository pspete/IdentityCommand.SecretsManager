# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMAuthenticator {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('jwt', 'aws_iam')]
        [String]$type,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('gitlab', 'github_actions', 'kubernetes', 'jenkins')]
        [String]$subtype,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(1, 60)]
        [String]$name,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [bool]$enabled,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$ownerId,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('user', 'workload', 'group')]
        [String]$ownerKind,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$ca_cert,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$audience,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$jwks_uri,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [hashtable]$public_keys,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$issuer,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [hashtable]$claim_aliases,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$enforced_claims,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$identity_path,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$token_app_property,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [hashtable]$annotations
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/authenticators"

        $body = [ordered]@{ type = $type; name = $name }

        foreach ($p in 'subtype', 'enabled', 'annotations') {
            if ($PSBoundParameters.ContainsKey($p)) { $body[$p] = $PSBoundParameters[$p] }
        }

        if ($PSBoundParameters.ContainsKey('ownerId')) {
            $body['owner'] = [ordered]@{ id = $ownerId; kind = $ownerKind }
        }

        $Data = [ordered]@{}
        foreach ($p in 'ca_cert', 'audience', 'jwks_uri', 'public_keys', 'issuer') {
            if ($PSBoundParameters.ContainsKey($p)) { $Data[$p] = $PSBoundParameters[$p] }
        }

        $Identity = [ordered]@{}
        foreach ($p in 'claim_aliases', 'enforced_claims', 'identity_path', 'token_app_property') {
            if ($PSBoundParameters.ContainsKey($p)) { $Identity[$p] = $PSBoundParameters[$p] }
        }
        if ($Identity.Keys.Count -gt 0) { $Data['identity'] = $Identity }
        if ($Data.Keys.Count -gt 0) { $body['data'] = $Data }

        if ($PSCmdlet.ShouldProcess($name, "Create $type authenticator")) {

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 6) -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
