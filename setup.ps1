# 1. Ensure PowerShell Gallery is trusted and initialized
Write-Host "Initializing PowerShell Gallery..." -ForegroundColor Gray
$repo = Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue
if (-not $repo) {
    Register-PSRepository -Default -ErrorAction SilentlyContinue
}
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# Install Pester for the current user (project-independent install)
# This installs Pester into the CurrentUser module scope so VS Code's PowerShell
# extension and integrated console can find it without relying on a repo-local .modules.
# 
# The script installs both Pester v5 (stable) and v6 (preview) side by side

Write-Host "`nInstalling Pester versions..." -ForegroundColor Cyan

# Define versions to install
$versionsToInstall = @(
    @{ Major = 5; MaxVersion = "5.999.999"; MinVersion = "5.0.0"; Label = "v5 (Stable)" }
    @{ Major = 6; MaxVersion = "6.999.999"; MinVersion = "6.0.0"; Label = "v6 (Preview)" }
)

foreach ($versionConfig in $versionsToInstall) {
    Write-Host "`n--- Installing Pester $($versionConfig.Label) ---" -ForegroundColor Cyan
    
    #2. Find the newest version for this major version
    if ($versionConfig.Major -eq 6) {
        # For v6 (preview), include pre-release versions
        $requiredVersion = Find-Module -Name Pester -MaximumVersion $versionConfig.MaxVersion -AllowPrerelease | Select-Object -First 1 -ExpandProperty Version
    } else {
        # For v5 (stable), only stable versions
        $requiredVersion = Find-Module -Name Pester -MaximumVersion $versionConfig.MaxVersion | Select-Object -First 1 -ExpandProperty Version
    }
    
    Write-Host "Checking for Pester $requiredVersion..." -ForegroundColor Gray
    $found = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge [version]$versionConfig.MinVersion -and $_.Version -lt [version]"$($versionConfig.Major + 1).0.0" } | Sort-Object -Property Version -Descending | Select-Object -First 1

    #3. Install or update Pester
    $installParams = @{
        Name = "Pester"
        RequiredVersion = $requiredVersion
        Scope = "CurrentUser"
        Force = $true
        AllowClobber = $true
        ErrorAction = "Stop"
    }
    
    # Add AllowPrerelease parameter if this is v6
    if ($versionConfig.Major -eq 6) {
        $installParams["AllowPrerelease"] = $true
    }
    
    if ($found -and ($found.Version -ge [version]$requiredVersion)) {
        Write-Host "Found Pester $($found.Version) at $($found.ModuleBase). Nothing to install." -ForegroundColor Gray
    } else {
        if ($found) {
            Write-Host "Updating Pester $($versionConfig.Label) from $($found.Version) to $requiredVersion for CurrentUser..." -ForegroundColor Cyan
        } else {
            Write-Host "Installing Pester $requiredVersion ($($versionConfig.Label)) for CurrentUser..." -ForegroundColor Cyan
        }
        Install-Module @installParams
    }
}

Write-Host "`nVerifying Pester installations..." -ForegroundColor Cyan
Get-Module -ListAvailable -Name Pester | Select-Object Name, Version, ModuleBase | Format-Table -AutoSize

# 4. Restore .NET Tools (dotnet-tools.json)
Write-Host "`nRestoring .NET tools..." -ForegroundColor Cyan
dotnet tool restore

# 5. Verify .NET tools
dotnet tool list

# 6. Install Husky hooks
Write-Host "`nInstalling Husky hooks..." -ForegroundColor Cyan
dotnet husky install

Write-Host "`nSetup Complete!" -ForegroundColor Green
