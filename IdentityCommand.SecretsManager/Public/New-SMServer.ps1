# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMServer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('serverName')]
        [ValidateLength(1, 51)]
        [String]$Name,

        #Subject claim value from the workload JWT identifying this server.
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$sub,

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
        [String]$token_app_property
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))/components"

        $Data = [ordered]@{ sub = $sub }
        foreach ($p in 'ca_cert', 'audience', 'jwks_uri', 'public_keys', 'issuer') {
            if ($PSBoundParameters.ContainsKey($p)) { $Data[$p] = $PSBoundParameters[$p] }
        }

        $Identity = [ordered]@{}
        foreach ($p in 'claim_aliases', 'enforced_claims', 'identity_path', 'token_app_property') {
            if ($PSBoundParameters.ContainsKey($p)) { $Identity[$p] = $PSBoundParameters[$p] }
        }
        if ($Identity.Keys.Count -gt 0) { $Data['identity'] = $Identity }
        $body = [ordered]@{
            name           = $Name
            authentication = [ordered]@{
                type = 'JWT'
                data = $Data
            }
        }

        if ($PSCmdlet.ShouldProcess($Name, 'Register SWA server')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 6) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) { $result }

        }

    }#process

    end { }#end

}
