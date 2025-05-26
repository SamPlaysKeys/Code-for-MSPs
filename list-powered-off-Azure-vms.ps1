# Connect to Azure
Connect-AzAccount

# Select all VMs in the specified resource group
$vms = Get-AzVM -ResourceGroupName "GSSPersonalpool"

# Filter VMs that are powered off
$poweredOffVMs = $vms | Where-Object { $_.PowerState -eq "VM deallocated" }

# Output the list of powered-off VMs
$poweredOffVMs | ForEach-Object { Write-Output $_.Name }

