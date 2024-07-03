
function Get-Child {
    param (
        [string]$suffix
    )

    return "Some original child text: $suffix"
}

Export-ModuleMember -Function Get-Child
