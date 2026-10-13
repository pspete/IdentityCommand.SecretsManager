---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# Set-SMAccessToken

## SYNOPSIS
Uses a Conjur access token obtained some other way

## SYNTAX

### Subdomain (Default)
```
Set-SMAccessToken -tenant_subdomain <String> -ConjurAccessToken <SecureString> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URL
```
Set-SMAccessToken -tenant_url <String> -ConjurAccessToken <SecureString> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sends every subsequent IdentityCommand.SecretsManager request to the given Secrets Manager / SWA tenant, authenticated with the supplied Conjur access token.

Commands normally exchange the IdentityCommand session (New-IDSession or New-IDPlatformToken) for a Conjur access token automatically, so this command is only needed when the token is obtained some other way.

Once set, the token is used until the module is imported again; later IdentityCommand sessions, and Close-IDSession, are ignored.

## EXAMPLES

### Example 1
```
Set-SMAccessToken -tenant_subdomain sometenant -ConjurAccessToken $Token
```

Resolves the Secrets Manager url for the sometenant subdomain from platform discovery, and uses the access token in $Token for subsequent requests

### Example 2
```
Set-SMAccessToken -tenant_url https://sometenant.secretsmgr.cyberark.cloud -ConjurAccessToken $Token
```

Uses the access token in $Token for subsequent requests to the given tenant url

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
The Conjur access token, as the exact value the API expects inside the Token token="..." Authorization header.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: 

Required: True
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

### None
## NOTES

## RELATED LINKS
