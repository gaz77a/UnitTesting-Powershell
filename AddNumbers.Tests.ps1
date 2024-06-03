# Load the script to test
. "$PSScriptRoot\AddNumbers.ps1"

Describe "Add-Numbers" {
    It "should return the sum of two positive numbers" {
        # Act & Assert
        Add-Numbers -a 2 -b 3 | Should Be 5
    }

    It "should return the sum of a positive and a negative number" {
        # Act & Assert
        Add-Numbers -a 5 -b -3 | Should Be 2
    }

    It "should return the sum of two negative numbers" {
        # Act & Assert
        Add-Numbers -a -2 -b -3 | Should Be -5
    }
}

Describe "Add-WithRandomNumbers" {
    It "should return the sum of the inputs and the mocked random number" {
        # Arrange
        Mock Get-RandomNumber { return 42 }

        # Act
        $result = Add-WithRandomNumbers -a 5 -b 10

        #Assert
        $result | Should Be 57 # 5 + 10 + 42
        Assert-MockCalled Get-RandomNumber -Exactly 1
    }
}
