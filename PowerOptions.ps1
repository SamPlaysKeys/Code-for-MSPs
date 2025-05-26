
#Power Option Guids
$PowerGUID = '4f971e89-eebd-4455-a8de-9e59040e7347'
$PowerButtonGUID = '7648efa3-dd9c-4e3e-b566-50f929386280'
$LidClosedGUID = '5ca83367-6e45-459f-a27b-476b1d01c936'
$SleepButtonGUID = '96996bc0-ad50-47ec-923b-6f41874dd9eb'

#Make sure Attributes are readable
powercfg -attributes $PowerGUID $PowerButtonGUID -ATTRIB_HIDE
powercfg -attributes $PowerGUID $LidClosedGUID -ATTRIB_HIDE
powercfg -attributes $PowerGUID $SleepButtonGUID -ATTRIB_HIDE

switch ($method) {
    "test" {
        $ActiveScheme = $(powercfg -getactivescheme).split()[3]
	    $PowerButtonTestAC = powercfg /Q $ActiveScheme $PowerGUID $PowerButtonGUID | Select-String -pattern "AC Power Setting Index:*" | ForEach-Object {$_ -match '0x00000000'}
        $PowerButtonTestDC = powercfg /Q $ActiveScheme $PowerGUID $PowerButtonGUID | Select-String -pattern "DC Power Setting Index:*" | ForEach-Object {$_ -match '0x00000000'}
        $SleepButtonTestAC = powercfg /Q $ActiveScheme $PowerGUID $SleepButtonGUID | Select-String -pattern "AC Power Setting Index:*" | ForEach-Object {$_ -match '0x00000000'}
        $SleepButtonTestDC = powercfg /Q $ActiveScheme $PowerGUID $SleepButtonGUID | Select-String -pattern "DC Power Setting Index:*" | ForEach-Object {$_ -match '0x00000000'}
        $LidClosedTestAC = powercfg /Q $ActiveScheme $PowerGUID $LidClosedGUID | Select-String -pattern "AC Power Setting Index:*" | ForEach-Object {$_ -match '0x00000000'}
        $LidClosedTestDC = powercfg /Q $ActiveScheme $PowerGUID $LidClosedGUID | Select-String -pattern "DC Power Setting Index:*" | ForEach-Object {$_ -match '0x00000000'}

        If(!$PowerButtonTestAC){
            Write-Warning "Power Button Test Failed"
            return $false
        }
        If(!$PowerButtonTestDC){
            Write-Warning "Power Button Test Failed"
            return $false
        }
        If(!$SleepButtonTestAC){
            Write-Warning "Sleep Button Test Failed"
            return $false
        }
        If(!$SleepButtonTestDC){
            Write-Warning "Sleep Button Test Failed"
            return $false
        }
        If(!$LidClosedTestAC){
            Write-Warning "Lid Close Test Failed"
            return $false
        }
        If(!$LidClosedTestDC){
            Write-Warning "Lid Close Test Failed"
            return $false
        }
        return $true
	}
    "get"{
        
    }
	"set" {

        
        #Disable Sleep mode for network adaptors
        Write-Host "Disabling Sleep mode on Network Adaptors"
        $adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
        foreach ($adapter in $adapters){
            $adapter.AllowComputerToTurnOffDevice = 'Disabled'
            $adapter | Set-NetAdapterPowerManagement
        }

        # Get Current Active Plan
        $OriginalPlan = $(powercfg -getactivescheme).split()[3]
        # Duplicate Current Active Plan
        $Duplicate = powercfg -duplicatescheme $OriginalPlan
        # Change Name of Duplicated Plan
        $CurrentPlan = powercfg -changename ($Duplicate).split()[3] "Recommended"
        # Set New Plan as Active Plan
        $SetActiveNewPlan = powercfg -setactive ($Duplicate).split()[3]
        # Get the New Plan
        $NewPlan = $(powercfg -getactivescheme).split()[3]


        Write-Host 'Setting power button to "do nothing"'
        #POWER BUTTON
        # PowerButton - On Battery - 1 = Sleep
        powercfg /setdcvalueindex $NewPlan $PowerGUID $PowerButtonGUID 0
        # PowerButton - While plugged in - 3 = Shutdown
        powercfg /setacvalueindex $NewPlan $PowerGUID $PowerButtonGUID 0

        Write-Host 'Setting sleep button to "do nothing"'
        #SLEEP BUTTON
        # SleepButton - On Battery - 0 = Do Nothing
        powercfg /setdcvalueindex $NewPlan $PowerGUID $SleepButtonGuid 0
        # SleepButton - While plugged in - 0 = Do Nothing
        powercfg /setacvalueindex $NewPlan $PowerGUID $SleepButtonGuid 0

        Write-Host 'Setting when closing lid to "do nothing"'
        #LID CLOSED
        #Lid Closed - On Battery - 0 = Do Nothing
        powercfg /setdcvalueindex $NewPlan $PowerGUID $LidClosedGUID 0
        #Lid Closed - While plugged in - 0 = Do Nothing
        powercfg /setacvalueindex $NewPlan $PowerGUID $LidClosedGUID 0

        Write-Host 'Setting Sleep timeout to "2 hours when on battery"'
        #Sleep Settings
        powercfg /change standby-timeout-ac 0
        powercfg /change standby-timeout-dc 120 

        Write-Host 'Setting monitor timeout to "1 hour"'
        #Display Settings
        powercfg /change monitor-timeout-ac 60 
        powercfg /change monitor-timeout-dc 60

        Write-Host 'Setting hibernate timeout to "8 hours when on battery"'
        #Hibernate Settings
        powercfg /change hibernate-timeout-ac 0 
        powercfg /change hibernate-timeout-dc 480

        #APPLY CHANGES
        powercfg /s $NewPlan
	}    
}

