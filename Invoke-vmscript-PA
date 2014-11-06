<#
.LABEL
Invoke shell commands on the selected VM
.DESCRIPTION
Written for PowerActions to use Invoke-VMScript. Invoke shell commands on the guest OS of the selected VM through
PowerActions. Script prompts for guest OS credentials, then prompts for the command to execute. Output is returned
in the console window. The script then prompts you to execute another command. Each time you run a command is a
new session to the VM. If you want to chain commands together it must be done in a single scriptblock as it is
in the invoke-vmscript Powercli command.
#>

param
(
[Parameter(Mandatory=$true)]
[VMware.VimAutomation.ViCore.Types.V1.Inventory.VirtualMachine]
$vm
);

Function Invoke-vmcommand {
# Prompt for Command to execute on guest OS
$fields = new-object "System.Collections.ObjectModel.Collection``1[[System.Management.Automation.Host.FieldDescription]]"
$f = New-Object System.Management.Automation.Host.FieldDescription "Enter the command to execute via Invoke-vmscript"
$f.DefaultValue = ""
$f.Label = "&Script Text"
$fields.Add($f)
$results = $Host.UI.Prompt( "ScriptBlock", "Enter command to execute via Invoke-vmscript", $fields )
$script = $results.Values

# Run the command
Invoke-VMScript -VM $vm -ScriptText $script -GuestCredential $cred
}

Function Run-again {
$title = "Run another?"
$message = "Execute another command on $vm?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&yes", "Prompts for another ScriptBlock"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&no", "Exit the script"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result) {
        0 {Invoke-vmcommand
           Run-again}
        1 {Write-Host "Finished running commands"
           Exit}
    }
}

# Prompt for credentials
$cred = $Host.ui.PromptForCredential("","Enter a user account with rights execute the command on the guest OS","","")

Invoke-vmcommand

Run-again
