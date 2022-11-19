
<#
	.SYNOPSIS
		Powershell System Info Script
	
	.DESCRIPTION
		This is just a script for the sake of learning about various classes and something quick and useful to grab data.
#>

class SystemInfo {
   [string] $ComputerName
   [string] $BIOSmanufacturer
   [string] $BIOSversion
   [string] $Domain
   [int]    $NumberOfProcessors   
   [int]    $NumberOfCores  
   [double] $TotalPhysicalMemory   
   [string] $OperatingSystemName   
   [string] $OperatingSystemArchitecture   
   [string] $TimeZone   
   [double] $SizeOfCdrive   
   [double] $CdriveFreeSpace       
}
$sinfo = [SystemInfo]::new()  

$compsys = Get-CimInstance -ClassName Win32_ComputerSystem  

$sinfo.ComputerName = $compsys.Name 
$sinfo.TotalPhysicalMemory = [math]::Ceiling($compsys.TotalPhysicalMemory / 1GB)  

$sinfo.Domain = $compsys.Domain  

$sinfo.NumberOfProcessors = $compsys.NumberOfProcessors  

$proc = Get-CimInstance -ClassName Win32_processor 
$sinfo.NumberOfCores = $proc.NumberOfCores  

$bios = Get-CimInstance -ClassName Win32_Bios 
$sinfo.BIOSmanufacturer = $bios.Manufacturer 
$sinfo.BIOSversion = $bios.Version  

$os = Get-CimInstance -ClassName Win32_OperatingSystem 
$sinfo.OperatingSystemName = $os.Caption 
$sinfo.OperatingSystemArchitecture = $os.OSArchitecture  

$sinfo.TimeZone = (Get-TimeZone).DisplayName  

$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"  

$sinfo.SizeOfCdrive = [math]::Round(($disk.Size / 1GB), 2) 
$sinfo.CdriveFreeSpace = [math]::Round(($disk.FreeSpace / 1GB), 2)  

$sinfo
