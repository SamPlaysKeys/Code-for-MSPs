# Remediation Script for IPv6 RouterDiscovery settings
# This script sets the correct RouterDiscovery value for all IPv6 interfaces

# Define the desired RouterDiscovery value
$DesiredRouterDiscovery = "Disabled" # Change to your required value: "Disabled", "Enabled", "ControlledByDHCP"

try {
    # Get all IPv6 interfaces
    $IPv6Interfaces = Get-NetIPInterface -AddressFamily IPv6 -ErrorAction Stop
    
    # Initialize variable to track fixes
    $FixedInterfaces = @()
    
    # Set RouterDiscovery property for each non-compliant IPv6 interface
    foreach ($Interface in $IPv6Interfaces) {
        if ($Interface.RouterDiscovery -ne $DesiredRouterDiscovery) {
            Write-Output "Setting RouterDiscovery to $DesiredRouterDiscovery for interface $($Interface.InterfaceAlias)"
            
            # Apply the change
            Set-NetIPInterface -InterfaceIndex $Interface.InterfaceIndex -RouterDiscovery $DesiredRouterDiscovery -ErrorAction Stop
            
            $FixedInterfaces += [PSCustomObject]@{
                InterfaceAlias  = $Interface.InterfaceAlias
                InterfaceIndex  = $Interface.InterfaceIndex
                RouterDiscovery = $DesiredRouterDiscovery
            }
        }
    }
    
    # Output results
    if ($FixedInterfaces.Count -gt 0) {
        Write-Output "The following interfaces were updated:"
        $FixedInterfaces | Format-Table -AutoSize | Out-String | Write-Output
    } else {
        Write-Output "No interfaces needed to be updated."
    }
    
    # Verify changes were applied successfully
    $VerifyInterfaces = Get-NetIPInterface -AddressFamily IPv6
    $StillNonCompliant = $VerifyInterfaces | Where-Object { $_.RouterDiscovery -ne $DesiredRouterDiscovery }
    
    if ($StillNonCompliant) {
        Write-Output "Some interfaces could not be remediated:"
        $StillNonCompliant | Select-Object InterfaceAlias, InterfaceIndex, RouterDiscovery | Format-Table -AutoSize | Out-String | Write-Output
        exit 1 # Remediation failed
    } else {
        Write-Output "All IPv6 interfaces now have RouterDiscovery set to $DesiredRouterDiscovery"
        exit 0 # Remediation successful
    }
} catch {
    Write-Error "Error remediating IPv6 RouterDiscovery: $_"
    exit 1 # Remediation failed
}

