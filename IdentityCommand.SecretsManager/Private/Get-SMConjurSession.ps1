function Get-SMConjurSession {
    <#
    .SYNOPSIS
    Returns a WebRequestSession which authenticates with a Conjur access token.

    .DESCRIPTION
    Secrets Manager / SWA authenticate with a Conjur access token, not the CyberArk Identity bearer
    session every other companion module shares. The token is set on a new WebRequestSession, rather
    than on the session copied from Get-IDSession, so this module's requests do not mutate (or get
    mutated by) the shared IdentityCommand session.

    .PARAMETER Token
    The Conjur access token, as the exact value the API expects inside Authorization: Token token="...".

    .EXAMPLE
    $ISPSSSession.WebSession = Get-SMConjurSession -Token $Token
    #>
    [OutputType([Microsoft.PowerShell.Commands.WebRequestSession])]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $WebSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $WebSession.Headers['Authorization'] = "Token token=`"$Token`""

    $WebSession

}
