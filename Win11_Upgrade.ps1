Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

$dir = 'C:\_Windows_FU\packages'

mkdir $dir

$webClient = New-Object System.Net.WebClient

$url = 'https://go.microsoft.com/fwlink/?linkid=2171764'

$file = "$($dir)\Win11Upgrade.exe"

$webClient.DownloadFile($url,$file)

Start-Process -FilePath $file -ArgumentList '/quietinstall /EULA accept /auto upgrade /copylogs $dir'



function CmdInstall {
    param (
        Powershell.exe -command "Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2171764' -OutFile 'C:\Temp\upgrade.exe'";

        powershell.exe -command "Test-Path C:\Temp\upgrade.exe" 

        powershell.exe -command "New-Item C:\temp\logwin11.txt; Start-Process -FilePath 'C:\temp\upgrade.exe' -ArgumentList '/quietinstall /EULA accept /auto upgrade /copylogs C:\temp\logwin11.txt'"
    )
    
}