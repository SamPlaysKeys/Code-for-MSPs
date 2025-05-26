Import-Module $env:SyncroModule 
 <#line 1 is only used by syncro in order to connect the variables and add other options, 
 and can be commented or removed if used outside of SyncroRMM#>
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

<#
In order to use this powershell independent of Syncro, you will need to include prompts for:
$checkversion - whether or not you want to automatically check for Windows Version compatibility
$apiendpoint - this is explained in the domotz installation guide
$activationkey - this is also from the domotz installation guide
$agentname - what you would like the name of the agent location to be, i.e. "Main Office"
#>

function InstallDomotz {
Write-host "Time to get Domotz up in here!"

#This is information used for activation once the program is installed
$AgentName = "$agentname"

#Build the activation body
$ActivationKey = "$activationkey"
$ApiEndpoint = "apiendpoint"
$ActivationHeaders = @{
    "X-API-Key" = $ActivationKey
}
$ActivationBody = @{
    "name" = $AgentName
    "endpoint" = $ApiEndpoint
} | ConvertTo-Json

#Creating Temp folders
$tempdir = "c:\temp"
if ([System.IO.File]::Exists($tempdir)){write-host "Temp directory exists already"}
else {New-Item -Path "C:\temp" -ItemType Directory -erroraction 'silentlycontinue'}

New-Item -Path "C:\temp\domotz" -ItemType Directory -erroraction 'silentlycontinue'

#download variables
$AgentUrl = "https://portal.domotz.com/download/agent_packages/domotz-windows-x64-10.exe"
$WindowsAgentInstallerFile = "c:\temp\domotz\domotz_agent_installer.exe"
$WindowsAgentInstallerDir = "C:\temp\domotz"

#network addresses
$ActivationUrl = "http://127.0.0.1:3000/api/v1/agent"

#The actual download:
Invoke-WebRequest -Uri $AgentUrl -OutFile $WindowsAgentInstallerFile
Write-Host "Downloading Domotz installer to $WindowsAgentInstallerFile"

#Installing the file
Write-Host "Executing installer $WindowsAgentInstallerFile"
Start-Process -FilePath $WindowsAgentInstallerFile -WorkingDirectory $WindowsAgentInstallerDir -ArgumentList "/W /S /D=`"C:\Program Files (x86)\domotz\`""

#pause for install
Start-Sleep 300

#Activating Agent
Invoke-RestMethod -Uri $ActivationUrl -Method Post -Headers $ActivationHeaders -ContentType "application/json" -Body $ActivationBody


Write-Host "Install Finished"

}

function DontInstall {
    Write-Host "This version of Windows ($versionfull) is not compatible with Domotz Pro."
    Write-Host "Please update to a newer version of Windows, or talk with your System Administrator"
}


#See if a version check is necessary
if ($checkversion -eq "yes") {
    
#System Check for compatibility
$versionfull = [version]((Get-WmiObject Win32_OperatingSystem).version)

#this stops windows 7 and older and server 2008 and older from installing, as Domotz does not support before Windows 8/Server 2012
if ($versionfull.Major -eq 6) {
    if ($versionfull.Minor -gt 1) { InstallDomotz }
    else { DontInstall }
}

elseif ($versionfull.Major -eq 10) { InstallDomotz }

else { DontInstall }
}

#this should be self-explanatory, but if a version-check is not necessary, just install Domotz
else {InstallDomotz}
