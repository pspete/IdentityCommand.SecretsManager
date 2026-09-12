# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMServerGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))"

        #Deletes every server in the group and their related Secrets Manager resources along with it.
        if ($PSCmdlet.ShouldProcess($serverGroupName, 'Delete SWA server group')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version V2)

        }

    }#process

    end { }#end

}
