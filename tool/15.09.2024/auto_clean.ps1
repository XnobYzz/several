if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

function Clear-JunkFiles {
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LocalAppData\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Junk files cleared."
}

function List-HighUsageApps {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Id, ProcessName, CPU, PM | Format-Table -AutoSize
}

function Stop-App {
    param($procId)
    Stop-Process -Id $procId -Force
    Write-Host "Process with ID $procId terminated."
}

Clear-JunkFiles

Write-Host "High Resource Usage Applications:"
$apps = List-HighUsageApps

$choice = Read-Host "Enter the ID of the process to terminate, or press Enter to skip"
if ($choice) {
    Stop-App -procId $choice
}
