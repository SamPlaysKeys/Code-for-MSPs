#Install and Uninstall Extensions
Function Get-NumberedRegistryValue {
    param($Path)
    Get-Item -Path $Path -ErrorAction SilentlyContinue | select -ExpandProperty Property | %{ Get-ItemProperty -Path $Path -Name $_ | select -ExpandProperty $_ }
}
Function Register-NumberedRegistryValue {
    param($Path, $Value)
    if((Test-Path $Path) -eq $false)
    {
        New-Item -Path $Path -Force | Out-Null
    }
    $ValueExists = Test-NumberedRegistryValue -Path $Path -Value $Value
    if(!$ValueExists)
    {
        Write-Host "$Path $value doesn't exist, creating"
        $Index = Get-Item -Path $Path | select -ExpandProperty Property | %{ [int]$_ } | sort | select -last 1
        if($null -eq $Index)
        {
            $Index = 0
        }
        else
        {
            $index++
        }
        New-ItemProperty -Path $Path -Name $Index -Value $Value -Force | Out-Null
    }
    else
    {
        Write-Host "$Path $value already exists"
    }    
}
Function Register-Extension {
    Param(
        [Parameter(Mandatory)]
        [String]$ExtensionID,
        [String]$EdgeExtensionID
    )

    #Loop through each Extension in ExtensionID since it is an array.
    #Create a Key for every member of the ExtensionID Array
    Register-NumberedRegistryValue -Path $ChromeRegKey -Value $ExtensionID
    if($EdgeExtensionID)
    {
        Write-Host "Upserting Edge ExtensionID: $EdgeExtensionID"
        Register-NumberedRegistryValue -Path $EdgeRegKey -Value $EdgeExtensionID
    }
    else
    {
        Write-Host "Upserting Chrome ExtensionID into Edge: $EdgeChromeExtensionID"
        Register-NumberedRegistryValue -Path $EdgeRegKey -Value $EdgeChromeExtensionID
    }
}
function Remove-Extension {
    param (
        [Parameter(Mandatory)]
        [String]$ExID        
    )
    $Keys = Get-Item -Path $ChromeRegKey -ErrorAction SilentlyContinue | select -ExpandProperty Property
    Foreach($Value in $Keys){
        if((Get-ItemProperty -Path $ChromeRegKey -Name $Value | select -ExpandProperty $Value) -eq $ExID){
            Write-Output "Removing Key $Value : $(Get-ItemProperty -Path $ChromeRegKey -Name $Value | select -ExpandProperty $Value)"
            Remove-ItemProperty -Path $ChromeRegKey -Name $Value
        }
    }
    $Keys = Get-Item -Path $EdgeRegKey -ErrorAction SilentlyContinue | select -ExpandProperty Property
    Foreach($Value in $Keys){
        if((Get-ItemProperty -Path $EdgeRegKey -Name $Value | select -ExpandProperty $Value) -eq $ExID){
            Write-Output "Removing Key $Value : $(Get-ItemProperty -Path $EdgeRegKey -Name $Value | select -ExpandProperty $Value)"
            Remove-ItemProperty -Path $EdgeRegKey -Name $Value
        }
    }
}
Function Test-NumberedRegistryValue {
    param($Path, $Value)
    $ExistingValues = Get-NumberedRegistryValue -Path $Path
    return $ExistingValues -contains $Value
}
Function Test-Extension {
    Param(
        [Parameter(Mandatory)]
        [String]$ExtensionID,
        [String]$EdgeExtensionID
    )
    $ExistsInChrome = Test-NumberedRegistryValue -Path $ChromeRegKey -Value $ExtensionId
    if($EdgeExtensionID)
    {
        Write-Host "EdgeExtensionID specified"
        $ExistsInEdge = Test-NumberedRegistryValue -Path $EdgeRegKey -Value $EdgeExtensionID
    }
    else
    {
        Write-Host "Looking for Chrome ExtensionID $EdgeChromeExtensionID in Edge"
        $ExistsInEdge = Test-NumberedRegistryValue -Path $EdgeRegKey -Value $EdgeChromeExtensionID
    }
    Write-Host "ExistsInChrome: $ExistsInChrome ExistsInEdge: $ExistsInEdge"
    return $ExistsInChrome -and $ExistsInEdge
}

# Passed Parameters
#[string]ExensionId, [boolean]Install

# Extension Registry locations
$ChromeRegKey = 'HKLM:\Software\Policies\Google\Chrome\ExtensionInstallForcelist'        
$EdgeRegKey = 'HKLM:\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist'

switch ($method) {
    "get" {
        Get-NumberedRegistryValue -Path $ChromeRegKey
        Get-NumberedRegistryValue -Path $EdgeRegKey
        return
    }
    "set" {
        Write-Host "Setting $ExtensionId"
        if (!$Install) {
            Remove-Extension -ExID $ExtensionId 
        }
        if($Install){
            Register-Extension -ExtensionID $ExtensionId -EdgeExtensionID $EdgeExtensionID
        }       
        return
    }
    "test" {
        if (!$Install) {
            return "No Extensions Installed"
        }
        if($Install){
            return (Test-Extension -ExtensionID $ExtensionId -EdgeExtensionID $EdgeExtensionID)
        }
    }
}