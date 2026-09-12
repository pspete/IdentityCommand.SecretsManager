# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMIssuer {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'password_secret_ref', Justification = 'Reference to an existing stored secret, not the secret itself')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUsernameAndPasswordParams', '', Justification = 'user_id_secret_ref/password_secret_ref are references to existing stored secrets, not credentials')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AWS')]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('issuerName')]
        [ValidateLength(1, 60)]
        [String]$id,

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
        [String[]]$access_token_permitted_scope,

        #--- PKI_VENAFI_SAAS ---
        [parameter(Mandatory = $true, ParameterSetName = 'VenafiSaaS')]
        [String]$service_account_token_url,

        [parameter(Mandatory = $true, ParameterSetName = 'VenafiSaaS')]
        [String]$user_id_secret_ref,

        [parameter(Mandatory = $true, ParameterSetName = 'VenafiSaaS')]
        [String]$password_secret_ref,

        [parameter(Mandatory = $true, ParameterSetName = 'VenafiSaaS')]
        [String]$default_zone,

        [parameter(Mandatory = $true, ParameterSetName = 'VenafiSaaS')]
        [String[]]$allowed_zones
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/issuers/conjur"

        $data = switch ($PSCmdlet.ParameterSetName) {

            'AWS' {
                [ordered]@{
                    access_key_id     = $access_key_id
                    secret_access_key = $(ConvertTo-InsecureString -SecureString $secret_access_key)
                }
            }

            'GCP' {
                $GcpData = [ordered]@{ service_account_key_secret_ref = [ordered]@{ id = $service_account_key_secret_ref } }
                if ($PSBoundParameters.ContainsKey('access_token_permitted_scope')) {
                    $GcpData['access_token_permitted_scope'] = @($access_token_permitted_scope)
                }
                $GcpData
            }

            'VenafiSaaS' {
                [ordered]@{
                    service_account_token_url = $service_account_token_url
                    identity_user_details     = [ordered]@{
                        user_id_secret_ref   = [ordered]@{ id = $user_id_secret_ref }
                        password_secret_ref  = [ordered]@{ id = $password_secret_ref }
                    }
                    default_zone              = $default_zone
                    allowed_zones             = @($allowed_zones)
                }
            }

        }

        $Type = switch ($PSCmdlet.ParameterSetName) {
            'AWS' { 'AWS' }
            'GCP' { 'GCP' }
            'VenafiSaaS' { 'PKI_VENAFI_SAAS' }
        }

        $body = [ordered]@{ id = $id; type = $Type; data = $data }

        if ($PSBoundParameters.ContainsKey('max_ttl')) { $body['max_ttl'] = $max_ttl }

        if ($PSCmdlet.ShouldProcess($id, 'Create Secrets Manager issuer')) {

            #Secrets carried in -data (AWS secret_access_key) are decoded above, so the body travels
            #as UTF8 bytes rather than a String.
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-SecretBody -Depth 6) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
