# Quick Registry Write - Disable Windows Consumer Features
#Requires -RunAsAdministrator

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\"
$valueName = "DisableWindowsConsumerFeatures"
$valueData = 1

# Create registry path and set value
New-Item -Path $registryPath -Force | Out-Null
New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force

Write-Host "Registry value set:" -ForegroundColor Green
Write-Host "Path: $registryPath" -ForegroundColor Yellow
Write-Host "Value: $valueName = $valueData (0x00000001)" -ForegroundColor Yellow
