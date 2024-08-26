#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
$ErrorActionPreference = 'SilentlyContinue'
$wshell = New-Object -ComObject Wscript.Shell
$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Checks if Winget is installed
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe) {
    'Winget on juba paigaldatud...'
}  
else {
    # Installis Winget from the Microsoft Store 
    Write-HostAndTextBox "Ei leidnud Winget Package Manageri, alustan paigaldamist..."
    Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
    $nid = (Get-Process AppInstaller).Id
    Wait-Process -Id $nid
}

#Creating form for the script
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Point(1000, 660)
$Form.StartPosition = 'CenterScreen'
$Form.FormBorderStyle = 'Fixed3D'
$Form.MinimizeBox = $false
$Form.MaximizeBox = $false
$Form.ShowIcon = $false
$Form.text = "Inno Windowsi Tööriist"
$Form.TopMost = $false
$Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#E9E3E2")

$RestorePointPanel = New-Object system.Windows.Forms.Panel
$RestorePointPanel.height = 90
$RestorePointPanel.width = 1000
$RestorePointPanel.Anchor = 'top,right,left'
$RestorePointPanel.location = New-Object System.Drawing.Point(10, 10)

$RemovePanel = New-Object system.Windows.Forms.Panel
$RemovePanel.height = 80
$RemovePanel.width = 490
$RemovePanel.Anchor = 'top,right,left'
$RemovePanel.location = New-Object System.Drawing.Point(10, 90)

$RestorePanel = New-Object system.Windows.Forms.Panel
$RestorePanel.height = 80
$RestorePanel.width = 480
$RestorePanel.Anchor = 'top,right,left'
$RestorePanel.location = New-Object System.Drawing.Point(500, 90)

$HibernationPanel = New-Object system.Windows.Forms.Panel
$HibernationPanel.height = 120
$HibernationPanel.width = 250
$HibernationPanel.Anchor = 'top,right,left'
$HibernationPanel.location = New-Object System.Drawing.Point(10, 180)

$CortanaPanel = New-Object system.Windows.Forms.Panel
$CortanaPanel.height = 120
$CortanaPanel.width = 250
$CortanaPanel.Anchor = 'top,right,left'
$CortanaPanel.location = New-Object System.Drawing.Point(250, 180)

$ActionCenterPanel = New-Object system.Windows.Forms.Panel
$ActionCenterPanel.height = 120
$ActionCenterPanel.width = 250
$ActionCenterPanel.Anchor = 'top,right,left'
$ActionCenterPanel.location = New-Object System.Drawing.Point(500, 180)

$SystemTweaksPanel = New-Object system.Windows.Forms.Panel
$SystemTweaksPanel.height = 120
$SystemTweaksPanel.width = 240
$SstemTweaksPanel.Anchor = 'top,right,left'
$SystemTweaksPanel.location = New-Object System.Drawing.Point(740, 180)

$TelemetryPanel = New-Object system.Windows.Forms.Panel
$TelemetryPanel.height = 120
$TelemetryPanel.width = 250
$TelemetryPanel.Anchor = 'top,right,left'
$TelemetryPanel.location = New-Object System.Drawing.Point(10, 300)

$OnedrivePanel = New-Object system.Windows.Forms.Panel
$OnedrivePanel.height = 120
$OnedrivePanel.width = 250
$OnedrivePanel.Anchor = 'top,right,left'
$OnedrivePanel.location = New-Object System.Drawing.Point(250, 300)

$WindowsUpdatePanel = New-Object system.Windows.Forms.Panel
$WindowsUpdatePanel.height = 120
$WindowsUpdatePanel.width = 250
$WindowsUpdatePanel.Anchor = 'top,right,left'
$WindowsUpdatePanel.location = New-Object System.Drawing.Point(500, 300)

$UserAccountControlPanel = New-Object system.Windows.Forms.Panel
$UserAccountControlPanel.height = 120
$UserAccountControlPanel.width = 250
$UserAccountControlPanel.Anchor = 'top,right,left'
$UserAccountControlPanel.location = New-Object System.Drawing.Point(740, 300)

$OtherChangesPanel = New-Object system.Windows.Forms.Panel
$OtherChangesPanel.height = 150
$OtherChangesPanel.width = 1000
$OtherChangesPanel.Anchor = 'top,right,left'
$OtherChangesPanel.location = New-Object System.Drawing.Point(10, 400)

$ConsoleOutputTextBoxPanel = New-Object system.Windows.Forms.Panel
$ConsoleOutputTextBoxPanel.height = 100
$ConsoleOutputTextBoxPanel.width = 970
$ConsoleOutputTextBoxPanel.Anchor = 'top,right,left'
$ConsoleOutputTextBoxPanel.location = New-Object System.Drawing.Point(10, 560)

$RestorePoint = New-Object system.Windows.Forms.Button
$RestorePoint.FlatStyle = 'Flat'
$RestorePoint.text = "ENNE MUUDATUSTE TEGEMIST LOO ALATI UUS WINDOWSI TAASTEPUNKT VAJUTADES SIIA!"
$RestorePoint.width = 960
$RestorePoint.height = 60
$RestorePoint.Anchor = 'top,right,left'
$RestorePoint.location = New-Object System.Drawing.Point(10, 10)
$RestorePoint.Font = New-Object System.Drawing.Font('Georgia', 17, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RestorePoint.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$RemoveWindowsComponents = New-Object system.Windows.Forms.Label
$RemoveWindowsComponents.text = "EEMALDA WINDOWSI KOMPONENDID"
$RemoveWindowsComponents.AutoSize = $true
$RemoveWindowsComponents.width = 460
$RemoveWindowsComponents.height = 60
$RemoveWindowsComponents.Anchor = 'top,right,left'
$RemoveWindowsComponents.location = New-Object System.Drawing.Point(35, 10)
$RemoveWindowsComponents.Font = New-Object System.Drawing.Font('Georgia', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$RemoveApps = New-Object system.Windows.Forms.Button
$RemoveApps.FlatStyle = 'Flat'
$RemoveApps.text = "Eemalda kogu prügivara"
$RemoveApps.width = 480
$RemoveApps.height = 40
$RemoveApps.Anchor = 'top,right,left'
$RemoveApps.location = New-Object System.Drawing.Point(10, 40)
$RemoveApps.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RemoveApps.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$RestoreWindowsComponents = New-Object system.Windows.Forms.Label
$RestoreWindowsComponents.text = "TAASTA WINDOWSI KOMPONENDID"
$RestoreWindowsComponents.AutoSize = $true
$RestoreWindowsComponents.width = 460
$RestoreWindowsComponents.height = 40
$RestoreWindowsComponents.Anchor = 'top,right,left'
$RestoreWindowsComponents.location = New-Object System.Drawing.Point(40, 10)
$RestoreWindowsComponents.Font = New-Object System.Drawing.Font('Georgia', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$RestoreApps = New-Object system.Windows.Forms.Button
$RestoreApps.FlatStyle = 'Flat'
$RestoreApps.text = "Taasta eemaldatud prügivara"
$RestoreApps.width = 470
$RestoreApps.height = 40
$RestoreApps.Anchor = 'top,right,left'
$RestoreApps.location = New-Object System.Drawing.Point(10, 40)
$RestoreApps.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold) )
$RestoreApps.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$Hibernation = New-Object system.Windows.Forms.Label
$Hibernation.text = "HIBERNATSIOON"
$Hibernation.AutoSize = $true
$Hibernation.width = 300
$Hibernation.height = 142
$Hibernation.Anchor = 'top,right,left'
$Hibernation.location = New-Object System.Drawing.Point(43, 10)
$Hibernation.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$EnableHibernation = New-Object system.Windows.Forms.Button
$EnableHibernation.FlatStyle = 'Flat'
$EnableHibernation.text = "Aktiveeri"
$EnableHibernation.width = 230
$EnableHibernation.height = 30
$EnableHibernation.Anchor = 'top,right,left'
$EnableHibernation.location = New-Object System.Drawing.Point(10, 40)
$EnableHibernation.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$EnableHibernation.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$DisableHibernation = New-Object system.Windows.Forms.Button
$DisableHibernation.FlatStyle = 'Flat'
$DisableHibernation.text = "Deaktiveeri"
$DisableHibernation.width = 230
$DisableHibernation.height = 30
$DisableHibernation.Anchor = 'top,right,left'
$DisableHibernation.location = New-Object System.Drawing.Point(10, 80)
$DisableHibernation.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DisableHibernation.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$Cortana = New-Object system.Windows.Forms.Label
$Cortana.text = "CORTANA"
$Cortana.AutoSize = $true
$Cortana.width = 240
$Cortana.height = 142
$Cortana.Anchor = 'top,right,left'
$Cortana.location = New-Object System.Drawing.Point(80, 10)
$Cortana.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$EnableCortana = New-Object system.Windows.Forms.Button
$EnableCortana.FlatStyle = 'Flat'
$EnableCortana.text = "Paigalda"
$EnableCortana.width = 240
$EnableCortana.height = 30
$EnableCortana.Anchor = 'top,right,left'
$EnableCortana.location = New-Object System.Drawing.Point(10, 40)
$EnableCortana.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold) )
$EnableCortana.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$DisableCortana = New-Object system.Windows.Forms.Button
$DisableCortana.FlatStyle = 'Flat'
$DisableCortana.text = "Eemalda"
$DisableCortana.width = 240
$DisableCortana.height = 30
$DisableCortana.Anchor = 'top,right,left'
$DisableCortana.location = New-Object System.Drawing.Point(10, 80)
$DisableCortana.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DisableCortana.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$ActionCenter = New-Object system.Windows.Forms.Label
$ActionCenter.text = "TEAVITUSKESKUS"
$ActionCenter.AutoSize = $true
$ActionCenter.width = 300
$ActionCenter.height = 142
$ActionCenter.Anchor = 'top,right,left'
$ActionCenter.location = New-Object System.Drawing.Point(37, 10)
$ActionCenter.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$EnableActionCenter = New-Object system.Windows.Forms.Button
$EnableActionCenter.FlatStyle = 'Flat'
$EnableActionCenter.text = "Taasta"
$EnableActionCenter.width = 230
$EnableActionCenter.height = 30
$EnableActionCenter.Anchor = 'top,right,left'
$EnableActionCenter.location = New-Object System.Drawing.Point(10, 40)
$EnableActionCenter.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$EnableActionCenter.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$DisableActionCenter = New-Object system.Windows.Forms.Button
$DisableActionCenter.FlatStyle = 'Flat'
$DisableActionCenter.text = "Eemalda"
$DisableActionCenter.width = 230
$DisableActionCenter.height = 30
$DisableActionCenter.Anchor = 'top,right,left'
$DisableActionCenter.location = New-Object System.Drawing.Point(10, 80)
$DisableActionCenter.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DisableActionCenter.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$SystemTweaks = New-Object system.Windows.Forms.Label
$SystemTweaks.text = "SÜSTEEMIPARANDUSED"
$SystemTweaks.AutoSize = $true
$SystemTweaks.width = 230
$SystemTweaks.height = 142
$SystemTweaks.Anchor = 'top,right,left'
$SystemTweaks.location = New-Object System.Drawing.Point(6, 10)
$SystemTweaks.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$EnableSystemTweaks = New-Object system.Windows.Forms.Button
$EnableSystemTweaks.FlatStyle = 'Flat'
$EnableSystemTweaks.text = "Rakenda"
$EnableSystemTweaks.width = 230
$EnableSystemTweaks.height = 30
$EnableSystemTweaks.Anchor = 'top,right,left'
$EnableSystemTweaks.location = New-Object System.Drawing.Point(10, 40)
$EnableSystemTweaks.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$EnableSystemTweaks.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$DisableSystemTweaks = New-Object system.Windows.Forms.Button
$DisableSystemTweaks.FlatStyle = 'Flat'
$DisableSystemTweaks.text = "Eemalda"
$DisableSystemTweaks.width = 230
$DisableSystemTweaks.height = 30
$DisableSystemTweaks.Anchor = 'top,right,left'
$DisableSystemTweaks.location = New-Object System.Drawing.Point(10, 80)
$DisableSystemTweaks.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DisableSystemTweaks.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$Telemetry = New-Object system.Windows.Forms.Label
$Telemetry.text = "TELEMEETRIA"
$Telemetry.AutoSize = $true
$Telemetry.width = 300
$Telemetry.height = 142
$Telemetry.Anchor = 'top,right,left'
$Telemetry.location = New-Object System.Drawing.Point(55, 10)
$Telemetry.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$EnableTelemetry = New-Object system.Windows.Forms.Button
$EnableTelemetry.FlatStyle = 'Flat'
$EnableTelemetry.text = "Taasta"
$EnableTelemetry.width = 230
$EnableTelemetry.height = 30
$EnableTelemetry.Anchor = 'top,right,left'
$EnableTelemetry.location = New-Object System.Drawing.Point(10, 40)
$EnableTelemetry.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$EnableTelemetry.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$DisableTelemetry = New-Object system.Windows.Forms.Button
$DisableTelemetry.FlatStyle = 'Flat'
$DisableTelemetry.text = "Eemalda"
$DisableTelemetry.width = 230
$DisableTelemetry.height = 30
$DisableTelemetry.Anchor = 'top,right,left'
$DisableTelemetry.location = New-Object System.Drawing.Point(10, 80)
$DisableTelemetry.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DisableTelemetry.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$Onedrive = New-Object system.Windows.Forms.Label
$Onedrive.text = "ONEDRIVE"
$Onedrive.AutoSize = $true
$Onedrive.width = 300
$Onedrive.height = 142
$Onedrive.Anchor = 'top,right,left'
$Onedrive.location = New-Object System.Drawing.Point(75, 10)
$Onedrive.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Onedrive.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")

$InstallOnedrive = New-Object system.Windows.Forms.Button
$InstallOnedrive.FlatStyle = 'Flat'
$InstallOnedrive.text = "Paigalda"
$InstallOnedrive.width = 240
$InstallOnedrive.height = 30
$InstallOnedrive.Anchor = 'top,right,left'
$InstallOnedrive.location = New-Object System.Drawing.Point(10, 40)
$InstallOnedrive.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$InstallOnedrive.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$RemoveOnedrive = New-Object system.Windows.Forms.Button
$RemoveOnedrive.FlatStyle = 'Flat'
$RemoveOnedrive.text = "Eemalda"
$RemoveOnedrive.width = 240
$RemoveOnedrive.height = 30
$RemoveOnedrive.Anchor = 'top,right,left'
$RemoveOnedrive.location = New-Object System.Drawing.Point(10, 80)
$RemoveOnedrive.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RemoveOnedrive.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$WindowsUpdate = New-Object system.Windows.Forms.Label
$WindowsUpdate.text = "WINDOWSI UUENDUSED"
$WindowsUpdate.AutoSize = $true
$WindowsUpdate.width = 300
$WindowsUpdate.height = 142
$WindowsUpdate.Anchor = 'top,right,left'
$WindowsUpdate.location = New-Object System.Drawing.Point(5, 10)
$WindowsUpdate.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$DefaultUpdateSettings = New-Object system.Windows.Forms.Button
$DefaultUpdateSettings.FlatStyle = 'Flat'
$DefaultUpdateSettings.text = "Kõik uuendused"
$DefaultUpdateSettings.width = 230
$DefaultUpdateSettings.height = 30
$DefaultUpdateSettings.Anchor = 'top,right,left'
$DefaultUpdateSettings.location = New-Object System.Drawing.Point(10, 40)
$DefaultUpdateSettings.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DefaultUpdateSettings.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$SecurityUpdatesOnly = New-Object system.Windows.Forms.Button
$SecurityUpdatesOnly.FlatStyle = 'Flat'
$SecurityUpdatesOnly.text = "Ainult turvauuendused"
$SecurityUpdatesOnly.width = 230
$SecurityUpdatesOnly.height = 30
$SecurityUpdatesOnly.Anchor = 'top,right,left'
$SecurityUpdatesOnly.location = New-Object System.Drawing.Point(10, 80)
$SecurityUpdatesOnly.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$SecurityUpdatesOnly.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$UserAccountControlLevel = New-Object system.Windows.Forms.Label
$UserAccountControlLevel.text = "KONTROLL (UAC)"
$UserAccountControlLevel.AutoSize = $true
$UserAccountControlLevel.width = 300
$UserAccountControlLevel.height = 142
$UserAccountControlLevel.Anchor = 'top,right,left'
$UserAccountControlLevel.location = New-Object System.Drawing.Point(42, 10)
$UserAccountControlLevel.Font = New-Object System.Drawing.Font('Georgia', 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$UACNotifyWhenAppsMakeChanges = New-Object system.Windows.Forms.Button
$UACNotifyWhenAppsMakeChanges.FlatStyle = 'Flat'
$UACNotifyWhenAppsMakeChanges.text = "Teata äppide muudatustest"
$UACNotifyWhenAppsMakeChanges.width = 230
$UACNotifyWhenAppsMakeChanges.height = 30
$UACNotifyWhenAppsMakeChanges.Anchor = 'top,right,left'
$UACNotifyWhenAppsMakeChanges.location = New-Object System.Drawing.Point(10, 40)
$UACNotifyWhenAppsMakeChanges.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$UACNotifyWhenAppsMakeChanges.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$UACNeverNotify = New-Object system.Windows.Forms.Button
$UACNeverNotify.FlatStyle = 'Flat'
$UACNeverNotify.text = "Ära teata kunagi"
$UACNeverNotify.width = 230
$UACNeverNotify.height = 30
$UACNeverNotify.Anchor = 'top,right,left'
$UACNeverNotify.location = New-Object System.Drawing.Point(10, 80)
$UACNeverNotify.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$UACNeverNotify.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$OtherFixes = New-Object system.Windows.Forms.Label
$OtherFixes.text = "MUUD TÖÖRIISTAD"
$OtherFixes.AutoSize = $true
$OtherFixes.width = 457
$OtherFixes.height = 100
$OtherFixes.Anchor = 'top,right,left'
$OtherFixes.location = New-Object System.Drawing.Point(375, 30)
$OtherFixes.Font = New-Object System.Drawing.Font('Georgia', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$WindowsRestoration = New-Object system.Windows.Forms.Button
$WindowsRestoration.FlatStyle = 'Flat'
$WindowsRestoration.text = "Alusta süsteemi parandamisprotsessi taastepunktist"
$WindowsRestoration.width = 480
$WindowsRestoration.height = 40
$WindowsRestoration.Anchor = 'top,right,left'
$WindowsRestoration.location = New-Object System.Drawing.Point(10, 60)
$WindowsRestoration.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold) )
$WindowsRestoration.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$StartDiskCleanup = New-Object system.Windows.Forms.Button
$StartDiskCleanup.FlatStyle = 'Flat'
$StartDiskCleanup.text = "Ava Windowsi kettapuhastuse utiliit"
$StartDiskCleanup.width = 470
$StartDiskCleanup.height = 40
$StartDiskCleanup.Anchor = 'top,right,left'
$StartDiskCleanup.location = New-Object System.Drawing.Point(500, 60)
$StartDiskCleanup.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$StartDiskCleanup.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$FixHardDisk = New-Object system.Windows.Forms.Button
$FixHardDisk.FlatStyle = 'Flat'
$FixHardDisk.text = "Käivita kõvaketta failisüsteemi kontroll"
$FixHardDisk.width = 470
$FixHardDisk.height = 40
$FixHardDisk.Anchor = 'top,right,left'
$FixHardDisk.location = New-Object System.Drawing.Point(500, 110)
$FixHardDisk.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$FixHardDisk.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$FixSystemFiles = New-Object system.Windows.Forms.Button
$FixSystemFiles.FlatStyle = 'Flat'
$FixSystemFiles.text = "Paranda Windowsi süsteemifailid"
$FixSystemFiles.width = 480
$FixSystemFiles.height = 40
$FixSystemFiles.Anchor = 'top,right,left'
$FixSystemFiles.location = New-Object System.Drawing.Point(10, 110)
$FixSystemFiles.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$FixSystemFiles.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#CCCFD3")

$ConsoleOutputTextBox = New-Object System.Windows.Forms.TextBox
$ConsoleOutputTextBox.Multiline = $true
$ConsoleOutputTextBox.ScrollBars = 'Vertical'
$ConsoleOutputTextBox.Anchor = 'top,right,left,bottom'
$ConsoleOutputTextBox.Location = New-Object System.Drawing.Point(10, 10)
$ConsoleOutputTextBox.Width = 960
$ConsoleOutputTextBox.Height = 70
$ConsoleOutputTextBox.Font = New-Object System.Drawing.Font('Consolas', 12)

$Form.controls.AddRange(@($RestorePointPanel, $RemovePanel, $RestorePanel, $HibernationPanel , $CortanaPanel, $ActionCenterPanel, $SystemTweaksPanel, $TelemetryPanel, $OnedrivePanel, $WindowsUpdatePanel, $UserAccountControlPanel, $OtherChangesPanel, $ConsoleOutputTextBoxPanel))
$RestorePointPanel.controls.AddRange(@($RestorePoint))
$RemovePanel.controls.AddRange(@($RemoveWindowsComponents, $RemoveApps))
$RestorePanel.controls.AddRange(@($RestoreWindowsComponents, $RestoreApps))
$HibernationPanel.controls.AddRange(@($Hibernation, $EnableHibernation, $DisableHibernation))
$CortanaPanel.controls.AddRange(@($Cortana, $EnableCortana, $DisableCortana))
$ActionCenterPanel.controls.AddRange(@($ActionCenter, $EnableActionCenter, $DisableActionCenter))
$SystemTweaksPanel.controls.AddRange(@($SystemTweaks, $EnableSystemTweaks, $DisableSystemTweaks))
$TelemetryPanel.controls.AddRange(@($Telemetry, $DisableTelemetry, $EnableTelemetry))
$OnedrivePanel.controls.AddRange(@($Onedrive, $InstallOnedrive, $RemoveOnedrive))
$WindowsUpdatePanel.controls.AddRange(@($WindowsUpdate, $DefaultUpdateSettings, $SecurityUpdatesOnly))
$UserAccountControlPanel.controls.AddRange(@($UserAccountControlLevel, $UACNotifyWhenAppsMakeChanges, $UACNeverNotify))
$OtherChangesPanel.controls.AddRange(@($OtherFixes, $WindowsRestoration, $StartDiskCleanup, $FixHardDisk, $FixSystemFiles))
$ConsoleOutputTextBoxPanel.controls.AddRange(@($ConsoleOutputTextBox))

Get-AppxPackage Microsoft.DesktopAppInstaller | Foreach-Object { Add-AppxPackage -DisableDevelopmentMode -Register $_.InstallLocation\AppXManifest.xml }

# Redirects the console output to the TextBox
[console]::SetOut([System.IO.StreamWriter]::new($ConsoleOutputTextBox, $true))

function Write-HostAndTextBox {
    param(
        [string]$Message
    )

    # Displaya the message in the console
    Write-Host $Message

    # Appenda the message to the TextBox
    $ConsoleOutputTextBox.AppendText($Message + "`r`n")

    # Introducea a 1-second delay
    Start-Sleep -Seconds 1
}

$RestorePoint.Add_Click({
        # Creates Restore Point
        $serviceStatus = Get-Service -Name "srservice"
        if ($serviceStatus.Status -eq "Stopped") {
            Set-Service -Name "srservice" -Status "Running"
        }
        Write-HostAndTextBox "Loon süsteemi taastepunkti juhuks kui midagi peaks Windowsiga valesti minema..."
        Enable-ComputerRestore -Drive "C:\"
        Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"
        Write-HostAndTextBox "Süsteemi taastepunkt edukalt loodud!"
        [System.Windows.Forms.MessageBox]::Show("Uus Windowsi taastepunkt loodud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })
        
$RemoveApps.Add_Click({
        # List of all the bloatware apps that will be removed
        $appsToRemove = @(
            "Microsoft.People"
            "Microsoft.GetHelp"
            "Microsoft.Getstarted"
            "Microsoft.3DBuilder"
            "Microsoft.549981C3F5F10"                       # Cortana
            "Microsoft.Appconnector"
            "Microsoft.BingFinance"
            "Microsoft.BingFoodAndDrink"                    # Food And Drink
            "Microsoft.BingHealthAndFitness"                # Health And Fitness
            "Microsoft.BingNews"                            # News
            "Microsoft.BingSports"                          # Sports
            "Microsoft.BingTranslator"                      # Translator
            "Microsoft.BingTravel"                          # Travel
            "Microsoft.BingWeather"                         # Weather
            "Microsoft.CommsPhone"
            "Microsoft.ConnectivityStore"
            "Microsoft.Messaging"
            "Microsoft.Microsoft3DViewer"
            "Microsoft.MicrosoftOfficeHub"
            "Microsoft.MicrosoftPowerBIForWindows"
            "Microsoft.MicrosoftSolitaireCollection"        # MS Solitaire
            "Microsoft.MixedReality.Portal"
            "Microsoft.NetworkSpeedTest"
            "Microsoft.Office.OneNote"                      # MS Office OneNote
            "Microsoft.Office.Sway"
            "Microsoft.OneConnect"
            "Microsoft.People"                              # People
            "Microsoft.MSPaint"                             # Paint 3D
            "Microsoft.Print3D"                             # Print 3D
            #"Microsoft.SkypeApp"                           # Skype
            "Microsoft.Todos"                               # Microsoft To Do
            "Microsoft.Wallet"
            "Microsoft.Whiteboard"                          # Microsoft Whiteboard
            "Microsoft.WindowsAlarms"                       # Alarms
            "microsoft.windowscommunicationsapps"
            "Microsoft.WindowsFeedbackHub"                  # Feedback Hub
            "Microsoft.WindowsMaps"                         # Maps
            "Microsoft.WindowsPhone"
            "Microsoft.WindowsReadingList"
            "Microsoft.WindowsSoundRecorder"                # Windows Sound Recorder
            "Microsoft.XboxApp"                             # Xbox Console Companion (Replaced by new App)
            "Microsoft.YourPhone"                           # Your Phone
            "Microsoft.ZuneMusic"                           # Groove Music/Windows Media Player
            "Microsoft.ZuneVideo"                           # Movies & TV
            "EclipseManager"
            "ActiproSoftwareLLC"
            "AdobeSystemsIncorporated.AdobePhotoshopExpress"    
            "Duolingo-LearnLanguagesforFree"
            "PandoraMediaInc"
            "CandyCrush"
            "BubbleWitch3Saga"
            "Wunderlist"
            "Flipboard"
            "Twitter"
            "Facebook"
            "Spotify"
            "Minecraft"
            "Royal Revolt"
            "Sway"
            "Dolby"
            "Microsoft.XboxSpeechToTextOverlay"
            "Microsoft.XboxIdentityProvider"
            "Microsoft.XboxGamingOverlay"
            "Microsoft.XboxGameOverlay"
            "Microsoft.XboxApp"
            "Microsoft.Xbox.TCUI"
            "SpotifyAB.SpotifyMusic"
        )

        Write-HostAndTextBox "Eemaldan kõik prügivara äpid, palun oota..."

        foreach ($app in $appsToRemove | Select-Object -Unique) {
            
            $appInfo = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq $app }
            if ($appInfo -ne $null) {
                Write-HostAndTextBox "Eemaldan $app..."
                Start-Process -FilePath "powershell.exe" -ArgumentList "Get-AppxPackage -AllUsers | Where-Object { `$_.Name -eq '$app' } | ForEach-Object { Remove-AppxPackage -Package `$_.PackageFullName }" -NoNewWindow -Wait
            }
            else {
                Write-HostAndTextBox "$app ei leitud või see on juba eemaldatud..."
            }
        }
            
        # Removes all the tiles in the Windows Start Menu
        Write-HostAndTextBox "Eemaldan kõik Start Menüü paanid..."
        $START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

        $layoutFile = "C:\Windows\StartMenuLayout.xml"

        # Deletes layout file if it already exists
        If (Test-Path $layoutFile) {
            Remove-Item $layoutFile
        }

        # Creates the blank layout file
        $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

        $regAliases = @("HKLM", "HKCU")

        # Assigns the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
        foreach ($regAlias in $regAliases) {
            $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
            $keyPath = $basePath + "\Explorer" 
            IF (!(Test-Path -Path $keyPath)) { 
                New-Item -Path $basePath -Name "Explorer"
            }
            Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
            Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
        }

        # Restarts Explorer, opens the start menu (necessary to load the new layout), and gives it a few seconds to process
        Stop-Process -name explorer
        Start-Sleep -s 5
        $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
        Start-Sleep -s 5

        # Enables the ability to pin items again by disabling "LockedStartLayout"
        foreach ($regAlias in $regAliases) {
            $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
            $keyPath = $basePath + "\Explorer" 
            Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
        }

        # Restarts Explorer and deletes the layout file
        Stop-Process -name explorer
        Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
        Remove-Item $layoutFile
        
        # Loads the registry keys/values below into the NTUSER.DAT file which prevents apps from redownloading.
        reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
        Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
        Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
        Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
        reg unload HKU\Default_User

        # Prevents bloatware applications from returning               
        Write-HostAndTextBox "Lisan registrivõtmed, mis takistavad prügivara tagasi ilmumist..."
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $registryPath)) { 
            New-Item $registryPath
        }
        Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

        If (!(Test-Path $registryOEM)) {
            New-Item $registryOEM
        }
        Set-ItemProperty $registryOEM ContentDeliveryAllowed -Value 0 
        Set-ItemProperty $registryOEM OemPreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM PreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM PreInstalledAppsEverEnabled -Value 0 
        Set-ItemProperty $registryOEM SilentInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM SystemPaneSuggestionsEnabled -Value 0

                
        Write-HostAndTextBox "Kõik prügivara äpid eemaldatud!"
        [System.Windows.Forms.MessageBox]::Show("Kõik prügivara äpid eemaldatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$RestoreApps.Add_Click({
        # Reinstalls Windows default bloatware apps
        Write-HostAndTextBox "Paigaldan tagasi kõik prügivara rakendused, palun oota..."
        Get-AppxPackage -AllUsers | ForEach-Object {
            Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
        }

        Write-HostAndTextBox "Prügivara tagasi paigaldatud!"
        [System.Windows.Forms.MessageBox]::Show("Prügivara tagasi paigaldatud!", "Protsess edukas")
    })

$EnableHibernation.Add_Click({
        # Enables Hibernation
        Write-HostAndTextBox "Aktiveerin Hiberatsiooni..."
        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Type Dword -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type Dword -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_PowerButtonAction" -Type Dword -Value 1
        Write-HostAndTextBox "Hibernatsioon aktiveeritud!"
        [System.Windows.Forms.MessageBox]::Show("Hibernatsioon aktiveeritud, palun tee Windowsi restart!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$DisableHibernation.Add_Click({
        # Disables Hibernation
        Write-HostAndTextBox "Deaktiveerin Hibernatsiooni..."
        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0
        If ((get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
            $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
            Do {
                Start-Sleep -Milliseconds 100
                $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
            } Until ($preferences)
            Stop-Process $taskmgr
            $preferences.Preferences[28] = 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
        }
        Write-HostAndTextBox "Hibernatsioon deaktiveeritud!"
        [System.Windows.Forms.MessageBox]::Show("Hibernatsioon deaktiveeritud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })
    
$EnableActionCenter.Add_Click({
        # Enables Action Center
        Write-HostAndTextBox "Paigaldan Teavituskeskuse (Action Center)..."
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue
        Write-HostAndTextBox "Teavituskeskus paigaldatud, palun tee Windowsi restart!"
        [System.Windows.Forms.MessageBox]::Show("Teavituskeskus (Action Center) paigaldatud, palun tee Windowsi restart!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$DisableActionCenter.Add_Click({
        # Disables Action Center
        Write-HostAndTextBox "Eemaldan Teavituskeskuse (Action Center)..."
        If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
            New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
        Write-HostAndTextBox "Teavituskeskus (Action Center) eemaldatud, palun tee Windowsi restart!"
        [System.Windows.Forms.MessageBox]::Show("Teavituskeskus eemaldatud, palun tee Windowsi restart!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$EnableSystemTweaks.Add_Click({    
        Write-HostAndTextBox "Paigaldan süsteemiparandusi, palun oota..."

        # Runs O&O Shutup with Recommended Settings
        Write-HostAndTextBox "Seadistan O&O Shutup teenuse soovitavate seadetega..."
        Import-Module BitsTransfer
        Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
        Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
        ./OOSU10.exe ooshutup10.cfg /quiet

        # Disables Wi-fi Sense
        Write-HostAndTextBox "Eemaldan Wi-Fi Sense teenuse..."
        $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
        $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
        $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
        If (!(Test-Path $WifiSense1)) {
            New-Item $WifiSense1
        }
        Set-ItemProperty $WifiSense1  Value -Value 0 
        If (!(Test-Path $WifiSense2)) {
            New-Item $WifiSense2
        }
        Set-ItemProperty $WifiSense2  Value -Value 0 
        Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0
        
        # Prepares mixed Reality Portal for removal    
        Write-HostAndTextBox "Eemaldan Mixed Reality Portal rakenduse..."
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"    
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
        }

        # Disables scheduled tasks that are considered unnecessary 
        Write-HostAndTextBox "Eemaldan Scheduled Task ülesanded..."
        Get-ScheduledTask XblGameSaveTask | Disable-ScheduledTask
        Get-ScheduledTask Consolidator | Disable-ScheduledTask
        Get-ScheduledTask UsbCeip | Disable-ScheduledTask
        Get-ScheduledTask DmClient | Disable-ScheduledTask
        Get-ScheduledTask DmClientOnScenarioDownload | Disable-ScheduledTask

        # Stops Cortana from being used as part of your Windows Search Function
        Write-HostAndTextBox "Eemaldan Cortana Windowsi otsingufunktsioonist..."
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        If (Test-Path $Search) {
            Set-ItemProperty $Search AllowCortana -Value 0 
        }

        # Disables Web Search in Start Menu
        Write-HostAndTextBox "Eemaldan Bing Search'i Start Menüüst..."
        $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
        If (!(Test-Path $WebSearch)) {
            New-Item $WebSearch
        }
        Set-ItemProperty $WebSearch DisableWebSearch -Value 1 

        # Disables automatic Maps updates
        Write-HostAndTextBox "Keelan automaatse Maps teenuse uuendamise..."
        Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
        
        # Disables Error reporting
        Write-HostAndTextBox "Keelan Microsoftile automaatse tõrgetest teatamise teenuse..."
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
        Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null

        # Restricts Windows Update P2P only to local network
        Write-HostAndTextBox "Piiran Windows P2P ueendused ainult kohaliku võrguga..."
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1

        # Enables F8 boot menu options
        Write-HostAndTextBox "Luban klassikalise F8 alglaadimismenüü..."
        bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

        # Disables Remote Assistance
        Write-HostAndTextBox "Keelan Windowsi kaugabi teenuse..."
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0

        # Disables Storage Sense
        Write-HostAndTextBox "Keelan Storage Sense teenuse..."
        Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue

        # Stops and disables Superfetch service
        Write-HostAndTextBox "Keelan ja peatan Superfecth teenuse..."
        Stop-Service "SysMain" -WarningAction SilentlyContinue
        Set-Service "SysMain" -StartupType Disabled

        # Shows file operations details
        Write-HostAndTextBox "Kuvan kõiki failitoimingute üksikasju..."
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

        Write-HostAndTextBox "Peidan tegumivaate nupu..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

        Write-HostAndTextBox "Eemaldan People ikooni tegumiribalt..."
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

        # Hides Tray Icons
        Write-HostAndTextBox "Peidan tray ikoonid..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 1

        # Enables NumLock after startup
        Write-HostAndTextBox "Lülitan Windowsi käivitamisel sisse NumLock funktsiooni klaviatuuril..."
        If (!(Test-Path "HKU:")) {
            New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
        }
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
        Add-Type -AssemblyName System.Windows.Forms
        If (!([System.Windows.Forms.Control]::IsKeyLocked('NumLock'))) {
            $wsh = New-Object -ComObject WScript.Shell
            $wsh.SendKeys('{NUMLOCK}')
        }

        # Changes default Explorer view to This PC
        Write-HostAndTextBox "Parandan Windows Exploreri vaikevaadet..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

        # Hides 3D Objects icon from This PC
        Write-HostAndTextBox "Peidan 3D-ikoonid..."
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

        # Groups svchost.exe processes
        Write-HostAndTextBox "Grupeerin svchost.exe protsessid..."
        $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

        # Disables News and Interests and removes from taskbar
        Write-HostAndTextBox "Keelan News and Interests nupu ning eemaldans selle tegumiribalt..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
        Set-ItemProperty -Path  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

        # Removes Meet Now button from taskbar
        Write-HostAndTextBox "Eemaldan Meet Now nupu tegumiribalt..."
        If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1
        
        # Disables People icon on Taskbar
        Write-HostAndTextBox "Eemaldan People ikooni tegumiribalt..."
        $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        If (Test-Path $People) {
            Set-ItemProperty $People PeopleBand -Value 0
        }

        # Disables live tiles
        Write-HostAndTextBox "Eemaldan elavad Start Menüü paanid..."
        $Live = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'    
        If (!(Test-Path $Live)) {
            mkdir $Live  
            New-ItemProperty $Live NoTileApplicationNotification -Value 1
        }

        # Disables suggestions on start menu
        Write-HostAndTextBox "Keelan Microsofti soovituste kuvamise Start Menüüs..."
        $Suggestions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'    
        If (Test-Path $Suggestions) {
            Set-ItemProperty $Suggestions SystemPaneSuggestionsEnabled -Value 0
        }

        # Disables Bing Search
        Write-HostAndTextBox "Keelan Bing otsimootori kasutamise Start Menüüs..."
        $BingSearch = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
        If (Test-Path $BingSearch) {
            Set-ItemProperty $BingSearch DisableSearchBoxSuggestions -Value 1
        }

        # Shows known file extensions
        Write-HostAndTextBox "Kuvan kõiki faililaiendeid..."
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

        # Sets services to Manual (Does not disable)
        $services = @(
            "diagnosticshub.standardcollector.service"      # Microsoft Diagnostics Hub Standard Collector Service
            "DiagTrack"                                     # Diagnostics Tracking Service
            "DPS"                                           # Diagnostic Policy Service
            "dmwappushservice"                              # WAP Push Message Routing Service
            "lfsvc"                                         # Geolocation Service
            "MapsBroker"                                    # Downloaded Maps Manager
            "NetTcpPortSharing"                             # Net.Tcp Port Sharing Service
            "RemoteAccess"                                  # Routing and Remote Access
            "RemoteRegistry"                                # Remote Registry
            "SharedAccess"                                  # Internet Connection Sharing (ICS)
            "TrkWks"                                        # Distributed Link Tracking Client
            "WbioSrvc"                                      # Windows Biometric Service (required for Fingerprint reader / facial detection)
            #"WlanSvc"                                      # WLAN AutoConfig
            "WMPNetworkSvc"                                 # Windows Media Player Network Sharing Service
            #"wscsvc"                                       # Windows Security Center Service
            "WSearch"                                       # Windows Search
            "XblAuthManager"                                # Xbox Live Auth Manager
            "XblGameSave"                                   # Xbox Live Game Save Service
            "XboxNetApiSvc"                                 # Xbox Live Networking Service
            "XboxGipSvc"                                    # Xbox Accessory Management Service
            "ndu"                                           # Windows Network Data Usage Monitor
            "WerSvc"                                        # Windows Error Reporting Service
            #"Spooler"                                      # Printer Service
            "Fax"                                           # Fax
            "fhsvc"                                         # Fax histroy
            "gupdate"                                       # Google Update Service
            "gupdatem"                                      # Another Google Update Service
            "stisvc"                                        # Windows Image Acquisition (WIA)
            "AJRouter"                                      # DAllJoyn Router Service
            "MSDTC"                                         # Distributed Transaction Coordinator
            "WpcMonSvc"                                     # Parental Controls
            "PhoneSvc"                                      # Phone Service(Manages the telephony state on the device)
            "PrintNotify"                                   # Windows Printer Notifications and Extentions
            "PcaSvc"                                        # Program Compatibility Assistant Service
            "WPDBusEnum"                                    # Portable Device Enumerator Service
            #"LicenseManager"                               # LicenseManager (Windows store may not work properly)
            "seclogon"                                      # Secondary Logon (disables other credentials only password will work)
            "SysMain"                                       # Sysmain
            "lmhosts"                                       # TCP/IP NetBIOS Helper
            "wisvc"                                         # Windows Insider Program (Windows Insider will not work)
            "FontCache"                                     # Windows Font Cache
            "RetailDemo"                                    # RetailDemo Service
            "ALG"                                           # Application Layer Gateway Service (Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
            #"BFE"                                          # Base Filtering Engine (BFE) (service that manages firewall and Internet Protocol security)
            #"BrokerInfrastructure"                         # DWindows infrastructure service that controls which background tasks can run on the system
            "SCardSvr"                                      # Windows smart card
            "EntAppSvc"                                     # Enterprise Application Management Service
            "BthAvctpSvc"                                   # AVCTP Service (for Bluetooth Audio Device or Wireless Headphones)
            #"FrameServer"                                  # Windows Camera Frame Server ( allows multiple clients to access video frames from camera devices)
            "Browser"                                       # Computer browser Service
            "BthAvctpSvc"                                   # AVCTP Service (Audio Video Control Transport Protocol service)
            #"BDESVC"                                       # Bitlocker Service
            "iphlpsvc"                                      # IPv6 Helper Service     
            "edgeupdate"                                    # Microsoft Edge Update Service  
            "MicrosoftEdgeElevationService"                 # Microsoft Edge Elevation Service
            "edgeupdatem"                                   # Another Edge Update Service (disables edgeupdatem)                          
            "SEMgrSvc"                                      # Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
            #"PNRPsvc"                                      # Per Name Resolution Protocol (some peer-to-peer and collaborative applications, such as Remote Assistance, may not function)
            #"p2psvc"                                       # Peer Name Resolution Protocol (Enables multi-party communication using Peer-to-Peer Grouping. If disabled, some applications, such as HomeGroup, may not function)
            #"p2pimsvc"                                     # Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly)
            "PerfHost"                                      # Windows Performance Counter DLL Host Service
            "BcastDVRUserService_48486de"                   # GameDVR and Broadcast (for PC Game Recordings and Live Broadcasts)
            "CaptureService_48486de"                        # Optional screen capture functionality for applications that call the Windows.Graphics.Capture API
            "cbdhsvc_48486de"                               # cbdhsvc_48486de (Clipboard Service)
            #"BluetoothUserService_48486de"                 # Bluetooth User Service (Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session)
            "WpnService"                                    # Windows Push Notifications System Service (Push Notifications may not work)
            #"StorSvc"                                      # StorSvc (USB external hard drive will not be reconised by Windows)
            "RtkBtManServ"                                  # Realtek Bluetooth Device Manager Service
            "QWAVE"                                         # Quality Windows Audio Video Experience (audio and video might sound worse)
            "HvHost"                                        # HV Host Service (provides an interface for the Hyper-V hypervisor to provide per-partition performance counters to the host operating system)
            "vmickvpexchange"                               # Hyper-V Data Exchange Service (provides a mechanism to exchange data between the virtual machine and the operating system running on the physical computer)
            "vmicguestinterface"                            # Hyper-V Guest Service Interface (provides an interface for the Hyper-V host to interact with specific services running inside the virtual machine)
            "vmicshutdown"                                  # Hyper-V Guest Shutdown Service (provides a mechanism to shut down the operating system of this virtual machine from the management interfaces on the physical computer)
            "vmicheartbeat"                                 # Hyper-V Heartbeat Service (monitors the state of this virtual machine by reporting a heartbeat at regular intervals)
            "vmicvmsession"                                 # Hyper-V PowerShell Direct Service (provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network)
            "vmicrdv"                                       # Hyper-V Remote Desktop Virtualization Service (provides a platform for communication between the virtual machine and the operating system running on the physical computer)          
            "vmictimesync"                                  # Hyper-V Time Synchronization Service
        )

        foreach ($service in $services) {
            Write-HostAndTextBox "Seadistan $service teenuse starditüübi manuaalseks..."
            Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual
        }

        # Stops and disables Home Groups services
        Write-HostAndTextBox "Peatan ja keelan Home Groups teenuse..."
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Disabled
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Disabled

        Write-HostAndTextBox "Kõik süsteemiparandused paigaldatud, palun tee Windowsi restart!"
        [System.Windows.Forms.MessageBox]::Show("Kõik süsteemimuudatused paigaldatud, palun tee Windowsi restart!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$DisableSystemTweaks.Add_Click({
        # Enables Application suggestions   
        Write-HostAndTextBox "Luban Microsoftil pakkuda äppide soovitusi Start Menüüs..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
            Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Recurse -ErrorAction SilentlyContinue
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 0

        # Enables Wi-Fi Sense
        Write-HostAndTextBox "Luban Wi-Fi Sense teenuse..."
        $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
        $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
        $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"

        if (Test-Path $WifiSense1) {
            Set-ItemProperty $WifiSense1 Value -Value 1
        }  

        if (Test-Path $WifiSense2) {
            Set-ItemProperty $WifiSense2 Value -Value 1
        }

        if (Test-Path $WifiSense3) {
            Set-ItemProperty $WifiSense3 AutoConnectAllowedOEM -Value 1
        }

        # Reverts changes made to Mixed Reality Portal
        Write-HostAndTextBox "Muudan Mixed Reality Portal'i tagasi mitte-eemaldatavaks äpiks..."
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
        if (Test-Path $Holo) {
            Set-ItemProperty $Holo FirstRunSucceeded -Value 1
        }

        # Enables scheduled tasks that are considered unnecessary
        Write-HostAndTextBox "Taastan eemaldatud Scheduled Task ülesanded..."
        Enable-ScheduledTask -TaskName 'XblGameSaveTask'
        Enable-ScheduledTask -TaskName 'Consolidator'
        Enable-ScheduledTask -TaskName 'UsbCeip'
        Enable-ScheduledTask -TaskName 'DmClient'
        Enable-ScheduledTask -TaskName 'DmClientOnScenarioDownload'

        # Allows bloatware applications to return
        Write-HostAndTextBox "Teen registrimuudatused, mis lubavad prügivara tagasi ilmumise..."
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        if (Test-Path $registryPath) {
            Remove-ItemProperty $registryPath -Name DisableWindowsConsumerFeatures -ErrorAction SilentlyContinue
        }

        if (Test-Path $registryOEM) {
            Remove-ItemProperty $registryOEM -Name ContentDeliveryAllowed -ErrorAction SilentlyContinue
            Remove-ItemProperty $registryOEM -Name OemPreInstalledAppsEnabled -ErrorAction SilentlyContinue
            Remove-ItemProperty $registryOEM -Name PreInstalledAppsEnabled -ErrorAction SilentlyContinue
            Remove-ItemProperty $registryOEM -Name PreInstalledAppsEverEnabled -ErrorAction SilentlyContinue
            Remove-ItemProperty $registryOEM -Name SilentInstalledAppsEnabled -ErrorAction SilentlyContinue
            Remove-ItemProperty $registryOEM -Name SystemPaneSuggestionsEnabled -ErrorAction SilentlyContinue
        }

        # Allows Cortana to be used as part of your Windows Search Function
        Write-HostAndTextBox "Luban Cortana kasutamise Windwows Search funktsiooni osana..."
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (Test-Path $Search) {
            Set-ItemProperty $Search AllowCortana -Value 1
        }

        # Enables Web Search in Start Menu
        Write-HostAndTextBox "Luban veebiotsingu kasutamise Start Menüüs..."
        Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 1
        $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (!(Test-Path $WebSearch)) {
            New-Item $WebSearch
        }
        Set-ItemProperty $WebSearch DisableWebSearch -Value 0

        # Enables Activity History
        Write-HostAndTextBox "Luban tegevusajaloo andemete näitamise..."
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 1

        # Enables automatic Maps updates
        Write-HostAndTextBox "Luban automaatse Maps teenuse uuendamise..."
        Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 1
                    
        # Enables Error Reporting
        Write-HostAndTextBox "Keelan Microsoftile automaatse tõrgetest teatamise teenuse..."
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 0

        # Reverts Windows Update P2P restriction
        Write-HostAndTextBox "Luban Windows P2P ueendused ka väljastpoolt kohaliku võrku..."
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 3
    
        # Enables Home Groups services
        Write-HostAndTextBox "Taastan ja aktiveerin Home Groups teenuse..."
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Manual
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Manual

        # Enables Storage Sense
        Write-HostAndTextBox "Luban Storage Sense teenuse..."
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" | Out-Null
    
        # Enables Superfetch service
        Write-HostAndTextBox "Luban Superfetch teenuse..."
        Stop-Service "SysMain" -WarningAction SilentlyContinue
        Set-Service "SysMain" -StartupType Manual

        # Shows tray icons...
        Write-HostAndTextBox "Näitan tray ikoone..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
    
        # Hides file operations details
        Write-HostAndTextBox "Peidan failitoimingute üksikasjad..."
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
            Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Recurse -ErrorAction SilentlyContinue
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 0
    
        # Shows Task View button
        Write-HostAndTextBox "Kuvan Task View nupu töölaual..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 1

        # Changes default Explorer view to Quick Access
        Write-HostAndTextBox "Taastan Windows Exploreri vaikevaate..."
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

        # Enables live tiles
        Write-HostAndTextBox "Kuvan elavaid Start Menüü paane..."
        $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
        If (!(Test-Path $Live)) {
            New-Item $Live 
        }

        # Enables People Icon on Taskbar
        Write-HostAndTextBox "Kuvan People ikooni tegumiribal..."
        $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        If (Test-Path $People) {
            Set-ItemProperty $People -Name PeopleBand -Value 1
        }

        # Enables Bing Search when using Search via the Start Menu
        Write-HostAndTextBox "Luban Bing otsimootori kasutamise Start Menüüs..."
        $BingSearch = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
        If (Test-Path $BingSearch) {
            Set-ItemProperty $BingSearch DisableSearchBoxSuggestions -Value 0
        }

        # Enables suggestions on start menu
        Write-HostAndTextBox "Luban Microsofti soovituste kuvamise Start Menüüs..."
        $Suggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $Suggestions)) {
            New-Item $Suggestions
        }
        Set-ItemProperty $Suggestions  SystemPaneSuggestionsEnabled -Value 1

        # Hides known file extensions
        Write-HostAndTextBox "Peidan kõikide faililaiendite näitamise..."
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1

        Write-HostAndTextBox"Kõik süsteemimuudatused on tagasi pööratud, palun tee Windowsi restart!"
        [System.Windows.Forms.MessageBox]::Show("Kõik süsteemimuudatused on tagasi pööratud, palun tee Windowsi restart!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$EnableCortana.Add_Click( {
        # Enables Cortana
        $ErrorActionPreference = 'SilentlyContinue'
        Write-HostAndTextBox "Luban ja aktiveerin Cortana..."
        $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
        If (!(Test-Path $Cortana1)) {
            New-Item $Cortana1
        }
        Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 1 
        If (!(Test-Path $Cortana2)) {
            New-Item $Cortana2
        }
        Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 0 
        Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 0 
        If (!(Test-Path $Cortana3)) {
            New-Item $Cortana3
        }
        Set-ItemProperty $Cortana3 HarvestContacts -Value 1 
        Write-HostAndTextBox "Cortana paigaldatud!"
        [System.Windows.Forms.MessageBox]::Show("Cortana paigaldatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$DisableCortana.Add_Click({
        # Disables Cortana
        Write-HostAndTextBox "Eemaldan ja keelan Cortana..."
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
        Write-HostAndTextBox "Cortana eemaldatud!"
        [System.Windows.Forms.MessageBox]::Show("Cortana eemaldatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$DisableTelemetry.Add_Click({ 
        $ErrorActionPreference = 'SilentlyContinue'
        # Stops Windows Feedback
        Write-HostAndTextBox "Peatan Windowsi tagasiside teenuse..."
        $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 0
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        If (Test-Path $Advertising) {
            Set-ItemProperty $Advertising Enabled -Value 0 
        }

        # Turns off Data Collection via the AllowTelemetry key
        Write-HostAndTextBox "Lülitan välja Windowsi andmete kogumise teenuse..."
        $DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        $DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"    
        If (Test-Path $DataCollection1) {
            Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection2) {
            Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection3) {
            Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0 
        }
    
        # Disables Location Tracking
        Write-HostAndTextBox "Keelan asukohajälgimise teenuse..."
        $SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        $LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
        If (!(Test-Path $SensorState)) {
            New-Item $SensorState
        }
        Set-ItemProperty $SensorState SensorPermissionState -Value 0 
        If (!(Test-Path $LocationConfig)) {
            New-Item $LocationConfig
        }
        Set-ItemProperty $LocationConfig Status -Value 0 
        
        # Stops and disables WAP Push Service
        Write-HostAndTextBox "Peatan ja keelan WAP Push teenuse..."        
        Stop-Service "dmwappushservice"
        Set-Service "dmwappushservice" -StartupType Disabled

        # Disables the Diagnostics Tracking Service
        Write-HostAndTextBox "Peatan ja keelan diagnostika teenuse..."
        Stop-Service "DiagTrack"
        Set-Service "DiagTrack" -StartupType Disabled

        # Removes AutoLogger file and restricts directory
        Write-HostAndTextBox "Eemaldan AutoLogger faili ja keelan kausta kasutamise..."
        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
            Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
        }
        icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

        # Disables Tailored Experiences
        Write-HostAndTextBox "Keelan Tailored Experiences funktsioonide kohandamise..."
        If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
            New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

        # Disables Advertising ID
        Write-HostAndTextBox "Eemaldan reklaamisaatmise ID..."
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

        Write-HostAndTextBox "Windowsi telemeetria on eemaldatud!"
        [System.Windows.Forms.MessageBox]::Show("Windowsi telemeetria eemaldatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$EnableTelemetry.Add_Click({
        # Enables Feedback
        Write-HostAndTextBox "Käivitan Windowsi tagasiside teenuse..."
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
            Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Recurse -ErrorAction SilentlyContinue
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 0
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        if (Test-Path $Advertising) {
            Set-ItemProperty $Advertising Enabled -Value 1
        }

        # Turns on Data Collection via the AllowTelemetry key
        Write-HostAndTextBox "Lülitan andmete kogumise sisse..."
        $DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        $DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        if (Test-Path $DataCollection1) {
            Set-ItemProperty $DataCollection1 AllowTelemetry -Value 1
        }
        if (Test-Path $DataCollection2) {
            Set-ItemProperty $DataCollection2 AllowTelemetry -Value 1
        }
        if (Test-Path $DataCollection3) {
            Set-ItemProperty $DataCollection3 AllowTelemetry -Value 1
        }

        # Enables Location Tracking
        Write-HostAndTextBox "Luban asukohajälgimise teenuse..."
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Recurse -ErrorAction SilentlyContinue
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1

        # Enables WAP Push Service
        Write-HostAndTextBox "Luban WAP Push teenuse..."
        Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Manual

        # Enables the Diagnostics Tracking Service
        Write-HostAndTextBox "Luban diagnostika teenuse..."
        Set-Service "DiagTrack" -StartupType Automatic
        Start-Service "DiagTrack"

        # Unrestricts AutoLogger directory
        Write-HostAndTextBox"Eemaldan AutoLogger faili ja kausta kasutamise piiramise..."
        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null

        # Enables Tailored Experiences
        Write-HostAndTextBox "Keelan Tailored Experiences funktsioonide kohandamise..."
        If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
            Remove-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Recurse -ErrorAction SilentlyContinue
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 0

        # Enables Advertising ID
        Write-HostAndTextBox "Eemaldan reklaamisaatmise ID..."
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
            Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Recurse -ErrorAction SilentlyContinue
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 0

        Write-HostAndTextBox "Windowsi telemeetria on taastatud!"
        [System.Windows.Forms.MessageBox]::Show("Windowsi telemeetria taastatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$InstallOnedrive.Add_Click({
        # Installs OneDrive using Winget
        Write-HostAndTextBox "Paigaldan Windowsisse integreeritud OneDrive pilverakendust, palun oota..."
        Start-Process -FilePath winget -ArgumentList "install -e --accept-source-agreements --accept-package-agreements --silent Microsoft.OneDrive " -NoNewWindow -Wait
        $OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
        If (!(Test-Path $OneDriveKey)) {
            Mkdir $OneDriveKey | Out-Null
        }
        Set-ItemProperty $OneDriveKey -Name DisableFileSyncNGSC -Value 0
        
        Write-HostAndTextBox "OneDrive paigaldatud!"
        [System.Windows.Forms.MessageBox]::Show("OneDrive paigaldatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$RemoveOnedrive.Add_Click({
        Write-HostAndTextBox "Peatan OneDrive protsessid..."
        taskkill.exe /F /IM "OneDrive.exe"
        taskkill.exe /F /IM "explorer.exe"

        Write-HostAndTextBox "Kopeerin OneDrive kausta sisu kasutajakonto kausta..."
        $OneDrivePath = "$env:USERPROFILE\OneDrive"
        $BackupPath = "$env:USERPROFILE\OneDriveBackup"
        if (-not (Test-Path -Path $BackupPath -PathType Container)) {
            New-Item -ItemType Directory -Path $BackupPath | Out-Null
        }
        Copy-Item -Path "$OneDrivePath\*" -Destination $BackupPath -Recurse -Force

        Write-HostAndTextBox "Alustan OneDrive eemaldamaist..."
        Start-Process -FilePath winget -ArgumentList "uninstall -e --purge --force --silent Microsoft.OneDrive " -NoNewWindow -Wait

        Write-HostAndTextBox "Eemaldan OneDrive jäänukfailid..."
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"

        # Checks if directory is empty before removing
        If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
        }

        Write-HostAndTextBox "Eemaldan OneDrive rakenduse Windows Explorerist..."
        Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -ErrorAction SilentlyContinue
       
        $HivePath = "C:\Users\Default\NTUSER.DAT"
        reg load "HKLM\TempHive" $HivePath
        $KeyPath = "HKLM\TempHive\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" 
        $ValueName = "OneDriveSetup" 
        reg delete $KeyPath /v $ValueName /f
        reg unload "HKLM\TempHive"

        Write-HostAndTextBox "Eemaldan OneDrive Start Menüü kirje..."
        Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

        Write-HostAndTextBox "Eemaldan OneDrive Scheduled Task ülesande..."
        Get-ScheduledTask -TaskPath '\\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

        # Adds Shell folders restoring default locations
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"AppData\" -Value \"$env:userprofile\\AppData\\Roaming\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Cache\" -Value \"$env:userprofile\\AppData\\Local\\Microsoft\\Windows\\INetCache\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Cookies\" -Value \"$env:userprofile\\AppData\\Local\\Microsoft\\Windows\\INetCookies\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Favorites\" -Value \"$env:userprofile\\Favorites\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"History\" -Value \"$env:userprofile\\AppData\\Local\\Microsoft\\Windows\\History\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Local AppData\" -Value \"$env:userprofile\\AppData\\Local\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"My Music\" -Value \"$env:userprofile\\Music\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"My Video\" -Value \"$env:userprofile\\Videos\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"NetHood\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Network Shortcuts\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"PrintHood\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Printer Shortcuts\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Programs\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Recent\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Recent\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"SendTo\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\SendTo\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Start Menu\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Startup\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Templates\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Templates\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"{374DE290-123F-4565-9164-39C4925E467B}\" -Value \"$env:userprofile\\Downloads\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Desktop\" -Value \"$env:userprofile\\Desktop\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"My Pictures\" -Value \"$env:userprofile\\Pictures\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Personal\" -Value \"$env:userprofile\\Documents\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"{F42EE2D3-909F-4907-8871-4C22FC0BF756}\" -Value \"$env:userprofile\\Documents\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"{0DDD015D-B06C-45D5-8C4C-F59713854639}\" -Value \"$env:userprofile\\Pictures\" -Type ExpandString

        Write-HostAndTextBox "Taaskäivitan Windows Exploreri..."
        Start-Process "explorer.exe"

        Write-HostAndTextBox "Varundage OneDrive kausta sisu ja kustutage kaust!"
        Start-Sleep 5
        Write-HostAndTextBox "OneDrive eemaldatud!"
        [System.Windows.Forms.MessageBox]::Show("OneDrive eemaldatud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$DefaultUpdateSettings.Add_Click({
        Write-HostAndTextBox "Luban draiverite uuendused läbi Windows Update teenuse..."
        
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -ErrorAction SilentlyContinue
        
        Write-HostAndTextBox "Luban automaatse süsteemiuuendamise läbi Windows Update teenuse..."
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -ErrorAction SilentlyContinue
        
        Write-HostAndTextBox "Windows Update vaikeseaded aktiveeritud!"
        [System.Windows.Forms.MessageBox]::Show("Windows Update vaikeseaded aktiveeritud!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$SecurityUpdatesOnly.Add_Click({
        Write-HostAndTextBox "Eemaldan läbi Windowsi uuenduste teenuse draiverite uuenduste pakkumise..."
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value 1
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -Type DWord -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1
        
        Write-HostAndTextBox "Keelan Windowsi uuenduste automaatse taaskäivituse..."
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0
        
        Write-HostAndTextBox "Windows paigaldab edaspidi ainult süsteemi turvauuendusi!"
        [System.Windows.Forms.MessageBox]::Show("Windows paigaldab edaspidi ainult süsteemi turvauuendusi!", "Protsess edukas", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$UACNotifyWhenAppsMakeChanges.Add_Click({
        # Sets UAC level to 'Notify me when apps try to make changes
        Write-HostAndTextBox "Määran kasutajakonto kontrolli (UAC) taseme, kus teavitatakse kui äpid teevad süsteemis muudatusi..."
        start-process powershell -verb runas {
            Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5
        }
        Write-HostAndTextBox "Kasutajakonto kontrolli (UAC) tase on määratud teavitama kui äpid teevad süsteemis muudatusi!"
        [System.Windows.Forms.MessageBox]::Show("Teatab äppide tehtud muudatustest!", "Kasutajakonto kontroll", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$UACNeverNotify.Add_Click({
        # Sets UAC level to Never notify me when apps try to make changes
        Write-HostAndTextBox "Määran kasutajakonto kontrolli (UAC) taseme, et see ei teavita kui äpid teevad süsteemis muudatusi..."
        Start-Process powershell -Verb RunAs {
            Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
        }
        Write-HostAndTextBox "Kasutajakonto kontrolli (UAC) tase on määratud äppide tehtud muudatustest süsteemis mitte teavitama!"
        [System.Windows.Forms.MessageBox]::Show("Ei teata äppide tehtud muudatustest!", "Kasutajakonto kontroll", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

$FixHardDisk.Add_Click({
        # Starts Check Disk tool
        Write-HostAndTextBox "Käivitan kõvaketta failisüsteemi kontrolli utiliidi..."
        Write-HostAndTextBox "Protsessi alustamiseks järgige ekraanil olevaid juhiseid!"
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c chkdsk /f /r /x"
    })

$StartDiskCleanup.Add_Click({
        # Starts the Disk Cleanup utility
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "cleanmgr.exe"
        [System.Diagnostics.Process]::Start($startInfo)
    })

$WindowsRestoration.Add_Click({
        # Opens System Restore utility
        Start-Process -FilePath "C:\Windows\System32\rstrui.exe"
    })

$FixSystemFiles.Add_Click({
        function Run-CommandWithProgress {
            param (
                [string]$Command,
                [string]$Activity
            )
            
            $process = Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/C $Command" -Wait
            $exitCode = $process.ExitCode

            if ($exitCode -eq 0) {
                Write-Progress -Activity $Activity -Status "Completed" -PercentComplete 100
            }
            else {
                Write-Progress -Activity $Activity -Status "Failed" -PercentComplete 100
            }
        }
        
        Write-HostAndTextBox "Alustan Windowsi süsteemifailide parandamist, palun varu kannatust..."

        Write-HostAndTextBox "Windowsi kettapildifaili komponentide puhastamine..."
        Run-CommandWithProgress "Dism /Online /Cleanup-Image /StartComponentCleanup"
    
        Write-HostAndTextBox "Windowsi kettapildifaili komponentide taastamine..."
        Run-CommandWithProgress "Dism /Online /Cleanup-Image /RestoreHealth"
    
        Write-HostAndTextBox "Süsteemifailide terviklikkuse kontroll..."
        Run-CommandWithProgress "SFC /scannow" 
    
        Write-HostAndTextBox "Protsess lõpetatud!"
        [System.Windows.Forms.MessageBox]::Show("Protsess lõpetatud!", "Valmis", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })
    
[void]$Form.ShowDialog()
