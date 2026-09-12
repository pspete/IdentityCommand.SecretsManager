# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMOpenIDConfiguration {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/.well-known/openid-configuration"

        #This endpoint is public - no authentication is required.
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) { $result }

    }#process

    end { }#end

}
