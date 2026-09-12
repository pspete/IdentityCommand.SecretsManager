---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Set-SMServerGroup

## SYNOPSIS
Updates a SWA server group

## SYNTAX

```
Set-SMServerGroup [-serverGroupName] <String> [-trustDomainName] <String> [-InformationAction <ActionPreference>] [-ErrorVariable <String>] [-WarningAction <ActionPreference>] [-Debug] [-ErrorAction <ActionPreference>] [-OutBuffer <Int32>] [-PipelineVariable <String>] [-OutVariable <String>] [-WarningVariable <String>] [-InformationVariable <String>] [-Verbose] [-aws_iid_assume_role <String>] [-aws_iid_partition <String>] [-gcp_service_account_audiences <String[]>] [-description <String>] [-gcp_service_account_allowed_project_ids <String[]>] [-aws_iid_org_account_map_ttl <String>] [-aws_iid_account_list_file <String>] [-aws_iid_assume_org_role <String>] [-aws_iid_management_account_id <String>] [-aws_iid_management_account_region <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the description and/or attestation settings of a SWA server group.

## EXAMPLES

### Example 1
```
Set-SMServerGroup
```

Updates a SWA server group

## PARAMETERS

### -trustDomainName
The name of the trust domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -serverGroupName
The name of the server group.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
A description of the resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -gcp_service_account_allowed_project_ids
The GCP project IDs allowed for GCP service account attestation.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -gcp_service_account_audiences
Expected audience values for the GCP identity token (aud claim).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_assume_role
Bare IAM role name (optionally path-prefixed) describing the attesting AWS instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_partition
The AWS partition the server operates in.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_management_account_id
12-digit AWS account ID of the organization's management (root) account.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_management_account_region
AWS region where the management account is hosted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_assume_org_role
IAM role name in the management account with organizations:ListAccounts permissions.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_org_account_map_ttl
Cache TTL duration for the organization account list, as a Go duration string (for example, 15m).

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_iid_account_list_file
Path on the SWA server host/container to a file listing allowed AWS account IDs.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
