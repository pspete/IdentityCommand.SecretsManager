---
title: IdentityCommand.SecretsManager
subtitle: PowerShell for Idira Secrets Manager and Secure Workload Access
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/SecretsManager/media/images/IdentityCommand.SecretsManager.png' | relative_url }}" alt="IdentityCommand.SecretsManager" width="471">
</div>

**IdentityCommand.SecretsManager** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the **Idira Secrets Manager, SaaS API** and **Secure Workload Access (SWA) API** from within the PowerShell environment.

It builds on [IdentityCommand]({{ '/' | relative_url }}) for authentication - see [Getting Started]({{ '/SecretsManager/getting-started/' | relative_url }}) to install and connect, and the [command reference]({{ '/SecretsManager/commands/' | relative_url }}) for every command.

## Groups and Workloads

```powershell
Add-SMGroupMember -identifier 'data/myapps/app-admins' -id 'data/GitHub' -kind workload
Remove-SMGroupMember -identifier 'data/myapps/app-admins' -kind workload -id 'data/GitHub'

Remove-SMWorkloadAnnotation -identifier 'data/host1' -annotationName 'env'
Remove-SMWorkload -identifier 'data/host1'
```

## Issuers and Certificates

An issuer creates dynamic secrets or certificates. The parameters that apply depend on the issuer type:

```powershell
# AWS - static access key credentials
New-SMIssuer -id 'aws-issuer-1' -access_key_id $AccessKeyId -secret_access_key $SecretAccessKey

# GCP - a reference to an already-stored service account key
New-SMIssuer -id 'gcp-issuer-1' -service_account_key_secret_ref 'data/gcp-service-account-key'

# Certificate Manager
New-SMIssuer -id 'cert-man-issuer-1' -service_account_token_url $TokenUrl `
    -user_id_secret_ref 'data/vault/my-safe/venafi/username' -password_secret_ref 'data/vault/my-safe/venafi/password' `
    -default_zone 'Idira\default' -allowed_zones 'Idira\default', 'Idira\ZTPKI'

Get-SMIssuer
Set-SMIssuer -issuerName 'aws-issuer-1' -max_ttl 3000
Remove-SMIssuer -issuerName 'aws-issuer-1'
```

Only a Certificate Manager issuer can issue or sign certificates:

```powershell
New-SMIssuedCertificate -issuerName 'cert-man-issuer-1' -common_name 'rest.example.com' -key_type EC_P256
New-SMSignedCertificate -issuerName 'cert-man-issuer-1' -csr $Csr
```

## Authenticators

```powershell
New-SMAuthenticator -type jwt -subtype gitlab -name 'my_jwt_authn1' -jwks_uri 'https://gitlab.com/oauth/discovery/keys' -audience conjur

Get-SMAuthenticator
Get-SMAuthenticator -type jwt -name 'my_jwt_authn1'

Set-SMAuthenticatorState -type jwt -name 'my_jwt_authn1' -enabled $false
Remove-SMAuthenticator -type jwt -name 'my_jwt_authn1'
```

## Secrets

```powershell
Get-SMSecretValue -id 'data/vault/mysafe/myaccount/password', 'data/static_secret'
Get-SMSecretValue -id 'data/vault/mysafe/myaccount/password' -encode_values
```

## SWA: Trust Domains, Server Groups, Node Groups and Servers

SWA registers servers into a hierarchy: a trust domain contains server groups, a server group contains node groups (which control workload identity issuance) and the servers themselves.

```powershell
New-SMTrustDomain -name 'prod.example.com' -signing_key_type EC_P256 -workload_ttl 3600

New-SMServerGroup -trustDomainName 'prod.example.com' -Name 'production-servers' `
    -aws_iid_assume_role 'SWAServerRole' -aws_iid_partition aws

New-SMNodeGroup -trustDomainName 'prod.example.com' -serverGroupName 'production-servers' `
    -Name 'production-nodes' -workload_type unix

New-SMServer -trustDomainName 'prod.example.com' -serverGroupName 'production-servers' `
    -Name 'production-server-1' -sub 'system:serviceaccount:default:my-sa' -jwks_uri 'https://k8s/.well-known/jwks'
```

```powershell
Get-SMTrustDomain
Get-SMServerGroup -trustDomainName 'prod.example.com'
Get-SMNodeGroup -trustDomainName 'prod.example.com' -serverGroupName 'production-servers'
Get-SMServer -trustDomainName 'prod.example.com' -serverGroupName 'production-servers'
```

Each level can be updated or removed - `Set-SMTrustDomain`, `Set-SMServerGroup`, `Set-SMNodeGroup`, `Set-SMServer`, and the matching `Remove-*` commands.

## SWA: Signing Keys and CA Bundles

These three are public - no authentication is required:

```powershell
Get-SMCABundle -trustDomainName 'prod.example.com' -format pem
Get-SMOpenIDConfiguration -trustDomainName 'prod.example.com'
Get-SMJwks -trustDomainName 'prod.example.com'
```
