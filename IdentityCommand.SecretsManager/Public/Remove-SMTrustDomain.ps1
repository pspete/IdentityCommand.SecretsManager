# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Remove-SMTrustDomain {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))"

        #Deletes every resource inside the trust domain along with it.
        if ($PSCmdlet.ShouldProcess($trustDomainName, 'Delete SWA trust domain')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SMApiHeader -Version V2)

        }

    }#process

    end { }#end

}
