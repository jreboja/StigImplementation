function Set-WinRMBasicAuth {
    <#
    .SYNOPSIS
        Disables basic authentication for WinRM service
    #>
    #Requires -RunAsAdministrator
    
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\"
    $valueName = "AllowBasic"
    $valueData = 0

    try {
        New-Item -Path $registryPath -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force
        Write-Host "WinRM basic authentication disabled (AllowBasic = 0)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Failed to set WinRM registry value: $($_.Exception.Message)"
        return $false
    }
}

# Usage
Set-WinRMBasicAuth
