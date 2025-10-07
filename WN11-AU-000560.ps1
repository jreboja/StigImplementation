# Quick STIG Fix - Audit Other Logon/Logoff Events
#Requires -RunAsAdministrator

Write-Host "Applying STIG Fix: Audit Other Logon/Logoff Events" -ForegroundColor Cyan

# Enable Success auditing for Other Logon/Logoff Events
auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Success auditing enabled for Other Logon/Logoff Events" -ForegroundColor Green
    
    # Verify
    $verify = auditpol /get /subcategory:"Other Logon/Logoff Events" /r | ConvertFrom-Csv
    Write-Host "Verified setting: $($verify.'Inclusion Setting')" -ForegroundColor White
} else {
    Write-Host "ERROR: Failed to configure audit policy" -ForegroundColor Red
}
