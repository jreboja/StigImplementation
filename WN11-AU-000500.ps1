# PowerShell Script to Set EventLog Application MaxSize
#Requires -RunAsAdministrator

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application\"
$valueName = "MaxSize"
$valueData = 32768  # 0x00008000 in decimal

Write-Host "Setting EventLog Application MaxSize..." -ForegroundColor Cyan
Write-Host "Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application\" -ForegroundColor Yellow
Write-Host "Value: MaxSize = 32768 (0x00008000)" -ForegroundColor Yellow

try {
    # Create registry path if it doesn't exist
    if (-not (Test-Path $registryPath)) {
        Write-Host "Creating registry path..." -ForegroundColor Gray
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "✓ Registry path created" -ForegroundColor Green
    } else {
        Write-Host "✓ Registry path already exists" -ForegroundColor Green
    }

    # Set the registry value
    Write-Host "Setting registry value..." -ForegroundColor Gray
    New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force | Out-Null
    Write-Host "✓ Registry value set: $valueName = $valueData (0x00008000)" -ForegroundColor Green

    # Verify the setting
    Write-Host "Verifying registry value..." -ForegroundColor Gray
    $verify = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    
    if ($verify.$valueName -eq $valueData) {
        Write-Host "✓ SUCCESS: Registry key created and verified" -ForegroundColor Green
        Write-Host "  Full Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application\" -ForegroundColor White
        Write-Host "  Value: MaxSize = $valueData (0x00008000)" -ForegroundColor White
        Write-Host "  Note: This sets Application event log maximum size to 32,768 KB (32 MB)" -ForegroundColor Gray
    } else {
        Write-Host "✗ WARNING: Registry value may not be set correctly" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "✗ ERROR: Failed to create registry key" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nScript completed." -ForegroundColor Cyan
