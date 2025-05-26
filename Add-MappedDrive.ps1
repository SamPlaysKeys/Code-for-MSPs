function Add-MappedDrive
{
  param (
    $DriveLetter
    [string[]]$DrivePath
  )

  if ($DriveLetter.length -gt 1) {
    write-host "Drive letter cannot be longer than one character";
    return
  }

  $driveparameters = @{
    Name = $DriveLetter
    PSProvider = "FileSystem"
    Root = $DrivePath
    Scope = "Global"
  }

  $InstalledDrive = Get-PSDrive -Name $DriveLetter
  
  try {$InstalledDrive}
  catch{
    New-PSDrive @driveparameters -Persist
  }
  finally {
    $InstalledDrive
  }
}
