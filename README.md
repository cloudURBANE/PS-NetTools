# Network Diagnostics Lab - Using PowerShell to Troubleshoot Connectivity Issues

**YouTube Demonstration**: [Click here to watch](https://youtu.be/Zkjf7vcRJMo)

## Description
This project guides users through a series of network diagnostics to identify and troubleshoot common connectivity issues. Using PowerShell commands, this utility helps you check IP configuration, verify DNS settings, ping external servers, and perform traceroutes to identify connectivity problems. The purpose is to quickly diagnose and resolve network issues with minimal effort.

## Languages and Utilities Used
- PowerShell

## Environments Used
- Windows 10 (21H2)

## Program Walk-Through

1. **Launch the Network Diagnostics Utility**:
    ```powershell
    PS C:\> .\NetworkDiagnostics.ps1
    ```
    ![Launch](https://i.imgur.com/1hM7zOz.png)

2. **Check IP Configuration**:
    ```powershell
    PS C:\> Get-NetIPConfiguration
    ```
    ![IP Configuration](https://i.imgur.com/N7eUmzX.png)

3. **Check DNS Settings**:
    ```powershell
    PS C:\> Get-DnsClientServerAddress
    ```
    ![DNS Settings](https://i.imgur.com/MbSzRp6.png)

4. **Ping a Common Website (e.g., Google.com)**:
    ```powershell
    PS C:\> Test-Connection -ComputerName google.com -Count 4
    ```
    ![Ping Google](https://i.imgur.com/x6XzPGv.png)

5. **Perform a Traceroute**:
    ```powershell
    PS C:\> tracert google.com
    ```
    ![Traceroute](https://i.imgur.com/v4BmVEG.png)

6. **Detect Packet Loss and Latency**:
    ```powershell
    PS C:\> Test-NetConnection -ComputerName google.com
    ```
    ![Packet Loss & Latency](https://i.imgur.com/QAfEdLW.png)

7. **Diagnostics Complete**:
    After completing the steps, review the output to identify any potential issues. Suggested actions will be provided.
    ![Diagnostics Complete](https://i.imgur.com/sV4aTRF.png)

8. **Observe Resolved Network State**:
    Once troubleshooting is complete, test again to confirm that the network issues are resolved.
    ![Resolved State](https://i.imgur.com/F7gXbVW.png)

## How to Use
1. Download the PowerShell script (`NetworkDiagnostics.ps1`) to your system.
2. Open PowerShell in Administrator mode.
3. Run the script using `.\NetworkDiagnostics.ps1`.
4. Follow the prompts for network testing.

**Note**: You may need administrator privileges for certain commands to execute properly.

---

If you need further assistance or want to contribute to this project, feel free to reach out!
