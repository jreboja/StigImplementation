# Equivalent to: Windows Registry Editor Version 5.00
# [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer]
# "AlwaysInstallElevated"=dword:00000000

# Require administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires Administrator privileges. Please run PowerShell as Administrator."
    exit 1
}

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$valueName = "AlwaysInstallElevated"
$valueData = 0  # Equivalent to dword:00000000

Write-Host "Creating registry key equivalent to .reg file..." -ForegroundColor Cyan
Write-Host "Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer" -ForegroundColor Yellow
Write-Host "Value: AlwaysInstallElevated = dword:00000000" -ForegroundColor Yellow

try {
    # Create the registry path if it doesn't exist (equivalent to the [HKEY...] section)
    if (-not (Test-Path $registryPath)) {
        Write-Host "Creating registry path: $registryPath" -ForegroundColor Green
        New-Item -Path $registryPath -Force | Out-Null
    } else {
        Write-Host "Registry path already exists: $registryPath" -ForegroundColor Gray
    }

    # Create the DWORD value (equivalent to "AlwaysInstallElevated"=dword:00000000)
    Write-Host "Setting registry value: $valueName = dword:00000000" -ForegroundColor Green
    New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force | Out-Null

    # Verify the setting was applied correctly
    Write-Host "Verifying registry value..." -ForegroundColor Cyan
    $verify = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    
    if ($verify.$valueName -eq $valueData) {
        Write-Host "✓ SUCCESS: Registry key created successfully!" -ForegroundColor Green
        Write-Host "  Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer" -ForegroundColor White
        Write-Host "  Value: AlwaysInstallElevated = dword:00000000" -ForegroundColor White
    } else {
        Write-Warning "Value was set but verification shows unexpected value: $($verify.$valueName)"
    }
}
catch {
    Write-Error "Failed to create registry key: $($_.Exception.Message)"
    exit 1
}

Write-Host "`nScript completed. The registry is now configured as specified." -ForegroundColor Cyan
