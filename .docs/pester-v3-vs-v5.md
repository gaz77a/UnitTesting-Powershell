# Pester v3 vs v5 Differences

## Overview
This document outlines the key differences between Pester v3 and v5, and why v5 should be preferred for new projects.

## Key Differences

### 1. Assertion Syntax
Pester v5 uses dash-prefixed parameters for assertions, making them more consistent with PowerShell conventions.

**v3:**
```powershell
Should Be
Should Throw
Should Match
```

**v5:**
```powershell
Should -Be
Should -Throw
Should -Match
```

**Example:**
```powershell
# v3
Add-NumbersV3 -a 2 -b 3 | Should Be 5

# v5
Add-NumbersV5 -a 2 -b 3 | Should -Be 5
```

### 2. Setup/Teardown Scoping
Pester v5 introduces `BeforeAll` and `AfterAll` blocks for better control over test setup and teardown, replacing the v3 approach of dot-sourcing at the top level.

**v3:**
```powershell
. "$PSScriptRoot\AddNumbersV3.ps1"

Describe "Add-Numbers" {
    It "should add numbers" {
        Add-NumbersV3 -a 2 -b 3 | Should Be 5
    }
}
```

**v5:**
```powershell
BeforeAll {
    . "$PSScriptRoot\AddNumbersV5.ps1"
}

Describe "Add-Numbers" {
    It "should add numbers" {
        Add-NumbersV5 -a 2 -b 3 | Should -Be 5
    }
}
```

### 3. Variable Scoping in Mocks
One of the most significant improvements in Pester v5 is better variable scoping for mocks. In v3, mocks had difficulty accessing outer scope variables due to PowerShell's scoping rules. v5 resolves this issue.

**v3 Issue:**
```powershell
# Variables in mock scripts are not easily accessible from outer scope
Mock -ModuleName ParentV3 -CommandName ChildV3\Get-ChildV3 -MockWith {
    # Cannot easily access variables from the test
    return "This limitation is documented in V3"
}
```

**v5 Solution:**
```powershell
$mockedResult = "Mocked child text"
Mock -ModuleName ParentV5 ChildV5\Get-ChildV5 {
    param ($suffix)
    return "$mockedResult: $suffix"  # Can now access outer scope variables
}
```

### 4. Additional Improvements
- **Better error messages** - v5 provides more detailed failure messages and clearer assertion output
- **Performance** - v5 includes optimizations for test execution
- **CI/CD compatibility** - Better integration with modern CI/CD pipelines
- **Active maintenance** - v5 is the current supported version; v3 is deprecated

## Why Choose Pester v5?

1. **Modern Syntax** - More readable and consistent with PowerShell conventions
2. **Better Scoping** - `BeforeAll`/`AfterAll` blocks handle setup/teardown more reliably
3. **Variable Accessibility** - Mocks can access outer scope variables without workarounds
4. **Active Support** - Receives updates and bug fixes; v3 is no longer maintained
5. **Future-Proof** - Ensures compatibility with current and future PowerShell versions

## Migration Guide

When migrating from v3 to v5:
1. Update assertion syntax: Replace `Should Be` with `Should -Be`
2. Move dot-sourcing into `BeforeAll` blocks
3. Update function names and module references to match v5 naming conventions
4. Simplify mock variable handling by leveraging improved scoping

## Repository Structure

- `PesterV3/` - Legacy v3 test examples (for reference/learning)
- `PesterV5/` - Current v5 test examples (recommended for new development)

## References

- [Pester GitHub](https://github.com/pester/Pester)
- [Pester Documentation](https://pester.dev)
