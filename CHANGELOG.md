# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Commands find the Secrets Manager service url from the `IdentityCommand` session on first use, so no connection step is needed after `New-IDSession` or `New-IDPlatformToken`. Commands follow a later `New-IDSession` or `New-IDPlatformToken`, and fail after `Close-IDSession` until you authenticate again. The Conjur access token exchange runs on first use and again after each re-authentication.
- `Set-SMAccessToken`, to use a Conjur access token obtained some other way.

### Changed

- Requires `IdentityCommand` 1.0.1.
- A request refused with 401 because the session token has expired reports `Session expired at <time>:
  authenticate again with New-IDSession or New-IDPlatformToken`. Previously, it reported `Unauthorized. Unauthorized.`.
- CI caches the PowerShell modules it installs, so dependency installs skip the PowerShell Gallery on a cache hit.

### Removed

- `Connect-SMTenant`. Authenticate with `New-IDSession` or `New-IDPlatformToken` from `IdentityCommand` instead.

## [0.1.0] - 2026-10-07

### Fixed

- `Connect-SMTenant` now performs the CyberArk Identity -> Conjur access token exchange
  automatically, using the same bearer-authenticated session every other companion module shares -
  no manual token is required for the common case. `-ConjurAccessToken` remains as an optional
  override for a token obtained some other way.

### Added

- Initial release of `IdentityCommand.SecretsManager`, wrapping the CyberArk Secrets Manager, SaaS
  API and the Secure Workload Access (SWA) API.
- `Connect-SMTenant`: resolve the tenant url via platform discovery or a supplied url, then exchange
  the CyberArk Identity session for a Conjur access token and set it as the module's authentication
  header.
- Groups and workloads: `Add-SMGroupMember`, `Remove-SMGroupMember`, `Remove-SMWorkloadAnnotation`,
  `Remove-SMWorkload`.
- Issuers: `Get-`, `New-`, `Set-`, `Remove-SMIssuer` (AWS, GCP and Certificate Manager issuer
  types), plus `New-SMIssuedCertificate` and `New-SMSignedCertificate` for Certificate Manager
  issuers.
- Authenticators: `Get-`, `New-`, `Remove-SMAuthenticator` and `Set-SMAuthenticatorState`.
- `Get-SMSecretValue`: batch retrieval of up to 250 secret values.
- SWA trust domains: `Get-`, `New-`, `Set-`, `Remove-SMTrustDomain` and `Get-SMCABundle`.
- SWA server groups: `Get-`, `New-`, `Set-`, `Remove-SMServerGroup`, including GCP service account
  and AWS instance identity document node attestation.
- SWA node groups: `Get-`, `New-`, `Set-`, `Remove-SMNodeGroup`.
- SWA servers: `Get-`, `New-`, `Set-`, `Remove-SMServer`.
- SWA signing keys: `Get-SMOpenIDConfiguration` and `Get-SMJwks` - both public, requiring no
  authentication.
- `Get-SMModuleData`: get the module version and session configuration data.

