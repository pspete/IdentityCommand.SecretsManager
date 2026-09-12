# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Set-SMIssuer {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AWS')]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('id')]
        [String]$issuerName,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateRange(900, 43200)]
        [int]$max_ttl,

        #--- AWS ---
        [parameter(Mandatory = $true, ParameterSetName = 'AWS')]
        [ValidateLength(16, 16)]
        [String]$access_key_id,

        [parameter(Mandatory = $true, ParameterSetName = 'AWS')]
        [SecureString]$secret_access_key,

        #--- GCP ---
        [parameter(Mandatory = $true, ParameterSetName = 'GCP')]
        [ValidateLength(6, 500)]
        [String]$service_account_key_secret_ref,

        [parameter(Mandatory = $false, ParameterSetName = 'GCP')]
        [String[]]$access_token_permitted_scope
    )

    begin { }#begin

    process {

        #Only AWS and GCP issuers can be updated - Certificate Manager (PKI_VENAFI_SAAS) issuers are
        #not, matching the spec's own note on this endpoint.
        $URI = "$($ISPSSSession.tenant_url)/api/issuers/$([uri]::EscapeDataString($issuerName))"

        $body = [ordered]@{}

        if ($PSBoundParameters.ContainsKey('max_ttl')) { $body['max_ttl'] = $max_ttl }

        if ($PSCmdlet.ParameterSetName -eq 'AWS') {

            $body['data'] = [ordered]@{
                access_key_id     = $access_key_id
                secret_access_key = $(ConvertTo-InsecureString -SecureString $secret_access_key)
            }

        } elseif ($PSCmdlet.ParameterSetName -eq 'GCP') {

            $GcpData = [ordered]@{ service_account_key_secret_ref = [ordered]@{ id = $service_account_key_secret_ref } }
            if ($PSBoundParameters.ContainsKey('access_token_permitted_scope')) {
                $GcpData['access_token_permitted_scope'] = @($access_token_permitted_scope)
            }
            $body['data'] = $GcpData

        }

        if ($PSCmdlet.ShouldProcess($issuerName, 'Update Secrets Manager issuer')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body ($body | ConvertTo-SecretBody -Depth 6) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
