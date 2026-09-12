# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMAuthenticator {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #Not applicable to gcp authenticators, per the service.
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('jwt', 'azure', 'aws_iam')]
        [String]$type,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(1, 60)]
        [String]$name
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/authenticators/$type/$([uri]::EscapeDataString($name))"

        if ($PSCmdlet.ShouldProcess($name, "Delete $type authenticator")) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version Beta)

        }

    }#process

    end { }#end

}
