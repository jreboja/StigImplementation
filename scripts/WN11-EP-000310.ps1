# Quick Registry Write - Kernel DMA Protection
#Requires -RunAsAdministrator

$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection"
$valueName = "DeviceEnumerationPolicy"
$valueData = 0

# Create registry path and set value
New-Item -Path $registryPath -Force | Out-Null
New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force

Write-Host "Registry value set:" -ForegroundColor Green
Write-Host "Path: $registryPath" -ForegroundColor Yellow
Write-Host "Value: $valueName = $valueData" -ForegroundColor Yellow
