#Disable Sleep mode for network adaptors
$adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
    foreach ($adapter in $adapters)
        {
        $adapter.AllowComputerToTurnOffDevice = 'Disabled'
        $adapter | Set-NetAdapterPowerManagement
        }

#Set closing lid options
powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

#Modify Sleep Settings
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 120 
powercfg /change monitor-timeout-ac 60 
powercfg /change monitor-timeout-dc 60
powercfg /change hibernate-timeout-ac 0 
powercfg /change hibernate-timeout-dc 480