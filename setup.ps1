# 1. Ensure PowerShell Gallery is trusted and initialized
Write-Host "Initializing PowerShell Gallery..." -ForegroundColor Gray
$repo = Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue
if (-not $repo) {
    Register-PSRepository -Default -ErrorAction SilentlyContinue
}
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# Install Pester v5 for the current user (project-independent install)
# This installs Pester into the CurrentUser module scope so VS Code's PowerShell
# extension and integrated console can find it without relying on a repo-local .modules.

#2. Find the newest version that is < 6.0.0
$requiredVersion = Find-Module -Name Pester -MaximumVersion "5.999.999" | Select-Object -First 1 -ExpandProperty Version
    
Write-Host "Checking for Pester $requiredVersion..." -ForegroundColor Cyan
$found = Get-Module -ListAvailable -Name Pester | Sort-Object -Property Version -Descending | Select-Object -First 1

#3. Install or update Pester
if ($found -and ($found.Version -ge [version]$requiredVersion)) {
    Write-Host "Found Pester $($found.Version) at $($found.ModuleBase). Nothing to install." -ForegroundColor Gray
} elseif ($found -and ($found.Version -ge [version]"5.0.0")) {
    Write-Host "Updating Pester from $($found.Version) to $requiredVersion for CurrentUser..." -ForegroundColor Cyan
    Update-Module -Name Pester -RequiredVersion $requiredVersion -Scope CurrentUser -Force -ErrorAction Stop
} else {
    Write-Host "Installing Pester $requiredVersion for CurrentUser..." -ForegroundColor Cyan
    Install-Module -Name Pester -RequiredVersion $requiredVersion -Scope CurrentUser -Force -ErrorAction Stop
}

# 4. Restore .NET Tools (dotnet-tools.json)
Write-Host "`nRestoring .NET tools..." -ForegroundColor Cyan
dotnet tool restore

# 5. Verify .NET tools
dotnet tool list

# 6. Install Husky hooks
Write-Host "`nInstalling Husky hooks..." -ForegroundColor Cyan
dotnet husky install

Write-Host "`nSetup Complete!" -ForegroundColor Green
