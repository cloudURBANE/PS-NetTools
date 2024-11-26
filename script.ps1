# PS-NetTools: Comprehensive Windows Defender Configuration via PowerShell

<##
.SYNOPSIS
    A PowerShell script to remotely configure Windows Defender while maintaining security and transparency.
.DESCRIPTION
    PS-NetTools provides a secure method to remotely configure Windows Defender settings, including enabling real-time protection, setting exclusions, and scheduling scans.
    This script is designed with user experience and security in mind, ensuring clear actions, transparency, and minimal risk of abuse or misuse.
.NOTES
    Version: 1.3
    Author: [Kyle A Dean]
    Date: [11/26/2024]
    License: MIT
#>

# Ensuring that script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Error "You need to run this script as an administrator."
    exit 1
}

# Function to log actions for transparency and audit purposes
function Log-Action {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    try {
        Add-Content -Path "C:\PS-NetTools\PS-NetTools.log" -Value $logMessage -ErrorAction Stop
    } catch {
        Write-Warning "Failed to write to log file: $_"
    }
    Write-Output $message
}

# Create log directory if it doesn't exist
try {
    if (-not (Test-Path -Path "C:\PS-NetTools")) {
        New-Item -ItemType Directory -Path "C:\PS-NetTools" | Out-Null
        Log-Action "Log directory created: C:\PS-NetTools"
    }
} catch {
    Write-Error "Failed to create log directory: $_"
    exit 1
}

# Step 1: Enable PowerShell Remoting to allow for remote management
try {
    Enable-PSRemoting -Force -ErrorAction Stop
    Log-Action "PowerShell Remoting enabled successfully."
} catch {
    Log-Action "Failed to enable PowerShell Remoting: $_"
    exit 1
}

# Step 2: Verify Windows Defender Status
try {
    $defenderStatus = Get-MpComputerStatus -ErrorAction Stop
    Log-Action "Windows Defender Status Retrieved:"
    Log-Action ($defenderStatus | Out-String)
} catch {
    Log-Action "Failed to retrieve Windows Defender status: $_"
    exit 1
}

# Step 3: Enable Real-Time Protection
try {
    Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop
    Log-Action "Real-Time Protection enabled successfully."
} catch {
    Log-Action "Failed to enable Real-Time Protection: $_"
    exit 1
}

# Step 4: Set Exclusions for Windows Defender
$exclusionPath = "C:\Temp"
try {
    if (-not (Test-Path -Path $exclusionPath)) {
        New-Item -ItemType Directory -Path $exclusionPath | Out-Null
        Log-Action "Created exclusion path directory: $exclusionPath"
    }
    Set-MpPreference -ExclusionPath $exclusionPath -ErrorAction Stop
    Log-Action "Added exclusion path: $exclusionPath"
} catch {
    Log-Action "Failed to add exclusion path: $_"
    exit 1
}

# Step 5: Update Windows Defender Virus Definitions
try {
    Update-MpSignature -ErrorAction Stop
    Log-Action "Windows Defender virus definitions updated successfully."
} catch {
    Log-Action "Failed to update Windows Defender virus definitions: $_"
    exit 1
}

# Step 6: Schedule a Daily Quick Scan using Task Scheduler
$taskName = "DailyQuickScan"
$taskTime = "09:00"
try {
    $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command Start-MpScan -ScanType QuickScan"
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At $taskTime
    Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -User "System" -ErrorAction Stop
    Log-Action "Scheduled daily quick scan at $taskTime."
} catch {
    Log-Action "Failed to schedule daily quick scan: $_"
    exit 1
}

# Step 7: Implement Firewall Rule for PowerShell Remoting Security
$firewallRuleName = "PS-NetTools-PowerShellRemoting"
try {
    New-NetFirewallRule -DisplayName $firewallRuleName -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow -Profile Domain,Private -ErrorAction Stop
    Log-Action "Firewall rule '$firewallRuleName' created to secure PowerShell Remoting."
} catch {
    Log-Action "Failed to create firewall rule: $_"
    exit 1
}

# Step 8: Disable PowerShell Remoting (Optional)
try {
    Disable-PSRemoting -Force -ErrorAction Stop
    Log-Action "PowerShell Remoting disabled for added security."
} catch {
    Log-Action "Failed to disable PowerShell Remoting: $_"
}

# End of PS-NetTools script
Log-Action "PS-NetTools script completed successfully."
