---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Set-SMIssuer

## SYNOPSIS
Updates a Secrets Manager issuer

## SYNTAX

### AWS (Default)
```
Set-SMIssuer [-access_key_id] <String> [-secret_access_key] <SecureString> [-issuerName] <String> [-InformationVariable <String>] [-WarningVariable <String>] [-ErrorVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-Debug] [-Verbose] [-max_ttl <Int32>] [-InformationAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### GCP
```
Set-SMIssuer [-service_account_key_secret_ref] <String> [-issuerName] <String> [-InformationVariable <String>] [-WarningVariable <String>] [-ErrorVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-InformationAction <ActionPreference>] [-Verbose] [-access_token_permitted_scope <String[]>] [-max_ttl <Int32>] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [-Debug] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates an AWS or GCP issuer. Certificate Manager (PKI_VENAFI_SAAS) issuers cannot be updated.

## EXAMPLES

### Example 1
```
Set-SMIssuer
```

Updates a Secrets Manager issuer

## PARAMETERS

### -issuerName
The name of the issuer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -max_ttl
The maximum time-to-live, in seconds, of dynamic secrets created with this issuer.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -access_key_id
AWS account access key.

```yaml
Type: String
Parameter Sets: AWS
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secret_access_key
AWS account secret key.

```yaml
Type: SecureString
Parameter Sets: AWS
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -service_account_key_secret_ref
The Secrets Manager secret ID (full pathname) of the stored GCP service account key.

```yaml
Type: String
Parameter Sets: GCP
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -access_token_permitted_scope
The scopes that the GCP issuer is permitted to access.

```yaml
Type: String[]
Parameter Sets: GCP
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
