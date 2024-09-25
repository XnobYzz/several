function Set-DNS {
    param(
        [string]$adapter = "Wi-Fi",
        [string[]]$IPv4DNS = @("1.1.1.1", "1.0.0.1"),
        [string[]]$IPv6DNS = @("2606:4700:4700::1111", "2606:4700:4700::1001")
    )

    Write-Host "Setting IPv4 DNS..." -ForegroundColor Yellow
    Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses $IPv4DNS
    Write-Host "Setting IPv6 DNS..." -ForegroundColor Yellow
    Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses $IPv6DNS -AddressFamily IPv6
    Write-Host "DNS settings updated successfully!" -ForegroundColor Green
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script needs to be run as Administrator!" -ForegroundColor Red
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Set-DNS
