<#
.Set_Local_Datastore_Name

.NOTES  Author: Josh Atwell @josh_atwell

.Label
Rename local esxi datastore to <host name>-local

.Description
Renames the local datastore of an ESX(i) host to a name based
on Hostname and a defined suffix.  Default suffix is "-local"
Not currently coded to handle multiple local disks.
#>

param(
[Parameter(Mandatory=$true)]
[VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]
$vmhost,
[Parameter(Mandatory=$false)]
$suffix = "-local"
);


$localds = $vmhost | Get-Datastore | Where {$_.Extensiondata.Summary.MultipleHostAccess -eq $False}
	if($localds.Count -gt 1){
        Write-Output "too many local disks found for $vmhost"
    }Else{
	$newdsname = $vmhost.Name.Split(".")[0] + $suffix
	Get-Datastore $localds | Set-Datastore -Name $newdsname
}