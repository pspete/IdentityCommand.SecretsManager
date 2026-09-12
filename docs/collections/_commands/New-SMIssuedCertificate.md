---
external help file: IdentityCommand.SecretsManager-help.xml
Module Name: IdentityCommand.SecretsManager
online version:
schema: 2.0.0
---

# New-SMIssuedCertificate

## SYNOPSIS
Issues a certificate

## SYNTAX

```
New-SMIssuedCertificate [-common_name] <String> [-issuerName] <String> [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-InformationAction <ActionPreference>] [-ignore_storage <Boolean>] [-Verbose] [-Debug] [-OutVariable <String>] [-OutBuffer <Int32>] [-PipelineVariable <String>] [-ErrorVariable <String>] [-WarningVariable <String>] [-InformationVariable <String>] [-state <String>] [-country <String>] [-key_type <String>] [-organization <String>] [-org_units <String[]>] [-locality <String>] [-uris <String[]>] [-ttl <String>] [-zone <String>] [-dns_names <String[]>] [-ip_addresses <String[]>] [-email_addresses <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a CSR and certificate using the specified issuer (a Certificate Manager issuer).

## EXAMPLES

### Example 1
```
New-SMIssuedCertificate
```

Issues a certificate

## PARAMETERS

### -issuerName
The name of the issuer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -common_name
The fully qualified domain name (FQDN) or identifier associated with the certificate.

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

### -organization
The name of the organization owning the certificate.

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

### -org_units
Subdivisions of the organization, often used to identify departments or teams.

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

### -locality
The city or locality where the organization is located.

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

### -state
The state or province where the organization is located.

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

### -country
The two-letter ISO country code representing the organization's location.

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

### -key_type
The key algorithm and size, or elliptic curve, for the certificate.

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

### -dns_names
DNS names to include in the certificate SANs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ip_addresses
IP addresses to include in the certificate SANs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -email_addresses
Email addresses to include in the certificate SANs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -uris
URIs to include in the certificate SANs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ttl
Time-to-live for the certificate, as an ISO 8601 duration (for example, P30D).

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -zone
The Certificate Manager zone used to issue the certificate.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ignore_storage
Whether to retrieve the certificate from Secrets Manager's cache or generate a new one using Certificate Manager.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: 14
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
