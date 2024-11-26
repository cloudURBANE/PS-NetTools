# PS-NetTools: Remote Configuration of Windows Defender Using PowerShell 🔒

A simple yet impactful PowerShell script project designed to demonstrate proficiency in configuring Windows Defender remotely, a crucial task for IT support, helpdesk, and system administrators. PS-NetTools provides hands-on experience with scripting automation, PowerShell, and Windows security configurations, making it an excellent showcase for hiring managers looking for expertise in these areas.

---

## **Project Overview**

PS-NetTools aims to remotely configure Windows Defender settings using PowerShell. It allows administrators to control key security features, such as enabling real-time protection, setting exclusions, and updating virus definitions, without direct access to the end user's device. By completing this project, you'll gain a solid understanding of how PowerShell can be utilized for practical IT security tasks, reinforcing your value as a capable and resourceful technician.

### **Benefits of This Project**
- 🛡️ **Security Expertise**: Learn the ins and outs of Windows Defender's security features.
- 🤓 **Scripting Proficiency**: Improve your PowerShell skills, a highly sought-after talent in IT support roles.
- 💡 **Automation Insight**: Understand how to automate administrative tasks to save time and reduce errors.

---

## **Setup & Walkthrough (7 Steps)**

### **Step 1: Prerequisites**
Ensure you have administrative privileges on both your machine and the remote machine. Enable PowerShell Remoting by running the following command in PowerShell as an Administrator:
```powershell
Enable-PSRemoting -Force
```
> Screenshot: Capture PowerShell running this command.

### **Step 2: Verify Defender Status**
Use PowerShell to verify if Windows Defender is running on the remote system. Run:
```powershell
Get-MpComputerStatus
```
> Screenshot: Capture the output showing the current status of Windows Defender.

### **Step 3: Configure Real-Time Protection**
Enable or disable real-time protection on the remote system using the following command:
```powershell
Set-MpPreference -DisableRealtimeMonitoring $false
```
> Screenshot: Capture the confirmation output after changing real-time protection settings.

### **Step 4: Set Exclusions**
Add specific folder or file exclusions to reduce unnecessary scans and improve system performance. For example:
```powershell
Set-MpPreference -ExclusionPath "C:\Temp"
```
> Screenshot: Capture the added exclusion path.

### **Step 5: Update Defender Virus Definitions**
Make sure Windows Defender is using the latest definitions:
```powershell
Update-MpSignature
```
> Screenshot: Capture the success message after updating virus definitions.

### **Step 6: Schedule Scans**
Schedule a daily quick scan using Task Scheduler via PowerShell. Use the command below to automate scans:
```powershell
schtasks /create /tn "DailyQuickScan" /tr "powershell.exe -command Start-MpScan -ScanType QuickScan" /sc daily /st 09:00
```
> Screenshot: Capture Task Scheduler confirming the newly created task.

### **Step 7: Disable PowerShell Remoting (Optional)**
For added security, disable PowerShell Remoting if it is no longer needed:
```powershell
Disable-PSRemoting -Force
```
> Screenshot: Capture the terminal showing that remoting has been disabled.

---

## **Usage Example**
PS-NetTools provides a PowerShell script that can be run to automatically apply all of the above configurations to any Windows machine accessible via the network, with minimal user intervention. This script makes managing Windows Defender both efficient and secure.

---

## **Key Learnings**
- **PowerShell Automation**: Learned how to automate essential security configurations.
- **Remote Management**: Enhanced ability to remotely manage Windows devices without GUI access.
- **Windows Security**: Gained a deeper understanding of how to configure and secure Windows Defender using scripting.

---

## **Future Enhancements**
- Add logging to keep records of all changes made during the script execution.
- Extend the script to allow configuration of other antivirus solutions through PowerShell.

---

## **Contact**
For questions or collaboration, feel free to reach out:
- **GitHub**: [Your Name](https://github.com/your-username)
- **LinkedIn**: [Your LinkedIn Profile](https://linkedin.com/in/your-linkedin)
