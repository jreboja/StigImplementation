# Quick STIG Fix - WN11-SO-000030
#Requires -RunAsAdministrator

Write-Host "Applying STIG Fix: WN11-SO-000030" -ForegroundColor Cyan

# Enable Success auditing for Process Creation
auditpol /set /subcategory:"Process Creation" /success:enable

if ($LASTEXITCODE -eq 0) {
    Write-Host "Success auditing enabled for Process Creation" -ForegroundColor Green
    
    # Verify
    $verify = auditpol /get /subcategory:"Process Creation" /r | ConvertFrom-Csv
    Write-Host "Verified setting: $($verify.'Inclusion Setting')" -ForegroundColor White
} else {
    Write-Host "Failed to configure audit policy" -ForegroundColor Red
}
