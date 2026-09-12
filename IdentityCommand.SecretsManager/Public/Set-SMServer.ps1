# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Set-SMServer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverName,

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

        #The sub claim and authentication type are not updatable, matching the spec's own note.
        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))/components/$([uri]::EscapeDataString($serverName))"

        $Data = [ordered]@{}
        foreach ($p in 'ca_cert', 'audience', 'jwks_uri', 'public_keys', 'issuer') {
            if ($PSBoundParameters.ContainsKey($p)) { $Data[$p] = $PSBoundParameters[$p] }
        }

        $Identity = [ordered]@{}
        foreach ($p in 'claim_aliases', 'enforced_claims', 'identity_path', 'token_app_property') {
            if ($PSBoundParameters.ContainsKey($p)) { $Identity[$p] = $PSBoundParameters[$p] }
        }
        if ($Identity.Keys.Count -gt 0) { $Data['identity'] = $Identity }
        $Authentication = [ordered]@{}
        if ($Data.Keys.Count -gt 0) { $Authentication['data'] = $Data }
        if ($PSBoundParameters.ContainsKey('annotations')) { $Authentication['annotations'] = $annotations }

        if ($Authentication.Keys.Count -eq 0) {
            throw 'Supply at least one setting to update'
        }

        $body = [ordered]@{ authentication = $Authentication }

        if ($PSCmdlet.ShouldProcess($serverName, 'Update SWA server')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body ($body | ConvertTo-Json -Depth 6) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) { $result }

        }

    }#process

    end { }#end

}
