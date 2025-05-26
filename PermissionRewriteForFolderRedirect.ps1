
Folder Redirection 
    E:\ServerFolders\Folder Redirection
FR
    E:\ServerFolders\Folder Redirection
Users
    E:\ServerFolders\Users
O:\
    \\HRG-ADC01\Folder Redirection\%Username%\documents


#ChangePermissions.ps1
# CACLS rights are usually
# F = FullControl
# C = Change
# R = Readonly
# W = Write

$StartingDir= "C:\Users"

$Principal="Domain Admins"

$Permission="F"

$Verify=Read-Host `n "You are about to change permissions on all" `
"files starting at"$StartingDir.ToUpper() `n "for security"`
"principal"$Principal.ToUpper() `
"with new right of"$Permission.ToUpper()"."`n `
"Do you want to continue? [Y,N]"

if ($Verify -eq "Y") {

foreach ($file in $(Get-ChildItem $StartingDir -recurse)) {
#display filename and old permissions
write-Host -foregroundcolor Yellow $file.FullName
#uncomment if you want to see old permissions
#CACLS $file.FullName

#ADD new permission with CACLS
CACLS $file.FullName /E /P "${Principal}:${Permission}" >$NULL

#display new permissions
Write-Host -foregroundcolor Green "New Permissions"
CACLS $file.FullName
}
}

CACLS "E:\ServerFolders\Folder Redirection\lcharpia\Music" /E /P "Domain Admins:F" >$NULL

.\psexec -s -i powershell -noexit "& 'C:\Users\hrgadmin\Documents\ConnectWiseControl\Files\TestPerms.ps1'"


$StartingDir = "E:\ServerFolders\Folder Redirection\"
$Principal = "Domain Admins"
$Permission = "F"

$Verify=Read-Host `n "You are about to change permissions on all" `
"files starting at"$StartingDir.ToUpper() `n "for security"`
"principal"$Principal.ToUpper() `
"with new right of"$Permission.ToUpper()"."`n `
"Do you want to continue? [Y,N]"

if ($Verify -eq "Y") {

    foreach ($file in $(Get-ChildItem -Directory $StartingDir -recurse)) {
    write-Host -foregroundcolor Yellow $file.FullName
    CACLS $file.FullName /E /P "${Principal}:${Permission}" >$NULL
    CACLS $file.FullName /E /P "HRGAdmin:${Permission}" >$NULL
    Write-Host -foregroundcolor Green "New Permissions"
    CACLS $file.FullName
    }
}