function Get-RandomNumberV5 {
    return Get-Random -Minimum 1 -Maximum 100
}

function Add-NumbersV5 {
    param (
        [int]$a,
        [int]$b
    )

    return $a + $b
}

function Add-WithRandomNumbersV5 {
    param (
        [int]$a,
        [int]$b
    )

    $randomNumber = Get-RandomNumberV5
    return $a + $b + $randomNumber
}
