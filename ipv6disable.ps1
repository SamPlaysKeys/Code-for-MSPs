function getIPv6Status{
# Check if any network adapter has IPv6 enabled
    $ipv6Enabled = Get-NetAdapterBinding -ComponentID ms_tcpip6 | Where-Object { $_.Enabled -eq $true }

    if ($ipv6Enabled) {
        # IPv6 is enabled on at least one adapter, remediation is needed
        Write-Output "IPv6 is enabled"
        exit 1  # Indicates non-compliance (remediation needed)
    } else {
        # IPv6 is disabled on all adapters, no remediation needed
        Write-Output "IPv6 is disabled"
        exit 0  # Indicates compliance (no remediation needed)
    }
}


function disableIPv6{
    # Get all network adapters with IPv6 enabled
    $adapters = Get-NetAdapterBinding -ComponentID ms_tcpip6 | Where-Object { $_.Enabled -eq $true }
    
    # Loop through each adapter and disable IPv6
    foreach ($adapter in $adapters) {
        Disable-NetAdapterBinding -Name $adapter.Name -ComponentID ms_tcpip6
    }
    
    Write-Output "IPv6 has been disabled on all adapters"
}
