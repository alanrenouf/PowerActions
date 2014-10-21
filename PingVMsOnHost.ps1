<#

.LABEL

Ping-VMs-On-Host

.DESCRIPTION

Performs ping of all VMs on an ESX host. Successful pings are displayed in white and failed pings are displayed in red.


#>

param
(
   [Parameter(Mandatory=$true)]
   [VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]
   $Phost
);
$computers = Get-VMHost | Where-Object {$_.Name -like "$Phost*"} | GET-VM | Select-Object -Property Name
do {
$i=1
Foreach ($computer in $computers) {
$i++
$computer = ($computer).name
$results = gwmi -query "SELECT * FROM Win32_PingStatus WHERE Address = '$computer'"
if ($results.StatusCode -eq 0) {
Write-Host "$computer is Pingable"
}
else {
Write-Error "$computer is not Pingable"
}
}
}
While ($i -le 9999)
