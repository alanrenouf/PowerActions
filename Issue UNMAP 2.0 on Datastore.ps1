<#
.UNMAP 2.0

.NOTES  Author: William Lam

.LABEL
Issue UNMAP on a VMFS Datastore using vSphere 6.0 API

.DESCRIPTION
Script to issue UNMAP operation on specific VMFS datastore
#>

param
(
[Parameter(Mandatory=$true)]
[VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.Datastore]
$datastore
);

# Ensure we have a VMFS datastore
if($datastore.ExtensionData.Info -is [VMware.Vim.VmfsDatastoreInfo]) {
	$vmfsUUID = $datastore.ExtensionData.Info.vmfs.uuid


  # Retrieve a random ESXi host which has access to the selected Datastore
  $esxi = Get-View (($datastore.ExtensionData.Host | Get-Random).key) -Property 'ConfigManager.StorageSystem'

  # Access the ESXi StorageSystem
  $storage_system = Get-View $esxi.ConfigManager.StorageSystem

  # Issue VMFS UNMAP
  $task = $storage_system.UnmapVmfsVolumeEx_Task($vmfsUUID)
  $task1 = Get-Task -Id ("Task-$($task.value)")
  $task1 | Wait-Task -Verbose
}
