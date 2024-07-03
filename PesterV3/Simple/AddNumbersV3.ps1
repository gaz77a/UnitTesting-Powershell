function Get-RandomNumberV3 {
    return Get-Random -Minimum 1 -Maximum 100
}

function Add-NumbersV3 {
    param (
        [int]$a,
        [int]$b
    )

    return $a + $b
}

function Add-WithRandomNumbersV3 {
    param (
        [int]$a,
        [int]$b
    )

    $randomNumber = Get-RandomNumberV3
    return $a + $b + $randomNumber
}
