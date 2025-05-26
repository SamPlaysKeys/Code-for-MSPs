Import-Module $env:SyncroModule
 
Clear-Host
 
$ErrorActionPreference= 'silentlycontinue'
 
# Delete Reg Key
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$regKey = "com.squirrel.Teams.Teams"
 
Remove-ItemProperty $regPath -Name $regKey
 
# Teams Config Path
$teamsConfigFile = "$env:APPDATA\Roaming\Microsoft\Teams\desktop-config.json"
$teamsConfig = Get-Content $teamsConfigFile -Raw
 
if ( $teamsConfig -match "openAtLogin`":false") {
    break
}
elseif ( $teamsConfig -match "openAtLogin`":true" ) {
    # Update Teams Config
    $teamsConfig = $teamsConfig -replace "`"openAtLogin`":true","`"openAtLogin`":false"
}
else {
    $teamsAutoStart = ",`"appPreferenceSettings`":{`"openAtLogin`":false}}"
    $teamsConfig = $teamsConfig -replace "}$",$teamsAutoStart
}
 
$teamsConfig | Set-Content $teamsConfigFile
 
Log-Activity -Message "Teams Deactivated by script" -EventName "Teams_Killer"

