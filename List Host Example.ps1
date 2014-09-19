<#
.MYNGC_REPORT

.LABEL
Sample Example Script

.DESCRIPTION
Example script to use as template.
#>

param
(
   [Parameter(Mandatory=$true)]
   [VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]
   $vhost
);

$vhost
