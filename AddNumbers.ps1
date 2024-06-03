function Get-RandomNumber {
    return Get-Random -Minimum 1 -Maximum 100
}

function Add-Numbers {
    param (
        [int]$a,
        [int]$b
    )

    return $a + $b
}

function Add-WithRandomNumbers {
    param (
        [int]$a,
        [int]$b
    )

    $randomNumber = Get-RandomNumber
    return $a + $b + $randomNumber
}
