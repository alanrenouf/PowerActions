<#
.LABEL
Ping-VMs-On-Host

.DESCRIPTION
Performs continuous of all VMs on an ESX host. Successful pings are displayed in green and failed pings are displayed in red.
#>

param
(
   [Parameter(Mandatory=$true)]
   [VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]
   $Phost
);

$computers = Get-VMHost | Where-Object {$_.Name -like "$Phost*"} | GET-VM
do {
$i=1
Foreach ($computer in $computers) {
$i++
$computer = ($computer).guest.HostName
$results = gwmi -query "SELECT * FROM Win32_PingStatus WHERE Address = '$computer'"
if ($results.StatusCode -eq 0) {
Write-Host "$computer hostname is pingable"
}
else {
Write-Error "$computer hostname is not pingable"
}
}
}
While ($i -le 9999)
