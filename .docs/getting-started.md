## Getting Started

### Git Hooks

Git Hooks are setup using husky.net.

1. Run `dotnet tool restore` from the solution directory.
1. Confirm that husky is installed using `dotnet tool list`.
1. Initialise husky using `dotnet husky install`
1. Confirm the hooks are configured using `git config --get core.hooksPath`. This should return `.husky`

If for some reason this does not configure the hooks then update the git config manually.

1. git config --edit
1. add `hooksPath = .husky` to the `core` section

There are two Git Hooks configured:

1. pre-commit

#### pre-commit

`pre-commit` will automatically run unit tests when committing files. Since the `pre-commit` will run unit tests then it is advised to <b><u>commit via the terminal</u></b>. This gives you visibility of the actions being performed and any tests that might be failing.
