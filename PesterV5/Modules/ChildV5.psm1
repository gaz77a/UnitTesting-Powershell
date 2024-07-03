
function Get-ChildV5 {
    param (
        [string]$suffix
    )

    return "Some original child text: $suffix"
}

Export-ModuleMember -Function Get-ChildV5
