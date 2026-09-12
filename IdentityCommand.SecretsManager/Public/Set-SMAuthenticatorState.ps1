# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Set-SMAuthenticatorState {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('jwt', 'gcp', 'azure', 'aws_iam')]
        [String]$type,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(1, 60)]
        [String]$name,

        #Only the enabled field is currently updatable on an authenticator.
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [bool]$enabled
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/authenticators/$type/$([uri]::EscapeDataString($name))"

        $body = @{ enabled = $enabled }

        if ($PSCmdlet.ShouldProcess($name, "Set authenticator state: $(if ($enabled) { 'enable' } else { 'disable' })")) {

            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body ($body | ConvertTo-Json -Depth 2) -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
