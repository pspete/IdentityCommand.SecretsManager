# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMWorkload {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(3, 500)]
        [String]$identifier
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/workloads/$([uri]::EscapeDataString($identifier))"

        if ($PSCmdlet.ShouldProcess($identifier, 'Delete workload')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version Beta)

        }

    }#process

    end { }#end

}
