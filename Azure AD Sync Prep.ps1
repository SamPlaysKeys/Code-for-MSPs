$TestMSOLUser = $MSOLUsers[1]
$TestADUser = Get-ADUser -Filter "userPrincipalName -like '$($MSOLUsers[1].UserPrincipalName)'-and Enabled -eq 'True'" -Properties ProxyAddresses

if(!($TestMSOLUser.ProxyAddresses -eq $TestADUser.ProxyAddresses)){
    Write-Output "They Don't Match"
}


$ThisADUser = Get-ADUser -identity "mpense" -Properties *

$MSOLUsers = Get-MsolUser
$ACount=0
foreach($MUser in $MSOLUsers){
    $AUser = Get-ADUser -Filter "userPrincipalName -like '$(($MUser).UserPrincipalName)' -and Enabled -eq 'True'" -Properties *
    $UserProxyAddresses = $MUser.ProxyAddresses
    $PAddresses = $UserProxyAddresses -join ","
    if($AUser.Enabled){
        if(!($Muser.ProxyAddresses -eq $AUser.ProxyAddresses)){
            [PSCustomObject]@{
                Name = "$($AUser.DisplayName)"
                MProxy = "$($MUser.ProxyAddresses)"
                AProxy = "$($AUser.ProxyAddresses)"
            } | Export-CSV -Path "C:\Temp\PostAzureADMigration.csv" -Append -NoTypeInformation
        }
    }
}


foreach($MUser in $MSOLUsers){
    $AUser = Get-ADUser -Filter "userPrincipalName -like '$(($MUser).UserPrincipalName)' -and Enabled -eq 'True'" -Properties *
    $UserProxyAddresses = $MUser.ProxyAddresses
    $PAddresses = $UserProxyAddresses -join ","
    if($AUser.Enabled){
        if(!($Muser.ProxyAddresses -eq $AUser.ProxyAddresses)){
            Set-ADUser -Identity $AUser.SamAccountName `
            -replace @{ProxyAddresses="$PAddresses" -split ","}
            Write-Host "$($AUser.DisplayName) has been updated."
        }
    }
}

[PSCustomObject]@{
    Name = $AUser.DisplayName
    MProxy = $MUser.ProxyAddresses
    AProxy = $AUser.ProxyAddresses
}
| Export-CSV -Path "C:\Temp\PreAzureADMigration.csv" -Append -NoTypeInformation









$TestMSOLUser.ProxyAddresses
$TestADUser.ProxyAddresses
$UserProxyAddresses = $TestMSOLUser.ProxyAddresses
$PAddresses = $UserProxyAddresses -join ","
Set-ADUser -Identity $TestADUser.SamAccountName `
-replace @{ProxyAddresses="$PAddresses" -split ","}