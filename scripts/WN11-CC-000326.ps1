# PowerShell Script to Enable PowerShell Script Block Logging
#Requires -RunAsAdministrator

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\"
$valueName = "EnableScriptBlockLogging"
$valueData = 1

Write-Host "Enabling PowerShell Script Block Logging..." -ForegroundColor Cyan
Write-Host "Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\" -ForegroundColor Yellow
Write-Host "Value: EnableScriptBlockLogging = 1 (REG_DWORD)" -ForegroundColor Yellow

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
    Write-Host "✓ Registry value set: $valueName = $valueData" -ForegroundColor Green

    # Verify the setting
    Write-Host "Verifying registry value..." -ForegroundColor Gray
    $verify = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    
    if ($verify.$valueName -eq $valueData) {
        Write-Host "✓ SUCCESS: PowerShell Script Block Logging enabled" -ForegroundColor Green
        Write-Host "  Full Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\" -ForegroundColor White
        Write-Host "  Value: EnableScriptBlockLogging = 1" -ForegroundColor White
        Write-Host "  Effect: All PowerShell script blocks will be logged to Event Viewer" -ForegroundColor Gray
    } else {
        Write-Host "✗ WARNING: Registry value may not be set correctly" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "✗ ERROR: Failed to create registry key" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nScript completed." -ForegroundColor Cyan
