<#
.SYNOPSIS
    Configures "Deny access to this computer from the network" user right assignment
.DESCRIPTION
    Sets the deny network access policy for STIG compliance including:
    - Enterprise Admins group
    - Domain Admins group  
    - Local account
    - Guests group
#>

#Requires -RunAsAdministrator

function Set-DenyNetworkAccessPolicy {
    [CmdletBinding()]
    param()
    
    Write-Host "Configuring 'Deny access to this computer from the network' policy..." -ForegroundColor Cyan
    
    # Define the security groups to deny network access
    $groupsToDeny = @(
        "Enterprise Admins",
        "Domain Admins", 
        "Local account",
        "Guests"
    )
    
    try {
        # Import the SecEdit module
        Import-Module Microsoft.PowerShell.Security -ErrorAction Stop
        
        # Create a temporary security policy file
        $tempPath = [System.IO.Path]::GetTempPath()
        $infFile = Join-Path $tempPath "DenyNetworkAccess.inf"
        $databaseFile = Join-Path $tempPath "DenyNetworkAccess.sdb"
        
        # Build the INF content
        $infContent = @"
[Unicode]
Unicode=yes
[Version]
signature=`"`$CHICAGO`$`"
Revision=1
[Privilege Rights]
SeDenyNetworkLogonRight = $($groupsToDeny -join ",")
"@
        
        # Write the INF file
        Set-Content -Path $infFile -Value $infContent -Encoding Unicode
        
        Write-Host "Applying security policy..." -ForegroundColor Yellow
        
        # Apply the security policy using secedit
        $result = Start-Process -FilePath "secedit" -ArgumentList "/configure /db `"$databaseFile`" /cfg `"$infFile`" /areas USER_RIGHTS" -Wait -PassThru -NoNewWindow
        
        if ($result.ExitCode -eq 0) {
            Write-Host "✓ Successfully configured deny network access policy" -ForegroundColor Green
            Write-Host "Applied to groups:" -ForegroundColor White
            foreach ($group in $groupsToDeny) {
                Write-Host "  - $group" -ForegroundColor Yellow
            }
        } else {
            Write-Host "✗ Failed to apply security policy. Exit code: $($result.ExitCode)" -ForegroundColor Red
        }
        
        # Clean up temporary files
        Remove-Item -Path $infFile -ErrorAction SilentlyContinue
        Remove-Item -Path $databaseFile -ErrorAction SilentlyContinue
        
    }
    catch {
        Write-Host "✗ Error configuring policy: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Get-CurrentDenyNetworkAccess {
    <#
    .SYNOPSIS
        Displays current "Deny access to this computer from the network" settings
    #>
    
    Write-Host "`nCurrent 'Deny access to this computer from the network' settings:" -ForegroundColor Cyan
    
    try {
        # Export current security policy
        $tempPath = [System.IO.Path]::GetTempPath()
        $exportFile = Join-Path $tempPath "CurrentSecurityPolicy.inf"
        
        Start-Process -FilePath "secedit" -ArgumentList "/export /cfg `"$exportFile`" /areas USER_RIGHTS" -Wait -PassThru -NoNewWindow | Out-Null
        
        if (Test-Path $exportFile) {
            $content = Get-Content -Path $exportFile
            $denyLine = $content | Where-Object { $_ -like "*SeDenyNetworkLogonRight*" }
            
            if ($denyLine) {
                $groups = $denyLine.Split('=')[1].Trim()
                Write-Host "Currently denied groups: $groups" -ForegroundColor White
            } else {
                Write-Host "No groups currently denied network access" -ForegroundColor Yellow
            }
            
            # Clean up
            Remove-Item -Path $exportFile -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "Unable to retrieve current settings" -ForegroundColor Red
    }
}

# Main execution
Write-Host "STIG Configuration: Deny Network Access Policy" -ForegroundColor Magenta
Write-Host "==============================================" -ForegroundColor Magenta

# Show current settings
Get-CurrentDenyNetworkAccess

# Prompt user to apply changes
Write-Host "`nThis will configure the following groups to be denied network access:" -ForegroundColor Yellow
Write-Host "  - Enterprise Admins" -ForegroundColor White
Write-Host "  - Domain Admins" -ForegroundColor White
Write-Host "  - Local account" -ForegroundColor White
Write-Host "  - Guests" -ForegroundColor White

$confirmation = Read-Host "`nApply these settings? (Y/N)"

if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
    Set-DenyNetworkAccessPolicy
    
    # Show updated settings
    Write-Host "`nVerifying configuration..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    Get-CurrentDenyNetworkAccess
} else {
    Write-Host "Configuration cancelled by user." -ForegroundColor Gray
}

Write-Host "`nScript completed." -ForegroundColor Cyan
