#computer rename process
$cname = wmic bios get serialnumber
$cname = ($cname -join ".")
$cname = $cname.ToString()
$cname = $cname.trim(" ",".")
$cname = $cname.Substring($cname.length - 7, 7)
clear
Write-Host "Serial Number: "$cname " "
Write-Host "Current Name: " $env:computername "`n "

pause