#this program as written will not work outside of syncro, but it can be modified to run independantly by copying the desired code
#In order for this script to work, there must be two custom fields: Bitlocker Status, and Bitlocker Key
#purpose and drive variables are used to decide which function to follow, and are chosen within syncro when running the program 
#this code does not use creating/deleting text files, so no temp folders are needed


Import-Module $env:SyncroModule

$int123 = @("1","2","3","4","5","6","7","8","9","0")
$keyall = @("key", "both")
$statusall = @("status","both")

#Generate Bitlocker Status
$rawbl = (manage-bde -status $drive | Select-String -pattern "Protection Status" | Out-String)
$status = ($rawbl -replace "Protection Status:")

#bitlocker keygen
$key1 = ((Get-BitLockerVolume -MountPoint $drive).KeyProtector.recoverypassword | Out-String)
$keyout = (Echo "Bitlocker Key for $drive is $key1")


#Keygen Output
If ($purpose -in $keyall) {
    If ($status -in "on") {
        Set-Asset-Field -Name "Bitlocker Key" -Value $keyout
    }
    If ($status -in "off") {
        Log-Activity -Message "No Bitlocker key was available when the script was run" -EventName "Bitlocker Check"
        Set-Asset-Field -Name "Bitlocker Key" -Value "No key is available"
    }
}

#Status Output
If ($purpose -in $statusall) {
    
    #Logs an activity to show the script has been run, and the result
    Log-Activity -Message $rawbl.trim() -EventName "Bitlocker Check"
    
    #List the bitlocker status on the custom field
    Set-Asset-Field -Name "Bitlocker Status" -Value $status
}
