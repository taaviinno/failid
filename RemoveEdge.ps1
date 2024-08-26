# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Edge uninstallation process

# Check if Microsoft Edge is installed
if (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application") {
    # Uninstall Microsoft Edge
    if (-not $silent_mode) { Write-Host "Removing Microsoft Edge" }
    Start-Process -FilePath $src -ArgumentList "--uninstall", "--system-level", "--force-uninstall" -PassThru -Wait
    Start-Sleep -Seconds 2
}

# Check if Microsoft Edge WebView is installed
if (-not $edge_only_mode -and (Test-Path "C:\Program Files (x86)\Microsoft\EdgeWebView\Application")) {
    # Uninstall Microsoft Edge WebView
    if (-not $silent_mode) { Write-Host "Removing WebView" }
    Start-Process -FilePath $src -ArgumentList "--uninstall", "--msedgewebview", "--system-level", "--force-uninstall" -Wait
    Start-Sleep -Seconds 2
}

# Remove Edge Appx Packages

# Obtain the current user's SID
$user_sid = (Get-LocalUser -Name $env:USERNAME).SID.Value
# Get Microsoft Edge Appx packages and uninstall them
$edge_apps = Get-AppxPackage -AllUsers | Where-Object { $_.PackageFullName -like "*microsoftedge*" } | Select-Object -ExpandProperty PackageFullName
foreach ($app in $edge_apps) {
    # Update registry settings and remove Appx packages
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\EndOfLife\$user_sid\$app" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\EndOfLife\S-1-5-18\$app" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\$app" -Force | Out-Null
    Remove-AppxPackage -Package $app -ErrorAction SilentlyContinue
    Remove-AppxPackage -Package $app -AllUsers -ErrorAction SilentlyContinue
}

# Cleanup remaining Edge components

# Remove EdgeUpdate leftovers
Remove-Item -Path "C:\ProgramData\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue

# Remove Desktop Icons related to Edge
$desktopPath = [Environment]::GetFolderPath("Desktop")
$desktopLinks = @("edge.lnk", "Microsoft Edge.lnk")
foreach ($link in $desktopLinks) {
    $linkPath = Join-Path -Path $desktopPath -ChildPath $link
    if (Test-Path $linkPath) {
        Remove-Item -Path $linkPath -Force
    }
}

# Remove Start Menu Icon related to Edge
$startMenuIcon = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
if (Test-Path $startMenuIcon) {
    Remove-Item -Path $startMenuIcon -Force
}

# Remove Edge-related scheduled tasks
$tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "*MicrosoftEdge*" }
foreach ($task in $tasks) {
    Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false -ErrorAction SilentlyContinue
}

# Remove Edge-related Task Scheduler files
Get-ChildItem -Path "C:\Windows\System32\Tasks" -Filter "MicrosoftEdge*" | Remove-Item -Force

# Stop and remove Edge Update Services
$serviceNames = "edgeupdate", "edgeupdatem"
foreach ($name in $serviceNames) {
    if (Get-Service -Name $name -ErrorAction SilentlyContinue) {
        Stop-Service -Name $name -Force -ErrorAction SilentlyContinue
        Remove-Service -Name $name -ErrorAction SilentlyContinue
    }
}

# Remove remaining Edge registry keys

if (-not (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\pwahelper.exe")) {
    Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Edge" -Force -ErrorAction SilentlyContinue
}

# Remove Edge-related folders in SystemApps directory
Get-ChildItem -Path "C:\Windows\SystemApps" -Directory | Where-Object { $_.Name -like "Microsoft.MicrosoftEdge*" } | ForEach-Object {
    $folderPath = $_.FullName
    Takeown /f $folderPath /r /d y
    icacls $folderPath /grant administrators:F /t
    Remove-Item -Path $folderPath -Recurse -Force
}

# Remove Edge-related files in System32 directory
$userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Get-ChildItem -Path "C:\Windows\System32" -File | Where-Object { $_.Name -like "MicrosoftEdge*.exe" } | ForEach-Object {
    $filePath = $_.FullName
    Takeown /f $filePath > $null
    icacls $filePath /inheritance:e /grant "{$userName}:(OI)(CI)F" /T /C > $null
    Remove-Item -Path $filePath -Force
}

# Remove remaining Edge-related file
$edgeDatPath = "C:\Program Files (x86)\Microsoft\Edge\Edge.dat"
if (Test-Path $edgeDatPath) {
    Remove-Item -Path $edgeDatPath -Force
}

# Remove leftover folders related to Edge
Remove-Item -Path "C:\Program Files (x86)\Microsoft\Temp" -Recurse -Force -ErrorAction SilentlyContinue
