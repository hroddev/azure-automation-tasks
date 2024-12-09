
# Start VM with Tag: Automation-task-name value: autostart


# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# Set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# set and store context

$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# get the VM's
$vms = Get-AzVM | Where-Object {$_.Tags['Automation-task-name'] -eq 'autostart'}

# Start shutdown VM's
foreach ($vm in $vms) {
    $status = (Get-AzVM -Name $vm.Name - ResourceGroupName $vm.ResourceGroupName -status).statuses[1].code
    if ($status -ne 'PowerState/running'){
        Write-Output "Starting VM $vm.name "
        Start-AzVM $vm.Name -ResourceGroupName $vm.ResourceGroupName -NoWait
    }
}