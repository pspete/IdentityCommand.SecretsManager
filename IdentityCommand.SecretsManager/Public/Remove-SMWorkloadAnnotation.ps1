# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMWorkloadAnnotation {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(3, 500)]
        [String]$identifier,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(1, 1000)]
        [String]$annotationName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/workloads/$([uri]::EscapeDataString($identifier))/annotations/$([uri]::EscapeDataString($annotationName))"

        if ($PSCmdlet.ShouldProcess($identifier, "Remove annotation '$annotationName'")) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version Beta)

        }

    }#process

    end { }#end

}
