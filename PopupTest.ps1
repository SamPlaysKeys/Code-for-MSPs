Add-Type -Assembly System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

$CurrentDNS = Get-DNSClientServerAddress | Select-Object InterFaceAlias, ServerAddresses | Out-String

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'DNS Control:'
$msg   = 'DNS Settings:' + $CurrentDNS + 'Enter Desired DNS below:'

$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

$text