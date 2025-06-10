# Get all network adapters
$adapters = Get-NetAdapterBinding

# Loop through each adapter and disable IPv6
foreach ($adapter in $adapters) {
    Set-NetIPInterface -AddressFamily IPv6 -InterfaceIndex $(Get-NetIPInterface -AddressFamily IPv6 | Select-Object -ExpandProperty InterfaceIndex) -RouterDiscovery Disabled -Dhcp Disabled
}

Write-Output "IPv6 has been disabled on all adapters"
