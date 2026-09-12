#The completer helper functions live in IdentityCommand's Private folder, which the psm1 loads
#into this module's scope.

#region Registration

Register-ArgumentCompleter -ParameterName 'trustDomainName' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SMTrustDomain' -ValueProperty 'name' -LabelProperty 'name'
) -CommandName 'Get-SMTrustDomain', 'Set-SMTrustDomain', 'Remove-SMTrustDomain', 'Get-SMCABundle',
'Get-SMServerGroup', 'New-SMServerGroup', 'Set-SMServerGroup', 'Remove-SMServerGroup',
'Get-SMNodeGroup', 'New-SMNodeGroup', 'Set-SMNodeGroup', 'Remove-SMNodeGroup',
'Get-SMServer', 'New-SMServer', 'Set-SMServer', 'Remove-SMServer',
'Get-SMOpenIDConfiguration', 'Get-SMJwks'

Register-ArgumentCompleter -ParameterName 'issuerName' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SMIssuer' -ValueProperty 'id' -LabelProperty 'id'
) -CommandName 'Set-SMIssuer', 'Remove-SMIssuer', 'New-SMIssuedCertificate', 'New-SMSignedCertificate'

#endregion Registration
