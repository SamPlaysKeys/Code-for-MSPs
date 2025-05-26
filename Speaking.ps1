
Function Set-Speaker($Volume){$wshShell = new-object -com wscript.shell;1..50 | % {$wshShell.SendKeys([char]174)};1..$Volume | % {$wshShell.SendKeys([char]175)}}
Function Set-ManualVolume {
        Write-Host "Voice Dialogue Program`n    Version 1.3`n    Press `"Ctrl+C`" to Exit`n`n`n`n"
        clear-host
        $Vol = Read-Host "Please Set Volume Percentage"
        $Vol = $Vol/2
        Set-Speaker -Volume $Vol
        clear-host
        Start-Sleep -s 1
}

Function ActiveSpeak {
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
        Write-Host "Voice Dialogue Program`n    Version 1.3`n    Press `"Ctrl+C`" to Exit`n`n`n`n"
        $Text = Read-Host "`nEnter Text"
        Clear-Host
        Write-Host "Voice Dialogue Program`n    Version 1.3`n    Press `"Ctrl+C`" to Exit`n`n`n`n"
        Write-Host "Speaking..."
        $speak.Speak($Text)
        Clear-Host
}

Function SayPCName {
        ($PCName = $env:computername-split "([a-z0-9]{1})"  | ?{ $_.length -ne 0 }) -join " "
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $FullName = "The full PC Name is - - - $PCName"
        $speak.Speak($FullName)
}


$AutoName = $true

If ($AutoName) {
        Set-Speaker -Volume 25;
        SayPCName;
        Clear-Host
}
else {
        Set-ManualVolume
        while ($true) {
                Active-Speak
                Start-Sleep -s 1
                Clear-Host
        }
}