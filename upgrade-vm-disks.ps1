# Import necessary module
Import-Module Az

# Function to upgrade VM disks
function Upgrade-VMDisks {
    param (
        [string[]]$VMNames
    )

    foreach ($vmName in $VMNames) {
        Write-Output "Processing VM: $vmName"
        
        # Get the VM
        $vm = Get-AzVM -Name $vmName
        
        # Get OS disk
        $osDisk = $vm.StorageProfile.OsDisk
        
        # Upgrade OS disk if necessary
        if ($osDisk.ManagedDisk.StorageAccountType -ne 'Premium_LRS') {
            Write-Output "Upgrading OS disk for $vmName"
            $osDisk.ManagedDisk.StorageAccountType = 'Premium_LRS'
        }
        
        # Get data disks
        $dataDisks = $vm.StorageProfile.DataDisks
        
        # Upgrade each data disk if necessary
        foreach ($dataDisk in $dataDisks) {
            if ($dataDisk.ManagedDisk.StorageAccountType -ne 'Premium_LRS') {
                Write-Output "Upgrading data disk $($dataDisk.Name) for $vmName"
                $dataDisk.ManagedDisk.StorageAccountType = 'Premium_LRS'
            }
        }
        
        # Update the VM with the new disk settings
        Update-AzVM -ResourceGroupName $vm.ResourceGroupName -VM $vm
        
        Write-Output "Completed processing for VM: $vmName"
    }
}

# Example usage
$vmNames = @("VM1", "VM2") # Replace with actual VM names or input
Upgrade-VMDisks -VMNames $vmNames

Write-Output "All VMs processed."

