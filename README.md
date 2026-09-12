# IdentityCommand.SecretsManager

**IdentityCommand.SecretsManager** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the **CyberArk Secrets Manager, SaaS API** and **Secure Workload Access (SWA) API** from within the PowerShell environment.

| Main Branch              | Latest Build             | CodeFactor                 | Coverage                     | PowerShell Gallery        | License                      |
| ------------------------ | ------------------------ | -------------------------- | ---------------------------- | ------------------------- | ---------------------------- |
| [![appveyor][]][av-site] | [![tests][]][tests-site] | [![codefactor][]][cf-site] | [![codecov][]][codecov-link] | [![psgallery][]][ps-site] | [![license][]][license-link] |

[appveyor]: https://ci.appveyor.com/api/projects/status/q2av77njofnsul92/branch/main?svg=true
[av-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SecretsManager/branch/main
[psgallery]: https://img.shields.io/powershellgallery/v/IdentityCommand.SecretsManager.svg
[ps-site]: https://www.powershellgallery.com/packages/IdentityCommand.SecretsManager
[tests]: https://img.shields.io/appveyor/tests/pspete/IdentityCommand-SecretsManager.svg
[tests-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SecretsManager
[downloads]: https://img.shields.io/powershellgallery/dt/IdentityCommand.SecretsManager.svg?color=blue
[cf-site]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SecretsManager
[codefactor]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SecretsManager/badge
[codecov]: https://codecov.io/gh/pspete/IdentityCommand.SecretsManager/branch/main/graph/badge.svg
[codecov-link]: https://codecov.io/gh/pspete/IdentityCommand.SecretsManager
[license]: https://img.shields.io/github/license/pspete/IdentityCommand.SecretsManager.svg
[license-link]: https://github.com/pspete/IdentityCommand.SecretsManager/blob/main/LICENSE

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SecretsManager`.

### Authentication

Unlike every other companion module, Secrets Manager and SWA authenticate with a **Conjur access token**, not the CyberArk Identity bearer session `IdentityCommand` establishes directly. `Connect-SMTenant` handles this automatically - it resolves the tenant url from the `secrets_manager` platform discovery key (or accepts one directly via `-tenant_url`), then exchanges the current CyberArk Identity session for a Conjur access token and stores it for you:

```powershell
Connect-SMTenant -tenant_subdomain sometenant
```

Pass `-ConjurAccessToken` instead to supply a token obtained some other way and skip the exchange call.

### Groups and Workloads

```powershell
Add-SMGroupMember -identifier 'data/myapps/app-admins' -id 'data/GitHub' -kind workload
Remove-SMGroupMember -identifier 'data/myapps/app-admins' -kind workload -id 'data/GitHub'

Remove-SMWorkloadAnnotation -identifier 'data/host1' -annotationName 'env'
Remove-SMWorkload -identifier 'data/host1'
```

### Issuers and Certificates

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

### Authenticators

```powershell
New-SMAuthenticator -type jwt -subtype gitlab -name 'my_jwt_authn1' -jwks_uri 'https://gitlab.com/oauth/discovery/keys' -audience conjur

Get-SMAuthenticator
Get-SMAuthenticator -type jwt -name 'my_jwt_authn1'

Set-SMAuthenticatorState -type jwt -name 'my_jwt_authn1' -enabled $false
Remove-SMAuthenticator -type jwt -name 'my_jwt_authn1'
```

### Secrets

```powershell
Get-SMSecretValue -id 'data/vault/mysafe/myaccount/password', 'data/static_secret'
Get-SMSecretValue -id 'data/vault/mysafe/myaccount/password' -encode_values
```

### SWA: Trust Domains, Server Groups, Node Groups and Servers

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

### SWA: Signing Keys and CA Bundles

These three are public - no authentication is required:

```powershell
Get-SMCABundle -trustDomainName 'prod.example.com' -format pem
Get-SMOpenIDConfiguration -trustDomainName 'prod.example.com'
Get-SMJwks -trustDomainName 'prod.example.com'
```

## Module Commands

| Command                       | Description                                          |
| ------------------------------ | ----------------------------------------------------- |
| `Connect-SMTenant`             | Connect to a Secrets Manager / SWA tenant             |
| `Add-SMGroupMember`            | Add a member to a group                               |
| `Remove-SMGroupMember`         | Remove a member from a group                          |
| `Remove-SMWorkloadAnnotation`  | Delete a workload annotation                          |
| `Remove-SMWorkload`            | Delete a workload                                     |
| `Get-SMIssuer`                 | Get Secrets Manager issuers                           |
| `New-SMIssuer`                 | Create a Secrets Manager issuer                       |
| `Set-SMIssuer`                 | Update a Secrets Manager issuer                       |
| `Remove-SMIssuer`              | Delete a Secrets Manager issuer                       |
| `New-SMIssuedCertificate`      | Issue a certificate                                   |
| `New-SMSignedCertificate`      | Sign a certificate from a CSR                         |
| `Get-SMAuthenticator`          | Get Secrets Manager authenticators                    |
| `New-SMAuthenticator`          | Create a Secrets Manager authenticator                |
| `Set-SMAuthenticatorState`     | Enable or disable an authenticator                    |
| `Remove-SMAuthenticator`       | Delete a Secrets Manager authenticator                |
| `Get-SMSecretValue`            | Retrieve multiple secret values                       |
| `Get-SMTrustDomain`            | Get SWA trust domains                                 |
| `New-SMTrustDomain`            | Register a SWA trust domain                           |
| `Set-SMTrustDomain`            | Update a SWA trust domain                             |
| `Remove-SMTrustDomain`         | Delete a SWA trust domain                             |
| `Get-SMCABundle`               | Get SWA CA bundles                                    |
| `Get-SMServerGroup`            | Get SWA server groups                                 |
| `New-SMServerGroup`            | Create a SWA server group                             |
| `Set-SMServerGroup`            | Update a SWA server group                             |
| `Remove-SMServerGroup`         | Delete a SWA server group                             |
| `Get-SMNodeGroup`              | Get SWA node groups                                   |
| `New-SMNodeGroup`              | Create a SWA node group                               |
| `Set-SMNodeGroup`              | Update a SWA node group                               |
| `Remove-SMNodeGroup`           | Delete a SWA node group                               |
| `Get-SMServer`                 | Get SWA servers                                       |
| `New-SMServer`                 | Register a SWA server                                 |
| `Set-SMServer`                 | Update a SWA server                                   |
| `Remove-SMServer`              | Delete a SWA server                                   |
| `Get-SMOpenIDConfiguration`    | Get the OpenID Connect discovery document             |
| `Get-SMJwks`                   | Get the JWKS document                                 |
| `Get-SMModuleData`             | Get the module version & session configuration data   |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant with the Secrets Manager / Secure Workload Access service enabled
- An Account to Access CyberArk Identity (see [Authentication](#authentication) above)

### Install Options

Users can install IdentityCommand.SecretsManager from GitHub or the PowerShell Gallery.

Choose any of the following ways to download the module and install it:

#### Option 1: Install from PowerShell Gallery

This is the easiest and most popular way to install the module:

1. Open a PowerShell prompt

2. Run the following command:

```powershell
Install-Module -Name IdentityCommand.SecretsManager -Scope CurrentUser
```

#### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand.SecretsManager`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

##### PowerShell Gallery

- Download from the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/IdentityCommand.SecretsManager/):
  - Run the PowerShell command `Save-Module -Name IdentityCommand.SecretsManager -Path C:\temp`
  - Copy the `C:\temp\IdentityCommand.SecretsManager` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.SecretsManager Release

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand.SecretsManager/releases/latest)
  - Unblock & Extract the archive
  - Rename the extracted `IdentityCommand.SecretsManager-v#.#.#` folder to `IdentityCommand.SecretsManager`
  - Copy the `IdentityCommand.SecretsManager` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.SecretsManager Branch

- [Download the `main` branch](https://github.com/pspete/IdentityCommand.SecretsManager/archive/refs/heads/main.zip)
  - Unblock & Extract the archive
  - Copy the `IdentityCommand.SecretsManager` (`\<Archive Root>\IdentityCommand.SecretsManager-main\IdentityCommand.SecretsManager`) folder to your "Powershell Modules" directory of choice.

#### Verification

Validate Install:

```powershell

Get-Module -ListAvailable IdentityCommand.SecretsManager

```

Import the module:

```powershell

Import-Module IdentityCommand.SecretsManager

```

List Module Commands:

```powershell

Get-Command -Module IdentityCommand.SecretsManager

```

Get detailed information on specific commands:

```powershell

Get-Help Connect-SMTenant -Full

```

## Sponsorship

Please support continued development; consider sponsoring <a href="https://github.com/sponsors/pspete"> @pspete on GitHub Sponsors</a>

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE.md).

## Contributing

Any and all contributions to this project are appreciated.

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a few more details.

## Support

_IdentityCommand.SecretsManager_ is neither developed nor supported by CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand.SecretsManager_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand.SecretsManager/issues/new

Priority support could be considered for <a href="https://github.com/sponsors/pspete">sponsors of @pspete</a>, <a href="mailto:pspete@pspete.dev">contact us</a> to discuss options.
