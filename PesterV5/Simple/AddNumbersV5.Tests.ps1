BeforeAll {
    # Load the functions from the script file
    . "$PSScriptRoot\AddNumbersV5.ps1"
}

Describe "Add-Numbers" {
    It "should return the sum of two positive numbers" {
        # Act & Assert
        Add-NumbersV5 -a 2 -b 3 | Should -Be 5
    }

    It "should return the sum of a positive and a negative number" {
        # Act & Assert
        Add-NumbersV5 -a 5 -b -3 | Should -Be 2
    }

    It "should return the sum of two negative numbers" {
        # Act & Assert
        Add-NumbersV5 -a -2 -b -3 | Should -Be -5
    }

    It "GIVEN_InputVariables_WHEN_Add-NumbersV5_THEN_ShouldAddTheNumbers" {
        # Arrange
        $a = 2
        $b = 3

        # Act & Assert
        $expected = 5
        Add-NumbersV5 -a $a -b $b | Should -Be $expected
    }
}

Describe "Add-WithRandomNumbers" {
    It "should return the sum of the inputs and the mocked random number" {
        # Arrange
        Mock Get-RandomNumberV5 { return 42 }

        # Act
        $result = Add-WithRandomNumbersV5 -a 5 -b 10

        #Assert
        $result | Should -Be 57 # 5 + 10 + 42
        Assert-MockCalled Get-RandomNumberV5 -Exactly 1
    }
}
