# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMServer {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'ByName')]
        [String]$serverName,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'List')]
        [ValidateRange(1, 1000)]
        [int]$limit,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'List')]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$offset
    )

    begin { }#begin

    process {

        $BaseURI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))/components"

        if ($PSCmdlet.ParameterSetName -eq 'ByName') {

            $URI = "$BaseURI/$([uri]::EscapeDataString($serverName))"
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) { $result }

        } else {

            $URI = Add-QueryString -URI $BaseURI -Parameter ($PSBoundParameters | Get-Parameter -ParametersToRemove trustDomainName, serverGroupName)
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) { $result.components }

        }

    }#process

    end { }#end

}
