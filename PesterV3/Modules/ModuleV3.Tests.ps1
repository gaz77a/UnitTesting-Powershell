# Module.Tests.ps1

Import-Module "$PSScriptRoot\ParentV3.psm1"
Import-Module "$PSScriptRoot\ChildV3.psm1"

Describe "Get-ParentV3" {
    Context "When mocking Get-ChildV3 function from ParentV3" {
        It "should mock calls to Get-ChildV3 from ParentV3" {
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
        It "should mock only direct calls to Get-ChildV3" {
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
}
