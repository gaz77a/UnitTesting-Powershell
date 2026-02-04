## Getting Started

### Initial Setup

Run the setup script from the project root to initialize all dependencies:

```powershell
.\setup.ps1
```

This script will:
1. Initialize the PowerShell Gallery
2. Install/update Pester v5 (stable) to the CurrentUser scope
3. Install/update Pester v6 (preview) to the CurrentUser scope
4. Restore .NET tools (including dotnet-husky)
5. Install Git hooks
6. Verify all tools are installed

**After running the setup script, verify the output:**
- Confirm that both Pester v5 and v6 were installed/updated successfully
- Ensure no errors were reported during the installation
- Verify that `.NET tools` list shows the expected tools
- Check that Husky hooks are properly installed

If you encounter any errors, see the [Troubleshooting](#troubleshooting) section below.

### Testing Multiple Pester Versions

The project includes test suites for Pester v3 (legacy), v5 (stable), and v6 (preview):
- `PesterV3/` - Legacy examples (for reference)
- `PesterV5/` - Stable version tests
- `PesterV6/` - Preview version tests

**Important:** You cannot load both Pester v5 and v6 in the same PowerShell session. Both versions can be **installed** side by side, but only one can be **loaded** at a time.

**To test different versions:**
1. Run tests for v3 and v5
2. **Restart the PowerShell terminal** (close and reopen)
3. Run tests for v6

**In VS Code:**
- Close all `*.Tests.ps1` files before switching versions (prevents auto-loading)
- Restart the PowerShell terminal
- Open the desired test file

The git hooks run each test suite in a separate PowerShell process, so they don't conflict with each other.

### Git Hooks

Git Hooks are setup using husky.net. The setup script configures these automatically.

**Manual Setup (if needed):**

1. Run `dotnet tool restore` from the solution directory.
1. Confirm that husky is installed using `dotnet tool list`.
1. Initialise husky using `dotnet husky install`
1. Confirm the hooks are configured using `git config --get core.hooksPath`. This should return `.husky`

If for some reason this does not configure the hooks then update the git config manually.

1. git config --edit
1. add `hooksPath = .husky` to the `core` section

#### Available Git Hooks

Two Git Hooks are configured:

1. pre-commit

##### pre-commit

`pre-commit` will automatically run unit tests when committing files. Since the `pre-commit` will run unit tests then it is advised to <b><u>commit via the terminal</u></b>. This gives you visibility of the actions being performed and any tests that might be failing.

### Troubleshooting

#### Pester Installation Issues
If Pester fails to install, ensure:
- PowerShell Gallery repository is accessible
- You have internet connectivity
- Your PowerShell execution policy allows module installation (`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`)

#### .NET Tools Issues
If .NET tools fail to install:
- Ensure .NET 6.0 or later is installed (`dotnet --version`)
- Check that `.config/dotnet-tools.json` exists in the project root
- Try running `dotnet tool restore` manually

#### Git Hooks Not Running
If git hooks don't execute on commit:
- Verify hooks are installed: `git config --get core.hooksPath`
- Check hook file permissions: `ls -la .husky/`
- Ensure you're committing from the terminal, not from an IDE

#### Pester Version Conflicts in VS Code
If you see the error "An incompatible version of the Pester.dll assembly is already loaded":
- Close all `*.Tests.ps1` files in the editor
- Restart the PowerShell terminal in VS Code
- This clears the loaded Pester version and allows the new one to load

This happens because you cannot have v5 and v6 loaded in the same PowerShell session. Each version must be tested in its own session.
