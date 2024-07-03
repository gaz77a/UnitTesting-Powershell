# Load the script to test
. "$PSScriptRoot\AddNumbersV3.ps1"

Describe "Add-Numbers" {
    It "should return the sum of two positive numbers" {
        # Act & Assert
        Add-NumbersV3 -a 2 -b 3 | Should Be 5
    }

    It "should return the sum of a positive and a negative number" {
        # Act & Assert
        Add-NumbersV3 -a 5 -b -3 | Should Be 2
    }

    It "should return the sum of two negative numbers" {
        # Act & Assert
        Add-NumbersV3 -a -2 -b -3 | Should Be -5
    }
}

Describe "Add-WithRandomNumbers" {
    It "should return the sum of the inputs and the mocked random number" {
        # Arrange
        Mock Get-RandomNumberV3 { return 42 }

        # Act
        $result = Add-WithRandomNumbersV3 -a 5 -b 10

        #Assert
        $result | Should Be 57 # 5 + 10 + 42
        Assert-MockCalled Get-RandomNumberV3 -Exactly 1
    }
}
