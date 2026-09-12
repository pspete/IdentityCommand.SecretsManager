# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMNodeGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$nodeGroupName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))/node-groups/$([uri]::EscapeDataString($nodeGroupName))"

        if ($PSCmdlet.ShouldProcess($nodeGroupName, 'Delete SWA node group')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version V2)

        }

    }#process

    end { }#end

}
