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

Unlike every other companion module, Secrets Manager and SWA authenticate with a **Conjur access token**, not the Idira Identity bearer session `IdentityCommand` establishes directly. `Connect-SMTenant` handles this automatically - it resolves the tenant url from the `secrets_manager` platform discovery key (or accepts one directly via `-tenant_url`), then exchanges the current Idira Identity session for a Conjur access token and stores it for you:

```powershell
Connect-SMTenant -tenant_subdomain sometenant
```

Pass `-ConjurAccessToken` instead to supply a token obtained some other way and skip the exchange call.
