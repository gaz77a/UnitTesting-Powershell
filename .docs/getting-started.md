## Getting Started

### Initial Setup

Run the setup script from the project root to initialize all dependencies:

```powershell
.\setup.ps1
```

This script will:
1. Initialize the PowerShell Gallery
2. Install/update Pester v5 to the CurrentUser scope
3. Restore .NET tools (including dotnet-husky)
4. Install Git hooks
5. Verify all tools are installed

**After running the setup script, verify the output:**
- Confirm that Pester v5 was installed/updated successfully
- Ensure no errors were reported during the installation
- Verify that `.NET tools` list shows the expected tools
- Check that Husky hooks are properly installed

If you encounter any errors, see the [Troubleshooting](#troubleshooting) section below.

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
