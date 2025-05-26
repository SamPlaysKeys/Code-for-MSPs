
# Test Directory \\PROJWKS001\c$\Users\ECAdmin
# \\$Workstation\c$\Users\$Username\$Folder
# $Workstation = Old Computer name
# $Username = $env:USERNAME
# $Folder equals folder to copy


$Workstation = Read-Host "Please enter the User's Old workstation name"
$Username = Read-Host "Please enter the User's username"
New-Item -Path 'c:\Logs' -ItemType Directory
#User Folders
robocopy "\\$Workstation\c$\Users\$Username\Desktop" "c:\Users\$Username\Desktop" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyDesktopLog.txt /v /np
robocopy "\\$Workstation\c$\Users\$Username\Documents" "c:\Users\$Username\Documents" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyDocumentsLog.txt /v /np
robocopy "\\$Workstation\c$\Users\$Username\Pictures" "c:\Users\$Username\Pictures" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyPicturesLog.txt /v /np
robocopy "\\$Workstation\c$\Users\$Username\Music" "c:\Users\$Username\Music" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyMusicLog.txt /v /np
robocopy "\\$Workstation\c$\Users\$Username\Video" "c:\Users\$Username\Video" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyVideoLog.txt /v /np
robocopy "\\$Workstation\c$\Users\$Username\Downloads" "c:\Users\$Username\Downloads" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyDownloadsLog.txt /v /np

#Signatures
robocopy "\\$Workstation\c$\Users\$Username\AppData\Roaming\Microsoft\Signatures" "$env:HOMEPATH\AppData\Roaming\Microsoft\Signatures" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopySignaturesLog.txt /v

#Chrome
robocopy "\\$Workstation\c$\Users\$Username\AppData\Local\Google\Chrome" "$env:HOMEPATH\AppData\Local\Google\Chrome" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyChromeLog.txt /v
 
#Pinned Items
robocopy "\\$Workstation\c$\Users\$Username\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations" "$env:HOMEPATH\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyPinnedItemsLog.txt /v

#Background
robocopy "\\$Workstation\c$\Users\$Username\AppData\Roaming\Microsoft\Windows\Themes" "$env:HOMEPATH\AppData\Roaming\Microsoft\Windows\Themes" /e /b /copyall /r:6 /w:5 /MT:32 /tee /log:C:\Logs\robocopyBackgroundLog.txt /v


