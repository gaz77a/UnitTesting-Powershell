function Get-RandomNumberV6 {
    return Get-Random -Minimum 1 -Maximum 100
}

function Add-NumbersV6 {
    param (
        [int]$a,
        [int]$b
    )

    return $a + $b
}

function Add-WithRandomNumbersV6 {
    param (
        [int]$a,
        [int]$b
    )

    $randomNumber = Get-RandomNumberV6
    return $a + $b + $randomNumber
}
