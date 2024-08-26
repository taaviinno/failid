#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly
$ErrorActionPreference = 'SilentlyContinue'
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Runs OO Shutup
Write-Host "Running OO Shutup..."
Invoke-WebRequest -Uri "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -OutFile "$env:temp\OOSU10.exe"
Start-Process -FilePath "$env:temp\OOSU10.exe" -ArgumentList "/quiet /nosrp /ignorereadonlycfg"
Start-Sleep -Milliseconds 500

# Turns a bunch of system services to manual that don't need to be running all the time. This is pretty harmless as if the service is needed, it will simply start on demand
Write-Host "Setting services startup type to manual..."
$services = @{
    "AJRouter"                                 = @{ "StartupType" = "Disabled"; "OriginalType" = "Manual" }
    "ALG"                                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "AppIDSvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "AppMgmt"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "AppReadiness"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "AppVClient"                               = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "AppXSvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Appinfo"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "AssignedAccessManagerSvc"                 = @{ "StartupType" = "Disabled"; "OriginalType" = "Manual" }
    "AudioEndpointBuilder"                     = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "AudioSrv"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "AxInstSV"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "BDESVC"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "BFE"                                      = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "BITS"                                     = @{ "StartupType" = "AutomaticDelayedStart"; "OriginalType" = "Automatic" }
    "BTAGService"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "BcastDVRUserService_*"                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "BluetoothUserService_*"                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "BrokerInfrastructure"                     = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "Browser"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "BthAvctpSvc"                              = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "BthHFSrv"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "CDPSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "CDPUserSvc_*"                             = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "COMSysApp"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "CaptureService_*"                         = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "CertPropSvc"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "ClipSVC"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "ConsentUxUserSvc_*"                       = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "CoreMessagingRegistrar"                   = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "CredentialEnrollmentManagerUserSvc_*"     = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "CryptSvc"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "CscService"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DPS"                                      = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "DcomLaunch"                               = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "DcpSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DevQueryBroker"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DeviceAssociationBrokerSvc_*"             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DeviceAssociationService"                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DeviceInstall"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DevicePickerUserSvc_*"                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DevicesFlowUserSvc_*"                     = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Dhcp"                                     = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "DiagTrack"                                = @{ "StartupType" = "Disabled"; "OriginalType" = "Automatic" }
    "DialogBlockingService"                    = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "DispBrokerDesktopSvc"                     = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "DisplayEnhancementService"                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DmEnrollmentSvc"                          = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Dnscache"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "DoSvc"                                    = @{ "StartupType" = "AutomaticDelayedStart"; "OriginalType" = "Automatic" }
    "DsSvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DsmSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "DusmSvc"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "EFS"                                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "EapHost"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "EntAppSvc"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "EventLog"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "EventSystem"                              = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "FDResPub"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Fax"                                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "FontCache"                                = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "FrameServer"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "FrameServerMonitor"                       = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "GraphicsPerfSvc"                          = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "HomeGroupListener"                        = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "HomeGroupProvider"                        = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "HvHost"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "IEEtwCollectorService"                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "IKEEXT"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "InstallService"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "InventorySvc"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "IpxlatCfgSvc"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "KeyIso"                                   = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "KtmRm"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "LSM"                                      = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "LanmanServer"                             = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "LanmanWorkstation"                        = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "LicenseManager"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "LxpSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MSDTC"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MSiSCSI"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MapsBroker"                               = @{ "StartupType" = "AutomaticDelayedStart"; "OriginalType" = "Automatic" }
    "McpManagementService"                     = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MessagingService_*"                       = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MicrosoftEdgeElevationService"            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MixedRealityOpenXRSvc"                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "MpsSvc"                                   = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "MsKeyboardFilter"                         = @{ "StartupType" = "Manual"; "OriginalType" = "Disabled" }
    "NPSMSvc_*"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NaturalAuthentication"                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NcaSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NcbService"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NcdAutoSetup"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NetSetupSvc"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NetTcpPortSharing"                        = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "Netlogon"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "Netman"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NgcCtnrSvc"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NgcSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "NlaSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "OneSyncSvc_*"                             = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "P9RdrService_*"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PNRPAutoReg"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PNRPsvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PcaSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "PeerDistSvc"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PenService_*"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PerfHost"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PhoneSvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PimIndexMaintenanceSvc_*"                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PlugPlay"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PolicyAgent"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Power"                                    = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "PrintNotify"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "PrintWorkflowUserSvc_*"                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "ProfSvc"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "PushToInstall"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "QWAVE"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "RasAuto"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "RasMan"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "RemoteAccess"                             = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "RemoteRegistry"                           = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "RetailDemo"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "RmSvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "RpcEptMapper"                             = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "RpcLocator"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "RpcSs"                                    = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SCPolicySvc"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SCardSvr"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SDRSVC"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SEMgrSvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SENS"                                     = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SNMPTRAP"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SSDPSRV"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SamSs"                                    = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "ScDeviceEnum"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Schedule"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SecurityHealthService"                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Sense"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SensorDataService"                        = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SensorService"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SensrSvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SessionEnv"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SgrmBroker"                               = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SharedAccess"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "SharedRealitySvc"                         = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "ShellHWDetection"                         = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SmsRouter"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Spooler"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SstpSvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "StateRepository"                          = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "StiSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "StorSvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "SysMain"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "SystemEventsBroker"                       = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "TabletInputService"                       = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TapiSrv"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TermService"                              = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "TextInputManagementService"               = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "Themes"                                   = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "TieringEngineService"                     = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TimeBroker"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TimeBrokerSvc"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TokenBroker"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TrkWks"                                   = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "TroubleshootingSvc"                       = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "TrustedInstaller"                         = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "UI0Detect"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "UdkUserSvc_*"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "UevAgentService"                          = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "UmRdpService"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "UnistoreSvc_*"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "UserDataSvc_*"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "UserManager"                              = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "UsoSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "VGAuthService"                            = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "VMTools"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "VSS"                                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "VacSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "VaultSvc"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "W32Time"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WEPHOSTSVC"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WFDSConMgrSvc"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WMPNetworkSvc"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WManSvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WPDBusEnum"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WSService"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WSearch"                                  = @{ "StartupType" = "AutomaticDelayedStart"; "OriginalType" = "Automatic" }
    "WaaSMedicSvc"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WalletService"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WarpJITSvc"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WbioSrvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Wcmsvc"                                   = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "WcsPlugInService"                         = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WdNisSvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WdiServiceHost"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WdiSystemHost"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WebClient"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Wecsvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WerSvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WiaRpc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WinDefend"                                = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "WinHttpAutoProxySvc"                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WinRM"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "Winmgmt"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "WlanSvc"                                  = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "WpcMonSvc"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "WpnService"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "WpnUserService_*"                         = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "WwanSvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "XblAuthManager"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "XblGameSave"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "XboxGipSvc"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "XboxNetApiSvc"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "autotimesvc"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "bthserv"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "camsvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "cbdhsvc_*"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "cloudidsvc"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "dcsvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "defragsvc"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "diagnosticshub.standardcollector.service" = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "diagsvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "dmwappushservice"                         = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "dot3svc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "edgeupdate"                               = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "edgeupdatem"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "embeddedmode"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "fdPHost"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "fhsvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "gpsvc"                                    = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "hidserv"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "icssvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "iphlpsvc"                                 = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "lfsvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "lltdsvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "lmhosts"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "msiserver"                                = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "netprofm"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "nsi"                                      = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "p2pimsvc"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "p2psvc"                                   = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "perceptionsimulation"                     = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "pla"                                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "seclogon"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "shpamsvc"                                 = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "smphost"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "spectrum"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "sppsvc"                                   = @{ "StartupType" = "AutomaticDelayedStart"; "OriginalType" = "Automatic" }
    "ssh-agent"                                = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "svsvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "swprv"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "tiledatamodelsvc"                         = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "tzautoupdate"                             = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "uhssvc"                                   = @{ "StartupType" = "Disabled"; "OriginalType" = "Disabled" }
    "upnphost"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vds"                                      = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vm3dservice"                              = @{ "StartupType" = "Manual"; "OriginalType" = "Automatic" }
    "vmicguestinterface"                       = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmicheartbeat"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmickvpexchange"                          = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmicrdv"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmicshutdown"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmictimesync"                             = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmicvmsession"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmicvss"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "vmvss"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wbengine"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wcncsvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "webthreatdefsvc"                          = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "webthreatdefusersvc_*"                    = @{ "StartupType" = "Automatic"; "OriginalType" = "Automatic" }
    "wercplsupport"                            = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wisvc"                                    = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wlidsvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wlpasvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wmiApSrv"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "workfolderssvc"                           = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wscsvc"                                   = @{ "StartupType" = "AutomaticDelayedStart"; "OriginalType" = "Automatic" }
    "wuauserv"                                 = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
    "wudfsvc"                                  = @{ "StartupType" = "Manual"; "OriginalType" = "Manual" }
}
# Sets the startup types for each service
foreach ($service in $services.GetEnumerator()) {
    $serviceName = $service.Key
    $startupType = $service.Value.StartupType
    $originalType = $service.Value.OriginalType
    # Sets the startup type using PowerShell Set-Service cmdlet
    Set-Service -Name $serviceName -StartupType $startupType
}
Start-Sleep -Milliseconds 500

# Defines Registry Values
Write-Host "Applying some registry changes..."
$RegistryValues = @(
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        Type          = "DWord"
        Value         = "0"
        Name          = "AllowTelemetry"
        OriginalValue = "1"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        OriginalValue = "1"
        Name          = "AllowTelemetry"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "ContentDeliveryAllowed"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "OemPreInstalledAppsEnabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "PreInstalledAppsEnabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "PreInstalledAppsEverEnabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "SilentInstalledAppsEnabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "SubscribedContent-338387Enabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "SubscribedContent-338388Enabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "SubscribedContent-338389Enabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "SubscribedContent-353698Enabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        OriginalValue = "1"
        Name          = "SystemPaneSuggestionsEnabled"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        OriginalValue = "0"
        Name          = "DisableWindowsConsumerFeatures"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
        OriginalValue = "0"
        Name          = "NumberOfSIUFInPeriod"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        OriginalValue = "0"
        Name          = "DoNotShowFeedbackNotifications"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        OriginalValue = "0"
        Name          = "DisableTailoredExperiencesWithDiagnosticData"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
        OriginalValue = "0"
        Name          = "DisabledByGroupPolicy"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
        OriginalValue = "0"
        Name          = "Disabled"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
        OriginalValue = "1"
        Name          = "DODownloadMode"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance"
        OriginalValue = "1"
        Name          = "fAllowToGetHelp"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager"
        OriginalValue = "0"
        Name          = "EnthusiastMode"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        OriginalValue = "1"
        Name          = "ShowTaskViewButton"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
        OriginalValue = "1"
        Name          = "PeopleBand"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        OriginalValue = "1"
        Name          = "LaunchTo"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
        OriginalValue = "0"
        Name          = "LongPathsEnabled"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        _Comment      = "Driver searching is a function that should be left in"
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"
        OriginalValue = "1"
        Name          = "SearchOrderConfig"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        OriginalValue = "1"
        Name          = "SystemResponsiveness"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        OriginalValue = "1"
        Name          = "NetworkThrottlingIndex"
        Value         = "4294967295"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\Control Panel\Desktop"
        OriginalValue = "1"
        Name          = "MenuShowDelay"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\Control Panel\Desktop"
        OriginalValue = "1"
        Name          = "AutoEndTasks"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
        OriginalValue = "0"
        Name          = "ClearPageFileAtShutdown"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SYSTEM\ControlSet001\Services\Ndu"
        OriginalValue = "1"
        Name          = "Start"
        Value         = "2"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\Control Panel\Mouse"
        OriginalValue = "400"
        Name          = "MouseHoverTime"
        Value         = "400"
        Type          = "String"
    }
    @{
        Path          = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
        OriginalValue = "20"
        Name          = "IRPStackSize"
        Value         = "30"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
        OriginalValue = "1"
        Name          = "EnableFeeds"
        Value         = "0"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
        OriginalValue = "1"
        Name          = "ShellFeedsTaskbarViewMode"
        Value         = "2"
        Type          = "DWord"
    },
    @{
        Path          = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        OriginalValue = "1"
        Name          = "HideSCAMeetNow"
        Value         = "1"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
        OriginalValue = "1"
        Name          = "GPU Priority"
        Value         = "8"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
        OriginalValue = "1"
        Name          = "Priority"
        Value         = "6"
        Type          = "DWord"
    },
    @{
        Path          = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
        OriginalValue = "High"
        Name          = "Scheduling Category"
        Value         = "High"
        Type          = "String"
    }

    # Loops through each registry change and applies it
    foreach ($change in $registryChanges) {
        Set-ItemProperty -Path $change.Path -Name $change.Name -Value $change.Value -Type $change.Type
    }
)
# Sets bootmenu policy to Legacy using bcdedit
Write-Host "Setting bootmenu policy to Legacy using bcdedit..."
bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

# Checks Windows build version and performs actions if applicable
if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
    $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
  
    # Waits until Task Manager preferences are available
    do {
        Start-Sleep -Milliseconds 100
        $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
    } until ($preferences)
  
    Stop-Process $taskmgr
    $preferences.Preferences[28] = 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
}
  
# Removes specific registry item related to Explorer
Write-Host "Removing specific registry item related to Explorer..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
  
# Checks if Managed by your organization registry path exists in Edge and removes it if present
Write-Host "Checking if Managed by your organization registry path exists in Edge and removing it..."
if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge") {
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse -ErrorAction SilentlyContinue
}

# Groups svchost.exe processes based on RAM capacity
Write-Host "Grouping svchost.exe processes..."
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force
Start-Sleep -Milliseconds 500

# Removes AutoLogger-Diagtrack-Listener.etl file and denies SYSTEM full control to the directory
Write-Host "Removing AutoLogger file..."
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
icacls $autoLoggerDir /deny SYSTEM:(OI)(CI)F | Out-Null
Start-Sleep -Milliseconds 500

# Uninstalls Microsoft Teams
Write-Host "Uninstalling Microsoft Teams..."
$TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')
$TeamsUpdateExePath = [System.IO.Path]::Combine($TeamsPath, 'Update.exe')
Stop-Process -Name "*teams*" -Force -ErrorAction SilentlyContinue
if ([System.IO.File]::Exists($TeamsUpdateExePath)) {
    # Uninstall app
    $proc = Start-Process $TeamsUpdateExePath "-uninstall -s" -PassThru
    $proc.WaitForExit()
}
Get-AppxPackage "*Teams*" | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-AppxPackage "*Teams*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
if ([System.IO.Directory]::Exists($TeamsPath)) {
    Remove-Item $TeamsPath -Force -Recurse -ErrorAction SilentlyContinue
}
# Uninstalls registry key UninstallString
$us = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like '*Teams*' }).UninstallString
if ($us.Length -gt 0) {
    $us = ($us.Replace('/I', '/uninstall ') + ' /quiet').Replace('  ', ' ')
    $FilePath = ($us.Substring(0, $us.IndexOf('.exe') + 4).Trim())
    $ProcessArgs = ($us.Substring($us.IndexOf('.exe') + 5).Trim().replace('  ', ' '))
    $proc = Start-Process -FilePath $FilePath -Args $ProcessArgs -PassThru
    $proc.WaitForExit()
}
Start-Sleep -Milliseconds 500

# Sets Classic Right-Click Menu 
Write-Host "Setting Classic Right-Click Menu..."
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -Force -Value "" | Out-Null
Start-Sleep --Milliseconds 500

# Disables UAC
Write-Host "Disabling User Account Control (UAC)..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
Start-Sleep -Milliseconds 500

# Disables GameDVR
Write-Host "Disabling GameDVR..."
$DVRRegistry = @{
    "HKCU:\System\GameConfigStore\GameDVR_FSEBehavior"                   = "2"
    "HKCU:\System\GameConfigStore\GameDVR_Enabled"                       = "0"
    "HKCU:\System\GameConfigStore\GameDVR_DXGIHonorFSEWindowsCompatible" = "1"
    "HKCU:\System\GameConfigStore\GameDVR_HonorUserFSEBehaviorMode"      = "1"
    "HKCU:\System\GameConfigStore\GameDVR_EFSEFeatureFlags"              = "0"
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR\AllowGameDVR"     = "0"
}
$DVRRegistry.GetEnumerator() | ForEach-Object {
    Set-ItemProperty -Path $_.Key -Name $_.Name -Value $_.Value -Type DWord
}
Start-Sleep -Milliseconds 500

# Disables Teredo
Write-Host "Disabling Teredo..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value "1" -Type DWord
netsh interface teredo set state disabled | Out-Null
Start-Sleep -Milliseconds 500

# Disables IPv6
Write-Host "Disabling IPv6..."
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6
Start-Sleep -Milliseconds 500

# Disables Activity History
Write-Host "Disabling Activity History..."
$RegistrySettingsAH = @{
    "Path"  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    "Items" = @(
        @{
            "Name"          = "EnableActivityFeed"
            "Type"          = "DWord"
            "Value"         = "0"
            "OriginalValue" = "1"
        },
        @{
            "Name"          = "PublishUserActivities"
            "Type"          = "DWord"
            "Value"         = "0"
            "OriginalValue" = "1"
        },
        @{
            "Name"          = "UploadUserActivities"
            "Type"          = "DWord"
            "Value"         = "0"
            "OriginalValue" = "1"
        }
    )
}
foreach ($Item in $RegistrySettingsAH["Items"]) {
    Set-ItemProperty -Path $RegistrySettingsAH["Path"] -Name $Item["Name"] -Type $Item["Type"] -Value $Item["Value"]
}
Start-Sleep -Milliseconds 500

# Disables Homegroup
Write-Host "Disabling Homegroup..."
$ServicesHome = @(
    @{
        "Name"         = "HomeGroupListener"
        "StartupType"  = "Manual"
        "OriginalType" = "Automatic"
    },
    @{
        "Name"         = "HomeGroupProvider"
        "StartupType"  = "Manual"
        "OriginalType" = "Automatic"
    }
)
foreach ($Service in $ServicesHome) {
    Set-Service -Name $Service["Name"] -StartupType $Service["StartupType"]
}
Start-Sleep -Milliseconds 500

# Disables Location Tracking
Write-Host "Disabling Location Tracking..."
$ErrorActionPreference = 'SilentlyContinue'
$RegistrySettingsLoc = @(
    @{
        "Path"          = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
        "Name"          = "Value"
        "Type"          = "String"
        "Value"         = "Deny"
        "OriginalValue" = "Allow"
    },
    @{
        "Path"          = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        "Name"          = "SensorPermissionState"
        "Type"          = "DWord"
        "Value"         = 0
        "OriginalValue" = 1
    },
    @{
        "Path"          = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
        "Name"          = "Status"
        "Type"          = "DWord"
        "Value"         = 0
        "OriginalValue" = 1
    },
    @{
        "Path"          = "HKLM:\SYSTEM\Maps"
        "Name"          = "AutoUpdateEnabled"
        "Type"          = "DWord"
        "Value"         = 0
        "OriginalValue" = 1
    }
)
foreach ($Item in $RegistrySettingsLoc) {
    Set-ItemProperty -Path $Item["Path"] -Name $Item["Name"] -Type $Item["Type"] -Value $Item["Value"] -ErrorAction SilentlyContinue | Out-Null
}
Start-Sleep -Milliseconds 500

# Hides Tray Icons
Write-Host "Hiding tray icons..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 1
Start-Sleep -Milliseconds 500

# Adds Ultimate Power Plan to Windows
Write-Host "Adding Ultimate Power Plan to Windows..."
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
Start-Sleep -Milliseconds 500

# Deletes Temporary Files
Write-Host "Deleting Temporary Files..."
Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse
Get-ChildItem -Path $env:TEMP *.* -Recurse | Remove-Item -Force -Recurse
Start-Sleep -Milliseconds 500

exit 0