<#
.MYNGC_REPORT

.LABEL
Issue UNMAP on Datastore

.DESCRIPTION
Script to issue UNMAP command on specified VMFS datastore
#>

param
(
[Parameter(Mandatory=$true)]
[VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.Datastore]
$datastore,
[Parameter(Mandatory=$true)]
[string]
$numofvmfsblocks
);

# Adjusted from William Lam
# https://github.com/lamw/vghetto-scripts/blob/master/powershell/unmap-poweraction.ps1
# Script to issue UNMAP command on specified VMFS datastore

# Retrieve a random ESXi host which has access to the selected Datastore
$esxi = (Get-View (($datastore.ExtensionData.Host | Get-Random).key) -Property Name).name
# Retrieve ESXCLI instance from the selected ESXi host
$esxcli = Get-EsxCli -Server $global:DefaultVIServer -VMHost $esxi
# Reclaim based on the number of blocks specified by user
$esxcli.storage.vmfs.unmap($numofvmfsblocks,$datastore,$null)
