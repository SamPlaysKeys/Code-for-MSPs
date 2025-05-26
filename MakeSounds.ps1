function ManyBeeps {
    #Change the TotalBeeps variable to change the number of beeps
    $TotalBeeps = 5
    1..$TotalBeeps | % {Start-Sleep -s 0.5; [console]::beep(500,400);}
    #Note: The first beep may not fully sound, as the console initializes.  
}

function SysMute {
    $sysvol = new-object -com wscript.shell
    $sysvol.SendKeys([char]173)
}

function SysVolUp {
    $sysvol = new-object -com wscript.shell
    $sysvol.SendKeys([char]174)
}

function SysVolDown {
    $sysvol = new-object -com wscript.shell
    $sysvol.SendKeys([char]175)
}