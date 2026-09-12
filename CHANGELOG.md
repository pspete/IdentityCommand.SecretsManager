# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Initial release of `IdentityCommand.SecretsManager`, wrapping the CyberArk Secrets Manager, SaaS
  API and the Secure Workload Access (SWA) API.
- `Connect-SMTenant`: resolve the tenant url via platform discovery or a supplied url. Secrets
  Manager/SWA authenticate with a Conjur access token rather than the CyberArk Identity bearer
  session every other companion module shares; the Identity -> Conjur exchange itself is **not**
  implemented - supply a token you have obtained separately via `-ConjurAccessToken`.
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
