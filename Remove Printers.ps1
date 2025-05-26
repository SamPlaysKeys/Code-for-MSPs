# Script to remove printers by IP address
# This script will only work for printers added by the windows printer tool
# Created by Sam Fleming, 4/13/23

$PrinterIP = "[IP ADDRESS]" ###put IP Address on this line.
$PrintLIst = Get-Printer | Select Name, Portname
ForEach ($Printer in $PrintLIst) {
    if ($Printer.Portname -in $PrinterIP){ 
        Write-Host "Removing " $Printer.Name
        Remove-Printer -Name $Printer.Name #append -whatif to the end of this line to test the script
       }
}