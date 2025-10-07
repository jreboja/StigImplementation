# Quick Registry Write - STIG Setting
#Requires -RunAsAdministrator

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$valueName = "NoGPOListChanges"
$valueData = 0

# Create registry path if it doesn't exist
New-Item -Path $registryPath -Force | Out-Null

# Set the registry value
New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force

Write-Host "Registry value set successfully:" -ForegroundColor Green
Write-Host "Path: $registryPath" -ForegroundColor Yellow
Write-Host "Value: $valueName = $valueData" -ForegroundColor Yellow
