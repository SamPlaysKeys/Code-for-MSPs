$Source = 'https://github.com/SamPlaysKeys/SamPlaysKeys/raw/main/cheese.mp4'
$Destination = 'C:\temp\Cheese.mp4'
$Destination2 = 'c:\temp\extracheese.mp4'

function Get-Local-Variables {
$setvolume = Read-Host "What volume would you like: Low, Medium, or High?"
clear
$cheese = Read-Host "How much cheese would you like? Cheese, or ExtraCheese?"
clear
Start-Sleep -s 2 
}

#Get-Local-Variables
$setvolume = "Low"
$cheese = "Cheese"

Function Set-Speaker($Volume){$wshShell = new-object -com wscript.shell;1..50 | % {$wshShell.SendKeys([char]174)};1..$Volume | % {$wshShell.SendKeys([char]175)}}
Start-Sleep -s 3

switch ($setvolume) {
    "Low" {Set-Speaker -Volume 15}
	"Medium" {Set-Speaker -Volume 25}
	"High" {Set-Speaker -Volume 40}
}

If ($cheese -eq "Cheese") {
    Invoke-WebRequest -Uri $Source -Outfile $Destination
    Start-Process Video.UI.exe -file $Destination
    Start-Sleep -s 6
    Remove-Item -path $Destination
}

If ($cheese -eq "ExtraCheese") {
    Start-Process Video.UI.exe -file $Destination2
    Start-Sleep -s 8
    Remove-Item -path $Destination2
}

taskkill /F /IM video.UI.exe
