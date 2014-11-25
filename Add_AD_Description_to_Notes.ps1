<#
.LABEL
Adds AD Description to Notes

.DESCRIPTION
This  version of the script requires Quest Active Roles management plugin or can be modified to use MS AD module. 
This script will query Active Directory and find the Active Directory description for each VM, 
then write the description to the Notes property of the VM. If a computer account does not
exist in AD it will leave the notes blank.
http://www.quest.com/powershell/activeroles-server.aspx
#>
param
(
   [Parameter(Mandatory=$true)]
   [VMware.VimAutomation.ViCore.Types.V1.Inventory.Folder]
   $vParam
);
Get-PSSnapin -Registered "Quest.ActiveRoles*" | Add-PSSnapin -PassThru

$cred = get-credential


#Connect to and validate connection to domain
$i = 1
DO {
$i++
connect-qadservice vectren.com -Credential $cred | out-null
$test = Get-QADRootDSE
start-sleep -Seconds 5
} Until (($test -ne $null) -or ($i -eq 5))

If ($i -eq 5) {
Write-host "An error occured connecting to the domain"
Exit
}

# Pull your VMs into an array
$Guests = Get-VM
# Loop through the array to read the AD Description field to set the Annotation in vCenter
ForEach ($Guest in $Guests) {
# Clear the variable just in case there is no match. It may keep the previous value.
Clear-Variable Description
Clear-Variable ADComputer
  $ADComputer = Get-QADComputer “$Guest” -Properties Description
  $Description = $ADComputer.Description
If ($Description -eq $null) {
Write-host "No AD account found for $guest"
}
Else {
  Set-VM -VM $Guest -Notes $Description -Confirm:$false
}
}
