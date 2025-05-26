$LogFile = "C:\Logs\DellUninstall.log"

function Write-Log { 
    param (
        [string]$Message
    )
    $TimeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $LogMessage = "$TimeStamp - $Message"
    Add-Content -Path $LogFile -Value $LogMessage
}

$LogDirectory = Split-Path -Path $LogFile # Checking whether the log exists
if (!(Test-Path -Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory | Out-Null
}

$DCU = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Dell Command*" }
if ($DCU) {
    Write-Log "Dell Command Update found. Attempting uninstallation."
    $DCU.Uninstall() | Out-Null
    Write-Log "Dell Command Update uninstalled successfully."
} else {
    Write-Log "Dell Command Update not found."
}

$Optimizer = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Dell Optimizer*" }
if ($Optimizer) {
    Write-Log "Dell Optimizer found. Attempting uninstallation."
    $Optimizer.Uninstall() | Out-Null
    Write-Log "Dell Optimizer uninstalled successfully."
} else {
    Write-Log "Dell Optimizer not found."
}

write-host "Run and completed, see log for details."