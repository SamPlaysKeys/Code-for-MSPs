#O365 hardmatch

#Connect to AzureAD
Connect-MsolService

#Initialize Variables
$UserPrincipalName = Read-Host "What is the UserPrincipalName"
$ADGuidUser = Get-ADUser -Filter "userPrincipalName -like '$UserPrincipalName'"
if ($Null -eq $ADGuidUser) {
    Write-Output "No On-Prem AD User could be found"
    Return
}
$UserimmutableID = [System.Convert]::ToBase64String($ADGuidUser.ObjectGUID.tobytearray())

$OnlineUser = Get-MsolUser -userPrincipalName "$UserPrincipalName"
if ($Null -eq $OnlineUser) {
    Write-Output "No Azure AD could be found"
    Return
}

Write-Output "Test $($ADGuidUser.UserPrincipalName) equals $($OnlineUser.UserPrincipalName)"
If($ADGuidUser.UserPrincipalName -eq $OnlineUser.UserPrincipalName){
    Write-Output "Test Successful"

    Write-Output "Test $($ADGuidUser.ObjectGUID) = $([Guid]([Convert]::FromBase64String($UserimmutableID)))"
    If($ADGuidUser.ObjectGUID -eq [Guid]([Convert]::FromBase64String($UserimmutableID))){
        Write-Output "Test Successful"

        Write-Output "Making Change"
        Set-MSOLuser -UserPrincipalName $OnlineUser.UserPrincipalName -ImmutableID $UserimmutableID

        Write-Output "Confirming Change"
        $OnlineUser = Get-MsolUser -userPrincipalName "$UserPrincipalName"
        Write-Output "Test $($UserimmutableID) = $($OnlineUser.ImmutableID)"
        If($UserimmutableID -eq $OnlineUser.ImmutableID){
            Write-Output "Guids match. Running Delta Sync"
            Start-ADSyncSyncCycle  -PolicyType Delta
        }else {
            Write-Output "Guids do not match. Expect issues."
        }

    }else {
        Write-Output "Guid did not convert properly"
    }
}else{
    Write-Output "Users' UPN do not match"
}

