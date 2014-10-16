<#
.LABEL
Kill-VM
.DESCRIPTION
Performs a Hard or Soft kill of a hung Virtual Machine.
#>

param
(
   [Parameter(Mandatory=$true)]
   [VMware.VimAutomation.ViCore.Types.V1.Inventory.VirtualMachine]
   $vParam
);

Function Kill-VM {
		<#
		.SYNOPSIS
			Kills a Virtual Machine.

		.DESCRIPTION
			Kills a virtual machine at the lowest level, use when Stop-VM fails.

		.PARAMETER  VM
			The Virtual Machine to Kill.

		.PARAMETER  KillType
			The type of kill operation to attempt. There are three
    types of VM kills that can be attempted:   [soft,
    hard, force]. Users should always attempt 'soft' kills
    first, which will give the VMX process a chance to
    shutdown cleanly (like kill or kill -SIGTERM). If that
    does not work move to 'hard' kills which will shutdown
    the process immediately (like kill -9 or kill
    -SIGKILL). 'force' should be used as a last resort
    attempt to kill the VM. If all three fail then a
    reboot is required.

		.EXAMPLE
			PS C:\> Kill-VM -VM (Get-VM VM1) -KillType soft

		.EXAMPLE
			PS C:\> Get-VM VM* | Kill-VM

		.EXAMPLE
			PS C:\> Get-VM VM* | Kill-VM -KillType hard
	#>
	param (
		[Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
		$VM, $KillType
	)
	PROCESS {
		if ($VM.PowerState -eq "PoweredOff") {
			Write-Host "$($VM.Name) is already Powered Off"
		} Else {
			$esxcli = Get-EsxCli -vmhost ($VM.Host)
			$WorldID = ($esxcli.vm.process.list() | Where { $_.DisplayName -eq $VM.Name}).WorldID
			if (-not $KillType) {
				$KillType = "soft"
			}
			$result = $esxcli.vm.process.kill($KillType, $WorldID)
			if ($result -eq "true"){
				Write-Host "$($VM.Name) killed via a $KillType kill"
			} Else {
				$result
			}
		}
	}
}
$VM = $vParam

$title = "Kill Virtual hung Machine"
$message = "Perform a hard or soft kill"

$hard = New-Object System.Management.Automation.Host.ChoiceDescription "&hard", `
    "Performs a hard kill of a VM"

$soft = New-Object System.Management.Automation.Host.ChoiceDescription "&soft", `
    "Performs a soft kill of a VM"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($hard, $soft)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result)
    {
        0 {$KillType = "hard"}
        1 {$KillType = "soft"}
    }

$title = "Kill Virtual hung Machine"
$message = "Are you sure you want to kill $vParam?"

$hard = New-Object System.Management.Automation.Host.ChoiceDescription "&yes", `
    "Performs a kill of a VM"

$soft = New-Object System.Management.Automation.Host.ChoiceDescription "&no", `
    "Cancels a kill of a VM"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($hard, $soft)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result)
    {
        0 {Get-vm $vm | kill-vm -KillType $KillType}
        1 {Write-Host "Canceled"}
    }
