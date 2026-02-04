# Module.Tests.ps1

Import-Module "$PSScriptRoot\ParentV3.psm1"
Import-Module "$PSScriptRoot\ChildV3.psm1"

Describe "Get-ParentV3" {
    Context "When mocking Get-ChildV3 function from ParentV3" {
        It "GIVEN_Get-ChildV3MockedFromParentV3_WHEN_Get-ParentV3_THEN_MockedCallReturned" {
            # Arrange
            Mock -ModuleName ParentV3 ChildV3\Get-ChildV3 {
                param ($suffix)
                return "Mocked child text: $suffix"
            }

            # Act & Assert
            ChildV3\Get-ChildV3 -suffix "Some Suffix" `
                | Should Be "Some original child text: Some Suffix"

            ParentV3\Get-ParentV3 -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should Be "Some Prefix : Mocked child text: Some Suffix"
        }
    }

    Context "When mocking Get-ChildV3 function directly" {
        It "GIVEN_Get-ChildV3MockedDirectly_WHEN_Get-ParentV3_THEN_OriginalLogicCalled" {
            # Arrange
            Mock ChildV3\Get-ChildV3 {
                param ($suffix)
                return "Mocked direct call child text: $suffix"
            }

            # Act & Assert
            ChildV3\Get-ChildV3 -suffix "Some Suffix" `
                | Should Be "Mocked direct call child text: Some Suffix"

            ParentV3\Get-ParentV3 -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should Be "Some Prefix : Some original child text: Some Suffix"
        }
    }

    Context "MocksWithVariables Is Not Supported" {
        It "GIVEN_MocksWithVariables_WHEN_Get-ParentV3_THEN_MockedVariableNotAvailable" {
            # Arrange
            $mockedResult = "Mocked child text: Some Suffix using a variable"
            $mockScript = {
                return "Mocked child text using variables is not possible in V3 due to scopping: - $mockedResult -"
            }

            Mock -ModuleName ParentV3 -CommandName ChildV3\Get-ChildV3 -MockWith $mockScript -Verifiable

            # Act & Assert
            ChildV3\Get-ChildV3 -suffix "Some Suffix" `
                | Should Be "Some original child text: Some Suffix"

            ParentV3\Get-ParentV3 -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should Be "Some Prefix : Mocked child text using variables is not possible in V3 due to scopping: -  -"
        }
    }
}
