$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url = "https://download5.veeam.com/VeeamAgentWindows_3.0.2.1170_.zip"
$checksumZip = "86c8a898dbeadc0aba910002dd37d710f9ad0fa580e3fe7388c3d205aea793fd4427bd3c01c43debc9477bacc3335a7af7c659f1548b6a36caa462493f868552"
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
