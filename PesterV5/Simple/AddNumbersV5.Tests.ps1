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
    Context "When mocking Get-RandomNumberV5 with hard coded values" {
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

    Context "When mocking Get-RandomNumberV5 with variable values" {
        It "GIVEN_MocksWithVariables_WHEN_Add-WithRandomNumbersV5_THEN_ShouldAddTheNumbers" {
            # Arrange
            $mockedResult = 43
            Mock Get-RandomNumberV5 { return $mockedResult }

            # Act
            $result = Add-WithRandomNumbersV5 -a 5 -b 10

            #Assert
            $result | Should -Be 58 # 5 + 10 + 43
            Assert-MockCalled Get-RandomNumberV5 -Exactly 1
        }
    }

    Context "When mocking Get-RandomNumberV5 with multiple variable values" {
        AfterEach {
            $script:mockedResult = $null
        }

        It "GIVEN_MocksWithVariableMultipleTimes_WHEN_Add-WithRandomNumbersV5_THEN_ShouldHaveDifferentResults" {
            # Arrange
            $script:mockedResult = 43

            # Define a script block to handle the mock logic and retain state
            $mockWithState = {
                # Increment the call count each time the mock is called
                $script:mockedResult++
                return $script:mockedResult
            }

            Mock Get-RandomNumberV5 -MockWith $mockWithState

            # Act
            $result = Add-WithRandomNumbersV5 -a 5 -b 10
            $result2 = Add-WithRandomNumbersV5 -a 5 -b 10


            #Assert
            $result | Should -Be 59 # 5 + 10 + 43 + 1
            $result2 | Should -Be 60 # 5 + 10 + 43 + 1 + 1
            Assert-MockCalled Get-RandomNumberV5 -Exactly 2
        }
    }

    Context "When mocking ensure previous mocks were reset" {
        It "GIVEN_PreviousScriptMockedVariable_THEN_PreviousMockShouldBeReset" {
            #Assert
            $script:mockedResult | Should -Be $null
        }
    }
}
