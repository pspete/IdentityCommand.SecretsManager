# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMGroupMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(3, 500)]
        [String]$identifier,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('roleId')]
        [ValidateLength(1, 1000)]
        [String]$id,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('roleKind')]
        [ValidateSet('workload', 'user', 'group')]
        [String]$kind
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/groups/$([uri]::EscapeDataString($identifier))/members/$kind/$([uri]::EscapeDataString($id))"

        if ($PSCmdlet.ShouldProcess($identifier, "Remove $kind '$id' as a group member")) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version Beta)

        }

    }#process

    end { }#end

}
