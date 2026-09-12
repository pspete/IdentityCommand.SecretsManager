# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Get-SMAuthenticator {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'ById')]
        [ValidateSet('jwt', 'gcp', 'azure', 'aws_iam')]
        [String]$type,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true, ParameterSetName = 'ById')]
        [ValidateLength(1, 60)]
        [String]$name
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'ById') {

            $URI = "$($ISPSSSession.tenant_url)/authenticators/$type/$([uri]::EscapeDataString($name))"

            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result

            }

        } else {

            $URI = "$($ISPSSSession.tenant_url)/authenticators"

            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version Beta)

            if ($null -ne $result) {

                $result.authenticators

            }

        }

    }#process

    end { }#end

}
