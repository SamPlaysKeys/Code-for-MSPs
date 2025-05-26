Add-Type -AssemblyName Microsoft.VisualBasic

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Title Here'
$msg   = 'Message Here'
$buttons = 0

$text = [Microsoft.VisualBasic.Interaction]::MsgBox($msg, $buttons, $title)

