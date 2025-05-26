$portaddress = Read-Host "Enter the Printer IP Address: "
$printername = Read-Host "Enter the Printer Name: "
$portname = $printername+"_port"
Add-PrinterPort -name $portname -printerhostaddress $portaddress
Add-Printer -name $printername -DriverName "Microsoft IPP Class Driver" -port $portname
