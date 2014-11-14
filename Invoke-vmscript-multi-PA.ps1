<#
.LABEL
Invoke shell commands on multiple VMs simultaneously
.DESCRIPTION
Written for PowerActions to use Invoke-VMScript. Invoke shell commands on multiple VMs simultaneously through
PowerActions. Script prompts for guest OS credentials (must be the same credentials for all of the selected
VM's, then it prompts for the command to execute. Output is returned in the console window. Each time you run
a command is a new session to the VMs. If you want to chain commands togetherit must be done in a single scriptblock
as it is in the invoke-vmscript Powercli command.
#>

param
(
[Parameter(Mandatory=$true)]
[VMware.VimAutomation.ViCore.Types.V1.Inventory.VirtualMachine[]]
$vms
);

# Prompt for credentials
$cred = $Host.ui.PromptForCredential("","Enter a user account with rights execute the command on the guest OS","","")

# Prompt for Command to execute on guest OS
$fields = new-object "System.Collections.ObjectModel.Collection``1[[System.Management.Automation.Host.FieldDescription]]"
$f = New-Object System.Management.Automation.Host.FieldDescription "Enter the command to execute via Invoke-vmscript"
$f.DefaultValue = ""
$f.Label = "&Script Text"
$fields.Add($f)
$results = $Host.UI.Prompt( "ScriptBlock", "Enter command to execute via Invoke-vmscript", $fields )
$script = $results.Values

# Execute the command on all selected VMs
Foreach ($vm in $vms) {
Invoke-VMScript -VM $vm -ScriptText $script -GuestCredential $cred
}
