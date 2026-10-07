#region Loader
<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>
[CmdletBinding()]
param(

    [bool]$DotSourceModule = $false

)

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.ps1xml' |

    ForEach-Object {

        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }

#endregion Loader

#Copy IdentityCommand's private helpers into this module: this module's functions call them, and
#the argument completer registrations below do so at import time.
#Each copy is created from the function definition, so it runs in this module's scope and uses this
#module's $ISPSSSession, whether IdentityCommand loaded from source or from its combined psm1.
#Resolve a single IdentityCommand module: with more than one version loaded, Get-Module returns
#an array.
$Module = Get-Module -Name IdentityCommand | Sort-Object Version -Descending | Select-Object -First 1

if ($null -eq $Module) {
    throw 'The IdentityCommand module is not loaded. Import IdentityCommand and try again.'
}

& $Module { Get-ChildItem -Path Function: } |

    Where-Object { $_.ModuleName -eq $Module.Name -and -not $Module.ExportedFunctions.ContainsKey($_.Name) } |

    ForEach-Object {

        . ([scriptblock]::Create("function $($_.Name) {$($_.Definition)}"))

    }

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

# Script scope session object for session data
$ISPSSSession = [ordered]@{
    tenant_url         = $null
    User               = $null
    TenantId           = $null
    SessionId          = $null
    WebSession         = $null
    StartTime          = $null
    ElapsedTime        = $null
    LastCommand        = $null
    LastCommandTime    = $null
    LastCommandResults = $null
    LastError          = $null
    LastErrorTime      = $null
} | Add-CustomType -Type IdCmd.Session

New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force