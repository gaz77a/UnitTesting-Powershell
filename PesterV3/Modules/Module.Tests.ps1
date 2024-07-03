# Module.Tests.ps1

Import-Module "$PSScriptRoot\ParentV3.psm1"
Import-Module "$PSScriptRoot\ChildV3.psm1"

Describe "Get-Parent" {
    Context "When mocking Get-Child function from ParentV3" {
        It "should mock calls to Get-Child from ParentV3" {
            # Arrange
            Mock -ModuleName ParentV3 ChildV3\Get-Child {
                param ($suffix)
                return "Mocked child text: $suffix"
            }

            # Act & Assert
            ChildV3\Get-Child -suffix "Some Suffix" `
                | Should Be "Some original child text: Some Suffix"

            ParentV3\Get-Parent -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should Be "Some Prefix : Mocked child text: Some Suffix"
        }
    }

    Context "When mocking Get-Child function directly" {
        It "should mock only direct calls to Get-Child" {
            # Arrange
            Mock ChildV3\Get-Child {
                param ($suffix)
                return "Mocked direct call child text: $suffix"
            }

            # Act & Assert
            ChildV3\Get-Child -suffix "Some Suffix" `
                | Should Be "Mocked direct call child text: Some Suffix"

            ParentV3\Get-Parent -prefix "Some Prefix" -suffix "Some Suffix" `
                | Should Be "Some Prefix : Some original child text: Some Suffix"
        }
    }
}
