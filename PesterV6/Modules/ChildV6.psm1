
function Get-ChildV6 {
    param (
        [string]$suffix
    )

    return "Some original child text: $suffix"
}

Export-ModuleMember -Function Get-ChildV6
