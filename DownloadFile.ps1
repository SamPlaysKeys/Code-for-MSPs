Powershell.exe -command "Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2171764' -OutFile 'C:\Temp\upgrade.exe'"

powershell -command "Test-Path C:\Temp\upgrade.exe" 

powershell -command "New-Item C:\temp\logwin11.txt; Start-Process -FilePath 'C:\temp\upgrade.exe' -ArgumentList '/quietinstall /EULA accept /auto upgrade /copylogs C:\temp\logwin11.txt'"