#====================================================================================
#
#   Version 1.0.0.0
#   Date : 24-Jun-2019, Sukhvinder
#   Client: Zurich Financial Services and NG
#
#====================================================================================


[CmdletBinding(SupportsShouldProcess=$True)]
param( )

function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope Script).Value
    Split-Path $Invocation.MyCommand.Path
}

Import-Module (Join-Path (Get-ScriptDirectory) "Common.psm1")
Initialize-Log $Script:PSBoundParameters

$NICs = Get-WmiObject Win32_NetworkAdapter -filter "AdapterTypeID = '0' AND PhysicalAdapter = 'true' AND NOT Description LIKE '%virtual%' AND NOT Description LIKE '%Bluetooth%'"
$DockState = (Get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\IDConfigDB\CurrentDockInfo").DockingState
 if ($DockState -eq "1")
{
 #Write-Host ("Machine is Docked")
Write-Log "Machine is connected to docking station"
}
 else
{
Write-Log "Machine is not connected to docking station"
}
Write-Log "Power management settings for following devices will be disabled"
Foreach ($NIC in $NICs)
{
    $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | where {$_.InstanceName -match [regex]::Escape($nic.PNPDeviceID)}
	
	Write-Log $nic.Description
	#Write-Log Device PNPId: $nic.PNPDeviceID
	#Write-Log Device Current Power Settings: $powerMgmt.Enable
	#Write-Host ($nic.PNPDeviceID) 
	#Write-Host ($powerMgmt.Enable)
	#Write-Host ($nic.Description) 

  If ($powerMgmt.Enable -eq $True)
    {
         $powerMgmt.Enable = $False
         $powerMgmt.psbase.Put()
    }
}
