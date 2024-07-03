Import-Module "$PSScriptRoot\ChildV3.psm1"

function Get-ParentV3 {
    param (
        [string]$prefix,
        [string]$suffix
    )

    $childResult = Get-ChildV3 -suffix $suffix
    return "$prefix : $childResult"
}

Export-ModuleMember -Function Get-ParentV3
