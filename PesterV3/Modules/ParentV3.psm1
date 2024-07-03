Import-Module "$PSScriptRoot\ChildV3.psm1"

function Get-Parent {
    param (
        [string]$prefix,
        [string]$suffix
    )

    $childResult = Get-Child -suffix $suffix
    return "$prefix : $childResult"
}

Export-ModuleMember -Function Get-Parent
