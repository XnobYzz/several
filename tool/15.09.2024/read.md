This PowerShell script performs system maintenance tasks, including clearing temporary files, listing high CPU usage processes, and terminating processes.

#### Features:
1. **Run as Administrator:** 
   Ensures the script runs with elevated privileges.
   ```powershell
   if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
       Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
       exit
   }
   ```

2. **Clear Junk Files:**
   Deletes temporary files from system and local app data.
   ```powershell
   function Clear-JunkFiles {
       Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
       Remove-Item -Path "$env:LocalAppData\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
       Write-Host "Junk files cleared."
   }
   ```

3. **List High Resource Usage Apps:**
   Displays top 10 processes by CPU usage.
   ```powershell
   function List-HighUsageApps {
       Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Id, ProcessName, CPU, PM | Format-Table -AutoSize
   }
   ```

4. **Terminate Process by ID:**
   Stops a process based on the user input ID.
   ```powershell
   function Stop-App {
       param($procId)
       Stop-Process -Id $procId -Force
       Write-Host "Process with ID $procId terminated."
   }
   ```

#### Script Execution Flow:
1. **Clear Junk Files**: Automatically cleans temporary files.
2. **Display High Resource Usage Processes**: Lists top processes using CPU.
3. **Terminate Process**: Prompts the user to terminate a process by entering the ID, or skip by pressing Enter.

### Example Usage:
```powershell
powershell -ExecutionPolicy Bypass -File auto_clean.ps1
```
