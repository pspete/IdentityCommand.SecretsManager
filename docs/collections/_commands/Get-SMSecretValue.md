---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Get-SMSecretValue

## SYNOPSIS
Retrieves multiple secret values

## SYNTAX

```
Get-SMSecretValue [-id] <String[]> [-InformationVariable <String>] [-WarningVariable <String>] [-ErrorVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-Debug] [-Verbose] [-encode_values] [-InformationAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Fetches up to 250 secret values in a single call. Secrets are returned in the order requested; only secrets the caller has execute permission for are returned.

## EXAMPLES

### Example 1
```
Get-SMSecretValue
```

Retrieves multiple secret values

## PARAMETERS

### -id
The secret IDs to retrieve (1-250).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ids

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -encode_values
Base64-encode every returned secret value.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
