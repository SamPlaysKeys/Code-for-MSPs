$vowels = @('a', 'o', 'u')
$consonants = @(
'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z')
$FirstChar = Get-Random -InputObject $consonants
$SecondChar = Get-Random -InputObject $vowels
$ThirdChar = Get-Random -InputObject $consonants
$FirstChar = $FirstChar.ToUpper()
$Number = Get-Random -Minimum 10000 -Maximum 99999
$Password = $FirstChar + $SecondChar + $ThirdChar + $Number
Set-Clipboard -Value $Password