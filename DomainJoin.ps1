try
{
    $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment -ErrorAction SilentlyContinue
}
catch { }

if($tsenv)
{

# PartOfDomain (boolean Property)
If (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain -eq "True"{
	 # Machine is domain joined              
         $tsEnv.Value("MachineOnDomain") = "TRUE"
	Write-Log "Device is joined to domain"}
	{
	Else{	$tsEnv.Value("MachineOnDomain") = "FALSE"
		Write-Log "Device is not joined to domain"}
}
