# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMServer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverName
    )

    begin { }#begin

    process {

        $URI = "$(Resolve-RequestUrl)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))/components/$([uri]::EscapeDataString($serverName))"

        if ($PSCmdlet.ShouldProcess($serverName, 'Delete SWA server')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version V2)

        }

    }#process

    end { }#end

}
