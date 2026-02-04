# Module.Tests.ps1

BeforeAll {
    Import-Module "$PSScriptRoot\ParentV6.psm1"
    Import-Module "$PSScriptRoot\ChildV6.psm1"
}

Describe "Get-ParentV6" {
    $globalMockedResult = "Some global mocked result"

    $globalMockedObject = {
        Result       = $globalMockedResult
        ResultPrefix = "Some global mocked prefix"
        SomeProperty = "Some global mocked value"
    }

    $globalMockedReturn = {
        return @{
            Result       = $globalMockedResult
            ResultPrefix = "Some global mocked prefix"
            SomeProperty = "Some global mocked value"
        }
    }

    Context "When mocking Get-ChildV6 function from ParentV6" {
        It "should mock calls to Get-ChildV6 from ParentV6" {
            # Arrange
            Mock -ModuleName ParentV6 ChildV6\Get-ChildV6 {
                param ($suffix)
                return "Mocked child text: $suffix"
            }

            # Act & Assert
            ChildV6\Get-ChildV6 -suffix "Some Suffix" `
            | Should -Be "Some original child text: Some Suffix"

            ParentV6\Get-ParentV6 -prefix "Some Prefix" -suffix "Some Suffix" `
            | Should -Be "Some Prefix : Mocked child text: Some Suffix"
        }
    }

    Context "When mocking Get-ChildV6 function directly" {
        It "should mock only direct calls to Get-ChildV6" {
            # Arrange
            Mock ChildV6\Get-ChildV6 {
                param ($suffix)
                return "Mocked direct call child text: $suffix"
            }

            # Act & Assert
            ChildV6\Get-ChildV6 -suffix "Some Suffix" `
            | Should -Be "Mocked direct call child text: Some Suffix"

            ParentV6\Get-ParentV6 -prefix "Some Prefix" -suffix "Some Suffix" `
            | Should -Be "Some Prefix : Some original child text: Some Suffix"
        }
    }

    Context "MocksWithVariables Now Better Supported" {
        It "GIVEN_MocksWithVariables_WHEN_Get-ParentV6_THEN_VariablesAvailable" {
            # Arrange
            $mockedResult = "Mocked child text: Some Suffix using a variable"
            $mockScript = {
                return "Mocked child text using variables in V6: - $mockedResult -"
            }

            Mock -ModuleName ParentV6 -CommandName ChildV6\Get-ChildV6 -MockWith $mockScript -Verifiable

            # Act & Assert
            ChildV6\Get-ChildV6 -suffix "Some Suffix" `
            | Should -Be "Some original child text: Some Suffix"

            ParentV6\Get-ParentV6 -prefix "Some Prefix" -suffix "Some Suffix" `
            | Should -Be "Some Prefix : Mocked child text using variables in V6: - Mocked child text: Some Suffix using a variable -"
        }
    }
}
