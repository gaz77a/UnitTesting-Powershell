Import-Module "$PSScriptRoot\ChildV6.psm1"

function Get-ParentV6 {
    param (
        [string]$prefix,
        [string]$suffix
    )

    $childResult = Get-ChildV6 -suffix $suffix
    return "$prefix : $childResult"
}

Export-ModuleMember -Function Get-ParentV6
