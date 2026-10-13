function Get-SMConjurToken {
    <#
    .SYNOPSIS
    Exchanges the CyberArk Identity session for a Conjur access token.

    .DESCRIPTION
    Posts to the Secrets Manager Conjur OIDC authenticator with the CyberArk Identity session held
    in the module session, and returns the Conjur access token response base64 encoded, as the
    value the API expects inside Authorization: Token token="...".

    Conjur accepts the same bearer authenticated WebSession every other companion module copies from
    Get-IDSession - no id_token, cookie or CSRF header is required.

    .EXAMPLE
    Get-SMConjurToken
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param()

    $URI = "$($ISPSSSession.tenant_url)/api/authn-oidc/cyberark/conjur/authenticate?set_conjur_cookie=true"

    $ConjurResponse = Invoke-IDRestMethod -Method POST -URI $URI

    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(($ConjurResponse | ConvertTo-Json -Compress -Depth 3)))

}
