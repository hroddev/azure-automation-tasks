# Stop VM with Tag: Automation-stop-task value: autostop

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# Set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# set and store context

$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# get the VM's
$vms = Get-AzVM | Where-Object {$_.Tags['Automation-stop-task'] -eq 'autostop'}

# Start shutdown VM's
foreach ($vm in $vms) {
    $status = (Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -status).statuses[1].code
    if ($status -eq 'PowerState/running'){
        Write-Output "Stoping VM $vm.name "
        Stop-AzVM $vm.Name -ResourceGroupName $vm.ResourceGroupName -NoWait
    }
}