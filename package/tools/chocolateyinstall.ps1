$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url = "https://download2.veeam.com/VeeamAgentWindows_4.0.0.1811.zip"
$checksumZip = "a2ea8c3b12f1dd7509985f46952cf63a72b9fdcf79ccf4644e836e789d78d09167a5871ba598b62194f4067e25c0bd9eee1641fe9453f03d35786935995b53bb"
$checksumTypeZip     = 'SHA512'

Import-Module -Name "$($toolsDir)\helpers.ps1"

$zipArgs = @{
	packageName    = $env:ChocolateyPackageName
	url            = $url
	unzipLocation  = $ENV:TMP
	checksum       = $checksumZip
	checksumType   = $checksumTypeZip
}

$packageArgs = @{
	packageName    = $env:ChocolateyPackageName
	fileType       = 'EXE'
	file           = "$($ENV:TMP)\VeeamAgentWindows_$($packageVersion).exe"
	silentArgs     = '/silent /accepteula /acceptthirdpartylicenses'
	validExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyZipPackage @zipArgs

Install-ChocolateyInstallPackage @packageArgs

if ($PackageParameters.NoAutostartHard) {
	Update-RegistryValue `
		-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" `
		-Name "Veeam.EndPoint.Tray.exe" `
        -Type Binary `
		-Value ([byte[]](0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)) `
		-Message "Disable Veeam Agent Autostart"
} else {
	Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" `
        -Name "Veeam.EndPoint.Tray.exe" `
        -Type Binary `
		-Value ([byte[]](0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)) `
		-Message "Default Veeam Agent Autostart"
}
	
if ($PackageParameters.CleanStartmenu) {
	Remove-FileItem `
		-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Veeam\"
	Install-ChocolateyShortcut `
		-ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Veeam Agent.lnk" `
		-TargetPath "C:\Program Files\Veeam\Endpoint Backup\Veeam.EndPoint.Tray.exe"
	Install-ChocolateyShortcut `
		-ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Veeam File Level Restore.lnk" `
		-TargetPath "C:\Program Files\Veeam\Endpoint Backup\Veeam.EndPoint.FLR.exe"
}	
