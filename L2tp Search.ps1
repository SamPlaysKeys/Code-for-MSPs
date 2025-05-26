#Import-Module $env:SyncroModule
Set-ExecutionPolicy Unrestricted -Force
$L2tpStatus = (Get-VpnConnection | Where TunnelType -eq "L2tp" | Format-Table Name,ServerAddress)
$L2tpStatus = $L2tpStatus | Out-String
$L2tpOutput = "L2tp VPN On"
$L2tpNope = "No L2tp VPN Configured"
$L2tpFix = "Resolved the L2tp issue with new KB"
function Check-Admin {
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

If (Get-VpnConnection | Where TunnelType -eq "L2tp") {
    New-Item C:\temp\VPN.txt
    Set-Content C:\temp\VPN.txt $L2tpStatus
    #Set-Asset-Field -Name "L2tp Status" -Value $L2tpOutput
    #Upload-File -filepath C:\temp\VPN.txt
    $L2tpOutput
    if (wmic qfe list full /format:table | findstr /i "5009543") {
    Write-Host "KB5009543 Detected!";
        if ((Check-Admin) -eq $true)  {
            Write-Host "Downloading and Updating KB"
            Invoke-WebRequest -Uri "http://download.windowsupdate.com/d/msdownload/update/software/updt/2022/01/windows10.0-kb5010793-x64_3bae2e811e2712bd1678a1b8d448b71a8e8c6292.msu" -OutFile "c:\temp\windows10.0-kb5010793-x64_3bae2e811e2712bd1678a1b8d448b71a8e8c6292.msu"
            Start-Sleep 2
            WUSA c:\temp\windows10.0-kb5010793-x64_3bae2e811e2712bd1678a1b8d448b71a8e8c6292.msu /quiet /norestart
            wmic qfe list full /format:table | findstr /i "5010793"
            #Set-Asset-Field -Name "L2tp Status" -Value $L2tpFix
        }
        else {
            Write-Host "Not able to run as admin."
        }
    }
}

Else {
#Set-Asset-Field -Name "L2tp Status" -Value $L2tpNope
$L2tpNope
}
