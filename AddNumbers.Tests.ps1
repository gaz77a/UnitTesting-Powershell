# Load the script to test
. "$PSScriptRoot\AddNumbers.ps1"

Describe "Add-Numbers" {
    It "should return the sum of two positive numbers" {
        Add-Numbers -a 2 -b 3 | Should Be 5
    }

    It "should return the sum of a positive and a negative number" {
        Add-Numbers -a 5 -b -3 | Should Be 2
    }

    It "should return the sum of two negative numbers" {
        Add-Numbers -a -2 -b -3 | Should Be -5
    }
}
