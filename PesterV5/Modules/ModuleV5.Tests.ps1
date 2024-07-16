# Module.Tests.ps1

Import-Module "$PSScriptRoot\ParentV5.psm1"
Import-Module "$PSScriptRoot\ChildV5.psm1"

Describe "Get-ParentV5" {
    Context "When mocking Get-ChildV5 function from ParentV5" {
        It "should mock calls to Get-ChildV5 from ParentV5" {
            # Arrange
            Mock -ModuleName ParentV5 ChildV5\Get-ChildV5 {
                param ($suffix)
                return "Mocked child text: $suffix"
            }

            # Act & Assert
            ChildV5\Get-ChildV5 -suffix "Some Suffix" `
                | Should -Be "Some original child text: Some Suffix"

            ParentV5\Get-ParentV5 -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should -Be "Some Prefix : Mocked child text: Some Suffix"
        }
    }

    Context "When mocking Get-ChildV5 function directly" {
        It "should mock only direct calls to Get-ChildV5" {
            # Arrange
            Mock ChildV5\Get-ChildV5 {
                param ($suffix)
                return "Mocked direct call child text: $suffix"
            }

            # Act & Assert
            ChildV5\Get-ChildV5 -suffix "Some Suffix" `
                | Should -Be "Mocked direct call child text: Some Suffix"

            ParentV5\Get-ParentV5 -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should -Be "Some Prefix : Some original child text: Some Suffix"
        }
    }

    Context "MocksWithVariables Not Supported" {
        It "GIVEN_MocksWithVariables_WHEN_Get-ParentV5_THEN_MockedVariableNotAvailable" {
            # Arrange
            $mockedResult = "Mocked child text: Some Suffix using a variable"
            $mockScript = {
                return "Mocked child text using variables is possible in V5: - $mockedResult -"
            }

            Mock -ModuleName ParentV5 -CommandName ChildV5\Get-ChildV5 -MockWith $mockScript -Verifiable

            # Act & Assert
            ChildV5\Get-ChildV5 -suffix "Some Suffix" `
                | Should -Be "Some original child text: Some Suffix"

            ParentV5\Get-ParentV5 -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should -Be "Some Prefix : Mocked child text using variables is possible in V5: - Mocked child text: Some Suffix using a variable -"
        }
    }

    Context "Mocks Get-ParentV5" {
        It "GIVEN_MocksGetParentV5_WHEN_Get-ParentV5SecondFunction_THEN_ReturnsMockedResult" {
            # Arrange
            $mockedResult = "Mocked child text: Some Suffix using a variable"
            $mockScript = {
                return "Mocked function in ParentV5 using variables is possible in V5: - $mockedResult -"
            }

            Mock -ModuleName ParentV5 -CommandName ParentV5\Get-ParentV5 -MockWith $mockScript -Verifiable

            # Act & Assert
            ParentV5\Get-ParentV5SecondFunction -prefix "Some Unused Prefix" -suffix "Some Unused Suffix" `
                | Should -Be "Mocked function in ParentV5 using variables is possible in V5: - Mocked child text: Some Suffix using a variable -"
        }
    }

    Context "Mocks Get-ParentV5" {
        It "GIVEN_MocksGetParentV5_WHEN_Get-ParentV5SecondFunction_THEN_ReturnsMockedResult" {
            # Arrange
            $mockedResult = "Some mocked result"
            $mockScript = {return @{
                    Result = $mockedResult
                    ResultPrefix = "Some mocked prefix"
                    SomeProperty = "Some mocked value"
                }          
            } 

            Mock -ModuleName ParentV5 -CommandName ParentV5\Get-ParentV5ReturnsObject -MockWith $mockScript -Verifiable

            # Act 
            $actualResult = ParentV5\Get-ParentV5UsesObject -prefix "Some Unused Prefix" -suffix "Some Unused Suffix"

            # Assert
            $actualResult | Should -Be "Called mocked function"
        }
    }
}
