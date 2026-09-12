---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Set-SMNodeGroup

## SYNOPSIS
Updates a SWA node group

## SYNTAX

```
Set-SMNodeGroup [-nodeGroupName] <String> [-serverGroupName] <String> [-trustDomainName] <String> [-WarningVariable <String>] [-ErrorVariable <String>] [-InformationAction <ActionPreference>] [-InformationVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-workload_registration_policies <String[]>] [-spiffe_id_template <String>] [-description <String>] [-Verbose] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [-Debug] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the description and/or workload configuration of a SWA node group. The name, workload type and parent server group cannot be changed after creation.

## EXAMPLES

### Example 1
```
Set-SMNodeGroup
```

Updates a SWA node group

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

### -nodeGroupName
The name of the node group.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -spiffe_id_template
A Go template for workload SPIFFE IDs.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -workload_registration_policies
CEL expressions - at least one must evaluate to true for SWA to issue an SVID to a workload.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
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
