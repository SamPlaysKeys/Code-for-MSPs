Add-Type -AssemblyName Microsoft.VisualBasic

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Title Here'
$msg   = 'Message Here'

$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

$text