Import-Module $env:SyncroModule
#$Username = Set by syncro runtime variable
#$Password = Set by syncro runtime variable

$group = "Administrators"
$KeyPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add
    Rmm-Alert -Category 'Automation' -Body 'Local Admin Account Added'
}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

#Add new administrator in Registry
#Followed this walkthrough: https://www.techwalla.com/articles/how-to-make-an-administration-account-using-regedit
New-Item -Path "$KeyPath" -Name SpecialAccounts | Out-Null
New-Item -Path "$KeyPath\SpecialAccounts" -Name UserList | Out-Null
New-ItemProperty -Path "$KeyPath\SpecialAccounts\UserList" -Name $Username -Value 0 -PropertyType DWord | Out-Null