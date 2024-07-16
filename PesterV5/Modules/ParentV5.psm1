Import-Module "$PSScriptRoot\ChildV5.psm1"

function Get-ParentV5 {
    param (
        [string]$prefix,
        [string]$suffix
    )

    $childResult = Get-ChildV5 -suffix $suffix
    return "$prefix : $childResult"
}

function Get-ParentV5SecondFunction {
    param (
        [string]$prefix,
        [string]$suffix
    )
    $parentResult = Get-ParentV5 -prefix $prefix -suffix $suffix
    return "$parentResult"
}

function Get-ParentV5ReturnsObject {
    param (
        [string]$prefix,
        [string]$suffix
    )
    
    $parentResult = Get-ParentV5 -prefix $prefix -suffix $suffix
    return @{
        Result = $parentResult
        ResultPrefix = $prefix
        SomeProperty = "Some Value"
    }
}

function Get-ParentV5UsesObject {
    param (
        [string]$prefix,
        [string]$suffix
    )
    
    $parentResult = Get-ParentV5ReturnsObject -prefix $prefix -suffix $suffix
    Write-Host "Parent result: $parentResult"
    if ($null -eq $parentResult) {
        return "Mocking failed"
    }

    if ($parentResult.SomeProperty -eq "Some Value") {
        return "Called original function"
    }
    return "Called mocked function"
}

Export-ModuleMember -Function `
    Get-ParentV5, `
    Get-ParentV5SecondFunction, `
    Get-ParentV5ReturnsObject, `
    Get-ParentV5UsesObject
