
function Get-ChildV3 {
    param (
        [string]$suffix
    )

    return "Some original child text: $suffix"
}

Export-ModuleMember -Function Get-ChildV3
