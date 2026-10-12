---
title: Getting Started
subtitle: Install IdentityCommand.SecretsManager and connect to Secrets Manager and Secure Workload Access
---

## Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- An Idira Identity tenant with the Secrets Manager / Secure Workload Access service enabled
- An Account to Access Idira Identity (see [Authentication](#authentication) below)
- The `IdentityCommand` module.

## Install Options

Install from the PowerShell Gallery:

```powershell
Install-Module -Name IdentityCommand.SecretsManager -Scope CurrentUser
```

Or download the [latest release](https://github.com/pspete/IdentityCommand.SecretsManager/releases), unblock and extract the archive, and copy the `IdentityCommand.SecretsManager` folder into a path listed in `$env:PSModulePath`.

## Authentication

The module requires authentication to the Idira Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SecretsManager`.

Authenticate with the `IdentityCommand` module, using `New-IDSession` (interactive user, including any MFA challenges) or `New-IDPlatformToken` (non-interactive service user). No separate connection step is needed:

```powershell
New-IDSession -tenant_url https://abc1234.id.cyberark.cloud -Credential $Credential

Get-SMAuthenticator
```

Unlike every other companion module, Secrets Manager and SWA authenticate with a **Conjur access token**, not the Identity bearer session `IdentityCommand` establishes. On first use, commands find the tenant url from the `secrets_manager` platform discovery key, then exchange the Identity session for a Conjur access token. A later `New-IDSession` or `New-IDPlatformToken` is exchanged again by the next command, and after `Close-IDSession` commands fail until you authenticate again.

To use a Conjur access token obtained some other way, set it with `Set-SMAccessToken`. Commands then use that token, whatever the Identity session, until the module is imported again:

```powershell
Set-SMAccessToken -tenant_subdomain sometenant -ConjurAccessToken $Token
```
