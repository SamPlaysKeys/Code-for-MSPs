#Create user profile

#Disable Umbrella and connect to Domain controller
Set-Service -Name "Umbrella_RC" -Status stopped -StartupType disabled
$CompNIC = Get-DnsClientServerAddress | Where-Object {$Null -ne $_.ServerAddresses} | Where-Object {$_.AddressFamily -Like 2} | Where-Object {$_.InterfaceAlias -like "WI-Fi"}
Set-DNSClientServerAddress $CompNIC.InterfaceAlias –ServerAddresses ("8.8.8.8")

#Create user profile
runas /env /profile /user:LocalUser cmd.exe Exit

#Re-enabled Umbrella and remove manual DNS
Set-DNSClientServerAddress $CompNIC.InterfaceAlias -ResetServerAddresses
Set-Service -Name "Umbrella_RC" -StartupType Automatic
Set-Service -Name "Umbrella_RC" -Status Running