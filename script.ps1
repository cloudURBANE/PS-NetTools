# PS-NetTools: Comprehensive Windows Defender Configuration via PowerShell

<##
.SYNOPSIS
    A PowerShell script to remotely configure Windows Defender while maintaining security and transparency.
.DESCRIPTION
    PS-NetTools provides a secure method to remotely configure Windows Defender settings, including enabling real-time protection, setting exclusions, scheduling scans, and additional security features.
    This script is designed with user experience and security in mind, ensuring clear actions, transparency, and minimal risk of abuse or misuse.
.NOTES
    Version: 1.5
    Author: [Kyle A Dean]
    Date: [11/26/2024]
    License: MIT
#>

# Ensure the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Error "Administrator privileges are required to execute this script."
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
        Write-Warning "Unable to write to log file: $_"
    }
    Write-Output $message
}

# Create log directory if it doesn't exist
try {
    if (-not (Test-Path -Path "C:\PS-NetTools")) {
        New-Item -ItemType Directory -Path "C:\PS-NetTools" | Out-Null
        Log-Action "Log directory created at: C:\PS-NetTools"
    }
} catch {
    Write-Error "Failed to create log directory: $_"
    exit 1
}

# Enable PowerShell Remoting for remote management
try {
    Enable-PSRemoting -Force -ErrorAction Stop
    Log-Action "PowerShell Remoting enabled successfully."
} catch {
    Log-Action "PowerShell Remoting could not be enabled: $_"
    exit 1
}

# Verify Windows Defender Status
try {
    $defenderStatus = Get-MpComputerStatus -ErrorAction Stop
    if ($defenderStatus -eq $null) {
        throw "Windows Defender is not active on this system."
    }
    Log-Action "Retrieved Windows Defender Status:"
    Log-Action ($defenderStatus | Out-String)
} catch {
    Log-Action "Error while retrieving Windows Defender status: $_"
    exit 1
}

# Enable Real-Time Protection
try {
    Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop
    Log-Action "Real-Time Protection enabled successfully."
} catch {
    Log-Action "Failed to enable Real-Time Protection: $_"
    exit 1
}

# Set Exclusions for Windows Defender
$exclusionPath = "C:\Temp"
try {
    if (-not (Test-Path -Path $exclusionPath)) {
        New-Item -ItemType Directory -Path $exclusionPath | Out-Null
        Log-Action "Created exclusion directory: $exclusionPath"
    }
    Set-MpPreference -ExclusionPath $exclusionPath -ErrorAction Stop
    Log-Action "Exclusion path added: $exclusionPath"
} catch {
    Log-Action "Failed to add exclusion path: $_"
    exit 1
}

# Update Windows Defender Virus Definitions
try {
    Update-MpSignature -ErrorAction Stop
    Log-Action "Windows Defender virus definitions updated successfully."
} catch {
    Log-Action "Failed to update Windows Defender virus definitions: $_"
    exit 1
}

# Schedule a Daily Quick Scan
$taskName = "DailyQuickScan"
$taskTime = "09:00"
try {
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
        Log-Action "Removed existing scheduled task: $taskName"
    }
    $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command Start-MpScan -ScanType QuickScan"
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At $taskTime
    Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -User "System" -ErrorAction Stop
    Log-Action "Scheduled daily quick scan at $taskTime."
} catch {
    Log-Action "Failed to schedule daily quick scan: $_"
    exit 1
}

# Implement Firewall Rule for PowerShell Remoting Security
$firewallRuleName = "PS-NetTools-PowerShellRemoting"
try {
    if (Get-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction SilentlyContinue) {
        Remove-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction Stop
        Log-Action "Removed existing firewall rule: $firewallRuleName"
    }
    New-NetFirewallRule -DisplayName $firewallRuleName -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow -Profile Domain,Private -ErrorAction Stop
    Log-Action "Firewall rule created: $firewallRuleName to secure PowerShell Remoting."
} catch {
    Log-Action "Failed to create firewall rule: $_"
    exit 1
}

# Disable SMBv1 for Security
try {
    Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart -ErrorAction Stop
    Log-Action "SMBv1 protocol disabled successfully for enhanced security."
} catch {
    Log-Action "Failed to disable SMBv1 protocol: $_"
}

# Ensure Windows Firewall is Enabled
try {
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -ErrorAction Stop
    Log-Action "Windows Firewall enabled for all network profiles."
} catch {
    Log-Action "Failed to enable Windows Firewall: $_"
}

# Verify and Enable Remote Desktop if Necessary
try {
    $rdpStatus = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections").fDenyTSConnections
    if ($rdpStatus -eq 1) {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -ErrorAction Stop
        Log-Action "Remote Desktop enabled successfully."
    } else {
        Log-Action "Remote Desktop is already enabled."
    }
} catch {
    Log-Action "Error verifying or enabling Remote Desktop: $_"
}

# Configure Windows Defender Scan Preferences
try {
    Set-MpPreference -ScanAvgCPULoadFactor 30 -ErrorAction Stop
    Log-Action "Windows Defender CPU load factor set to 30% to optimize performance during scans."
} catch {
    Log-Action "Failed to configure Windows Defender scan preferences: $_"
}

# Set PowerShell Execution Policy to RemoteSigned
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force -ErrorAction Stop
    Log-Action "PowerShell execution policy set to RemoteSigned."
} catch {
    Log-Action "Failed to set PowerShell execution policy: $_"
}

# Disable PowerShell Remoting (Optional)
try {
    Disable-PSRemoting -Force -ErrorAction Stop
    Log-Action "PowerShell Remoting disabled for enhanced security."
} catch {
    Log-Action "Failed to disable PowerShell Remoting: $_"
}

# End of PS-NetTools script
Log-Action "PS-NetTools script completed successfully."
