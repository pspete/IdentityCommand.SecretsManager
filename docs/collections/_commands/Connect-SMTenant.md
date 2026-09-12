---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Connect-SMTenant

## SYNOPSIS
Connects to a Secrets Manager / SWA tenant

## SYNTAX

### Subdomain (Default)
```
Connect-SMTenant [-tenant_subdomain] <String> [-InformationVariable <String>] [-WarningVariable <String>] [-ErrorVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-Debug] [-Verbose] [-ConjurAccessToken <SecureString>] [-InformationAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URL
```
Connect-SMTenant [-tenant_url] <String> [-InformationVariable <String>] [-WarningVariable <String>] [-ErrorVariable <String>] [-PipelineVariable <String>] [-OutBuffer <Int32>] [-OutVariable <String>] [-Debug] [-Verbose] [-ConjurAccessToken <SecureString>] [-InformationAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Connects to the Secrets Manager, SaaS and Secure Workload Access (SWA) APIs to be able to run IdentityCommand.SecretsManager module commands against them.

Provide either the ISPSS shared services subdomain (the tenant url is resolved automatically via platform discovery) or the tenant url directly.

These APIs authenticate with a Conjur access token rather than the CyberArk Identity bearer session every other companion module shares. **The CyberArk Identity -> Conjur access token exchange is not implemented by this module** - supply an access token you have obtained separately via `-ConjurAccessToken`. Without one, every subsequent request fails; a warning is raised to make this explicit.

## EXAMPLES

### Example 1
```
Connect-SMTenant
```

Connects to a Secrets Manager / SWA tenant

## PARAMETERS

### -tenant_subdomain
The ISPSS shared services subdomain of the tenant. The tenant url is resolved from platform discovery.

```yaml
Type: String
Parameter Sets: Subdomain
Aliases: subdomain

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tenant_url
The url of the Secrets Manager / SWA tenant.

```yaml
Type: String
Parameter Sets: URL
Aliases: secretsmgr_url

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ConjurAccessToken
The Conjur access token obtained from the CyberArk Identity -> Conjur exchange, as the raw JWT. This command wraps it in the Token token="..." Authorization header format.

```yaml
Type: SecureString
Parameter Sets: (All)
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
