<#! Command summary:
Command: Get-DnsClientServerAddress
#This will return the list of interfaces, and the addresses for each. 
Command: Set-DnsClientServerAddress -InterfaceIndex 1 -ServerAddresses 1.1.1.1,1.0.0.1
#This sets the DNS server as listed. Make sure to update the Interface Index to match the desired interface.
#Set this back to 127.0.0.1 when finished to let the computer use umbrella again.
#>


# This script will automatically set all active network ports to a desired DNS entry, and export the changes to a log file located in the C:\Temp directory.
# For a more manual approach, instead of a For-Each statement, use Read-Host or a GUI checklist to select the DNS entries to update.

# NOTICE: This script requires administrator permissions in order to update the DNS entries. If run as a standard user, it will fail with "access denied" errors. 

# Variables:
$DNS = (Get-DnsClientServerAddress -AddressFamily IPv4) # Get current DNS settings
$PrettyDNS = $DNS | Format-Table # Format DNS table to make it pretty for the log
$Logdate = Get-Date -Format "MM_dd_yyyy" # Get the date for the log filename
$LogFile = "C:\Temp\DNSLog" + $Logdate + ".txt" # Build the Log Filename
$DesiredDNS = "1.1.1.1,1.0.0.1" # Set Desired DNS to the desired DNS Server to be overwritten. It can also be set to Read-Host to allow actively settings the server address when running. 
$Date = Get-Date # Get date for the log entry

If ($LogFile) {Remove-Item -Path $LogFile -ErrorAction Ignore} # Removes previous log if one exists. Only applies to multiple runs on the same day.

New-Item -Path $LogFile -Value "DNS Change Log: $Date`n`nOld DNS Entries:`n$PrettyDNS`n`n" # Create a new log file.

ForEach ($i in $DNS) {
    if ($i.ServerAddresses){
        $Entry = "Interface" + $i.InterfaceAlias + $i.Name + " (" +$i.ServerAddresses +")" + "`nwill be changed to " + $DesiredDNS # Creates the log entry for this interface
        Add-Content $LogFile $Entry # Adds the log entry to the log file
        $Entry = "" # clears the entry variable to reduce errors and system impact
        Set-DnsClientServerAddress -InterfaceIndex $i.InterfaceIndex -ServerAddresses $DesiredDNS # Updates the DNS entry for the current interface.
    }
}

$NewPretty = (Get-DNSClientServerAddress -AddressFamily IPv4) # Pulls the new DNS list for the Log

$summary = "New DNS Entries are: `n`n" + $NewPretty # Creates the summary of the Changes

Add-Content $LogFile $summary # Adds the content to the log

Write-Host "`nFinished"
