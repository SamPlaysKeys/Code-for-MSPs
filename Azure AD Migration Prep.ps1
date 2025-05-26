#Check for MSOnline then import
if(-not (Get-Module MSOnline -ListAvailable)){
        Write-Host "Installing MSOnline Module"
        Install-Module -Name MSOnline
}
Import-Module MSOnline

#Azure AD Migration Prep
$OnPrem_Domain = $(get-ADForest).Domains
$MSOL_Domain = Get-adforest | select UPNSuffixes -ExpandProperty UPNSuffixes
$Domain = $(get-ADForest).Domains.Split(".")

#Check if User OU is still Default
if($($(Get-ADDomain).userscontainer) -eq "CN=Users,DC=$($Domain[0]),DC=$($Domain[1])"){
        Write-Host "Default User OU has not been changed. Please enter the OU to be Synced."
        $NewOU = Read-Host 
        redirusr $NewOU
        Write-Host "Default User OU has been updated."
        Write-Host "CN=Users,DC=$($Domain[0]),DC=$($Domain[1]) -> $NewOU"
}

#Change UPN Suffix
$LocalUsers = Get-ADUser -Filter "UserPrincipalName -like '*$OnPrem_Domain' -and Enabled -eq 'True'" -SearchBase "$($(Get-ADDomain).userscontainer)" -Properties userPrincipalName -ResultSetSize $null
$LocalUsers | ForEach-Object {$newUpn = $_.UserPrincipalName.Replace("@$OnPrem_Domain","@$MSOL_Domain"); $_ | Set-ADUser -UserPrincipalName $newUpn.ToLower()}

#Add Email Property
$LocalUsers2 = Get-ADUser -Filter "Enabled -eq 'True' -and EmailAddress -notlike '*'" -SearchBase "$($(Get-ADDomain).userscontainer)" -Properties EmailAddress -ResultSetSize $null
$LocalUsers2 | ForEach-Object {$newEmail = $_.UserPrincipalName; $_ | Set-Aduser -EmailAddress $newEmail}

#Get User list from OU
$ADUsers = Get-aduser -Filter "Enabled -eq 'True'" -SearchBase "$($(Get-ADDomain).userscontainer)" -Properties *


foreach($ADUser in $ADUsers){
        [PSCustomObject]@{
                Type = "OnPrem"
                User = "$($ADUser.Displayname)"
                Display = "$($ADUser.Displayname)"
                FirstName = "$($ADUser.Givenname)"
                LastName = "$($ADUser.Surname)"
                UPN = "$($ADUser.UserPrincipalName)"
                Title = "$($ADUser.Title)"
                Department = "$($ADUser.Department)"
                Office = "$($ADUser.physicalDeliveryOfficeName)"
                Street = "$($ADUser.StreetAddress)"
                City = "$($ADUser.City)"
                State = "$($ADUser.State)"
                ZIP = "$($ADUser.PostalCode)"
                Country = "$($ADUser.Country)"
                Mobile = "$($ADUser.MobilePhone)"
                Email = "$($ADUser.mail)"
                Proxy = "$($ADUser.ProxyAddresses)"
        } | Export-CSV -Path "C:\Temp\PreAzureADMigration.csv" -Append -NoTypeInformation

        $MSOLUser = Get-MsolUser -UserPrincipalName $ADUser.userPrincipalName
        If($MSOLUser){
                [PSCustomObject]@{
                        Type = "MSOL"
                        User = "$($ADUser.Displayname)"
                        Display = "$($MSOLUser.DisplayName)"
                        FirstName = "$($MSOLUser.FirstName)"
                        LastName = "$($MSOLUser.LastName)"
                        UPN = "$($MSOLUser.UserPrincipalName)"
                        Title = "$($MSOLUser.Title)"
                        Department = "$($MSOLUser.Department)"
                        Office = "$($MSOLUser.Office)"
                        Street = "$($MSOLUser.StreetAddress)"
                        City = "$($MSOLUser.City)"
                        State = "$($MSOLUser.State)"
                        ZIP = "$($MSOLUser.PostalCode)"
                        Country = "$($MSOLUser.Country)"
                        Mobile = "$($MSOLUser.MobilePhone)"
                        Proxy = "$($MSOLUser.ProxyAddresses)"
                } | Export-CSV -Path "C:\Temp\PreAzureADMigration.csv" -Append -NoTypeInformation
        }

        #ProxyAddress Variables
        $UserProxyAddresses = (Get-MsolUser -UserPrincipalName $ADUser.userPrincipalName).ProxyAddresses
        $PAddresses = $UserProxyAddresses -join ","


        #Set Attributes
        Set-ADUser -Identity $ADUser.SamAccountName `
        -DisplayName $MSOLUser.DisplayName `
        -FirstName $MSOLUser.FirstName `
        -LastName $MSOLUser.LastName `
        -Title $MSOLUser.Title `
        -Department $MSOLUser.Department `
        -Office $MSOLUser.Office `
        -Street $MSOLUser.StreetAddress `
        -City $MSOLUser.City `
        -State $MSOLUser.State `
        -ZIP $MSOLUser.PostalCode `
        -Country $MSOLUser.Country `
        -Mobile $MSOLUser.MobilePhone `
        -EmailAddress $MSOLUser.UserPrincipalName `
        -replace @{ProxyAddresses="$PAddresses" -split ","}

        $NewADUser = Get-ADUser -Identity $ADUser.SamAccountName -Properties *
        
        #Check if UPNs match
        if($NewADUser.UserPrincipalName -eq $AAD_UPN){
                $UPNMatch = $True
        }


        Write-Host "Changes to $($ADUser.DisplayName)"
        Write-Host "---------------------------------------------------"
        Write-Host "New Display: $($NewADUser.Displayname) | Old Display $($ADUser.Displayname)"
        Write-Host "New FirstName: $($NewADUser.Givenname) | Old FirstName $($ADUser.Givenname)"
        Write-Host "New LastName: $($NewADUser.Surname) | Old LastName $($ADUser.Surname)"
        Write-Host "New UPN: $($NewADUser.UserPrincipalName) | Old UPN $($ADUser.UserPrincipalName)"
        Write-Host "New Title: $($NewADUser.Title) | Old Title $($ADUser.Title)"
        Write-Host "New Department: $($NewADUser.Department) | Old Department $($ADUser.Department)"
        Write-Host "New Office: $($NewADUser.physicalDeliveryOfficeName) | Old Office $($ADUser.physicalDeliveryOfficeName)"
        Write-Host "New Street: $($NewADUser.StreetAddress) | Old Street $($ADUser.StreetAddress)"
        Write-Host "New City: $($NewADUser.City) | Old City $($ADUser.City)"
        Write-Host "New State: $($NewADUser.State) | Old State $($ADUser.State)"
        Write-Host "New ZIP: $($NewADUser.PostalCode) | Old ZIP $($ADUser.PostalCode)"
        Write-Host "New Country: $($NewADUser.Country) | Old Country $($ADUser.Country)"
        Write-Host "New Mobile: $($NewADUser.MobilePhone) | Old Mobile $($ADUser.MobilePhone)"
        Write-Host "New Email: $($NewADUser.mail) | Old Email $($ADUser.mail)"
        Write-Host "New Proxy: $($NewADUser.ProxyAddresses) | Old Proxy $($ADUser.ProxyAddresses)"

        if($NewADUser.Displayname -eq $ADUser.Displayname){Write-Host"Displayname did not change"}
        if($NewADUser.Givenname -eq $ADUser.Givenname){Write-Host"Firstname did not change"}
        if($NewADUser.Surname -eq $ADUser.Surname){Write-Host"Surname did not change"}
        if($NewADUser.UserPrincipalName -eq $ADUser.UserPrincipalName){Write-Host"UserPrincipalName did not change"}
        if($NewADUser.Title -eq $ADUser.Title){Write-Host"Title did not change"}
        if($NewADUser.Department -eq $ADUser.Department){Write-Host"Department did not change"}
        if($NewADUser.physicalDeliveryOfficeName -eq $ADUser.physicalDeliveryOfficeName){Write-Host"physicalDeliveryOfficeName did not change"}
        if($NewADUser.StreetAddress -eq $ADUser.StreetAddress){Write-Host"StreetAddress did not change"}
        if($NewADUser.City -eq $ADUser.City){Write-Host"City did not change"}
        if($NewADUser.State -eq $ADUser.State){Write-Host"State did not change"}
        if($NewADUser.PostalCode -eq $ADUser.PostalCode){Write-Host"PostalCode did not change"}
        if($NewADUser.Country -eq $ADUser.Country){Write-Host"Country did not change"}
        if($NewADUser.MobilePhone -eq $ADUser.MobilePhone){Write-Host"MobilePhone did not change"}
        if($NewADUser.mail -eq $ADUser.mail){Write-Host"mail did not change"}
        if($NewADUser.ProxyAddresses -eq $ADUser.ProxyAddresses){Write-Host"ProxyAddresses did not change"}

}