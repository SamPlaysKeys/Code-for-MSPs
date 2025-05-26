$content = Read-Host "What would you like the desktop file to say?`n"
$desktoppath = "C:\Users\Public\Desktop\TempFile.txt"
New-Item -Path $desktoppath
Set-Content -path $desktoppath $content
