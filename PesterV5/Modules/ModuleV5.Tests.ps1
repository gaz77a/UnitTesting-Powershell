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
}
