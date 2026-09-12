# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function Set-SMNodeGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('name')]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$serverGroupName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$nodeGroupName,

        #The name, workload_type and parent server group cannot be changed after creation.
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$description,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$spiffe_id_template,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$workload_registration_policies
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups/$([uri]::EscapeDataString($serverGroupName))/node-groups/$([uri]::EscapeDataString($nodeGroupName))"

        $body = [ordered]@{}
        if ($PSBoundParameters.ContainsKey('description')) { $body['description'] = $description }

        $WorkloadConfig = [ordered]@{}
        if ($PSBoundParameters.ContainsKey('spiffe_id_template')) { $WorkloadConfig['spiffe_id_template'] = $spiffe_id_template }
        if ($PSBoundParameters.ContainsKey('workload_registration_policies')) { $WorkloadConfig['workload_registration_policies'] = @($workload_registration_policies) }
        if ($WorkloadConfig.Keys.Count -gt 0) { $body['workload_configuration'] = $WorkloadConfig }

        if ($PSCmdlet.ShouldProcess($nodeGroupName, 'Update SWA node group')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body ($body | ConvertTo-Json -Depth 5) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) { $result }

        }

    }#process

    end { }#end

}
