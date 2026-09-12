---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Get-SMTrustDomain

## SYNOPSIS
Gets SWA trust domains

## SYNTAX

### List (Default)
```
Get-SMTrustDomain [-InformationVariable <String>] [-WarningVariable <String>] [-ErrorVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-InformationAction <ActionPreference>] [-Verbose] [-offset <Int32>] [-limit <Int32>] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [-Debug] [<CommonParameters>]
```

### ByName
```
Get-SMTrustDomain [-trustDomainName] <String> [-InformationVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-ErrorVariable <String>] [-Debug] [-Verbose] [-ErrorAction <ActionPreference>] [-InformationAction <ActionPreference>] [-WarningAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Lists SWA trust domains with optional pagination, or gets a specific trust domain by name.

The response reports only the count of items returned in the page, not an overall total or next offset, so this command does not page automatically.

## EXAMPLES

### Example 1
```
Get-SMTrustDomain
```

Gets SWA trust domains

## PARAMETERS

### -trustDomainName
The name of the trust domain.

```yaml
Type: String
Parameter Sets: ByName
Aliases: name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -limit
The maximum number of items to return (default 100, max 1000).

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -offset
The number of items to skip before starting to return results (default 0).

```yaml
Type: Int32
Parameter Sets: List
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
