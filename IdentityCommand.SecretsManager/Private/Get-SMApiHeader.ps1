function Get-SMApiHeader {
    <#
    .SYNOPSIS
    Returns the Accept header value for a Secrets Manager / SWA API request.

    .DESCRIPTION
    Every request in both specs carries an Accept header naming its API version - the stable
    `application/x.secretsmgr.v2+json`, or the beta `application/x.secretsmgr.v2beta+json` for
    endpoints the spec marks APIv2 beta. This holds both values so a command names which one it
    needs rather than hardcoding the media type string.

    .PARAMETER Version
    'V2' for the stable API, 'Beta' for APIv2 beta endpoints.

    .EXAMPLE
    Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SMApiHeader -Version Beta)
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('V2', 'Beta')]
        [string]$Version
    )

    switch ($Version) {
        'V2' { 'application/x.secretsmgr.v2+json' }
        'Beta' { 'application/x.secretsmgr.v2beta+json' }
    }

}
