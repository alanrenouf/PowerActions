<#
.LABEL
Execute ESXCLI commands
.DESCRIPTION
Allows execution of ESXCLI commands against an vSphere host through PowerActions.
#>

param
(
   [Parameter(Mandatory=$true)]
   [VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost]
   $vmhost
);

Function Invoke-ESXCLIcommand {
# Prompt for Command to execute on guest OS
$fields = new-object "System.Collections.ObjectModel.Collection``1[[System.Management.Automation.Host.FieldDescription]]"
If ($script -eq $null){
$f = New-Object System.Management.Automation.Host.FieldDescription "Enter the command to execute via ESXCLI"
$f.DefaultValue = "`$esxcli"
}
Else {
$f = New-Object System.Management.Automation.Host.FieldDescription "Enter the command to execute via ESXCLI"
$f.DefaultValue = "$script"
}
$f.Label = "&Script Text"
$fields.Add($f)
$results = $Host.UI.Prompt( "ScriptBlock", "Enter command to execute via ESXCLI", $fields )
$global:script = $results.Values

# Run the command
Invoke-Expression $script
}

Function Run-again {
$title = "Run another?"
$message = "Execute another command on $vmhost?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&yes", "Prompts for another ScriptBlock"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&no", "Exit the script"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result) {
        0 {Invoke-ESXCLIcommand
           Run-again}
        1 {Write-Host "Finished running commands"
           Exit}
    }
}

$esxcli = get-esxcli -VMHost $vmhost

Invoke-ESXCLIcommand

Run-again
