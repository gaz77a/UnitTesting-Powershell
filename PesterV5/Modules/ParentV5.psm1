Import-Module "$PSScriptRoot\ChildV5.psm1"

function Get-ParentV5 {
    param (
        [string]$prefix,
        [string]$suffix
    )

    $childResult = Get-ChildV5 -suffix $suffix
    return "$prefix : $childResult"
}

Export-ModuleMember -Function Get-ParentV5
