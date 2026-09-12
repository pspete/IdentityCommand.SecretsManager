# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMIssuer {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'ById')]
        [Alias('id')]
        [String]$issuerName
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'ById') {

            $URI = "$($ISPSSSession.tenant_url)/api/issuers/$([uri]::EscapeDataString($issuerName))"

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result

            }

        } else {

            $URI = "$($ISPSSSession.tenant_url)/api/issuers/conjur"

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) {

                $result.issuers

            }

        }

    }#process

    end { }#end

}
