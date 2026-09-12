# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Add-SMGroupMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(3, 500)]
        [String]$identifier,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('roleId')]
        [ValidateLength(1, 500)]
        [String]$id,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('roleKind')]
        [ValidateSet('user', 'workload', 'group')]
        [String]$kind
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/groups/$([uri]::EscapeDataString($identifier))/members"

        $body = $PSBoundParameters | Get-Parameter -ParametersToRemove identifier

        if ($PSCmdlet.ShouldProcess($identifier, "Add $kind '$id' as a group member")) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 4) -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
