# .ExternalHelp IdentityCommand.SecretsManager-help.xml

function New-SMServerGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [String]$trustDomainName,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('serverGroupName')]
        [ValidateLength(1, 60)]
        [String]$Name,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateLength(0, 1024)]
        [String]$description,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$gcp_service_account_allowed_project_ids,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$gcp_service_account_audiences,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$aws_iid_assume_role,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('aws', 'aws-cn', 'aws-us-gov')]
        [String]$aws_iid_partition,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$aws_iid_management_account_id,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$aws_iid_management_account_region,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$aws_iid_assume_org_role,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$aws_iid_org_account_map_ttl,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String]$aws_iid_account_list_file
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/swa/trust-domains/$([uri]::EscapeDataString($trustDomainName))/server-groups"

        $body = [ordered]@{ name = $Name }
        if ($PSBoundParameters.ContainsKey('description')) { $body['description'] = $description }

        $Attestation = [ordered]@{}

        if ($PSBoundParameters.ContainsKey('gcp_service_account_allowed_project_ids')) {
            $Gcp = [ordered]@{ allowed_project_ids = @($gcp_service_account_allowed_project_ids) }
            if ($PSBoundParameters.ContainsKey('gcp_service_account_audiences')) {
                $Gcp['audiences'] = @($gcp_service_account_audiences)
            }
            $Attestation['gcp_service_account'] = $Gcp
        }

        $AwsIidParams = 'aws_iid_assume_role', 'aws_iid_partition'
        if (($AwsIidParams | Where-Object { $PSBoundParameters.ContainsKey($_) }) -or
            ($PSBoundParameters.ContainsKey('aws_iid_management_account_id'))) {

            $AwsIid = [ordered]@{}
            if ($PSBoundParameters.ContainsKey('aws_iid_assume_role')) { $AwsIid['assume_role'] = $aws_iid_assume_role }
            if ($PSBoundParameters.ContainsKey('aws_iid_partition')) { $AwsIid['partition'] = $aws_iid_partition }

            $VerifyOrg = [ordered]@{}
            foreach ($p in 'management_account_id', 'management_account_region', 'assume_org_role', 'org_account_map_ttl', 'account_list_file') {
                $ParamName = "aws_iid_$p"
                if ($PSBoundParameters.ContainsKey($ParamName)) { $VerifyOrg[$p] = $PSBoundParameters[$ParamName] }
            }
            if ($VerifyOrg.Keys.Count -gt 0) { $AwsIid['verify_organization'] = $VerifyOrg }

            $Attestation['aws_iid'] = $AwsIid

        }
        if ($Attestation.Keys.Count -gt 0) { $body['attestation'] = $Attestation }

        if ($PSCmdlet.ShouldProcess($Name, 'Create SWA server group')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body ($body | ConvertTo-Json -Depth 6) -Accept $(Get-SMApiHeader -Version V2)

            if ($null -ne $result) { $result }

        }

    }#process

    end { }#end

}
