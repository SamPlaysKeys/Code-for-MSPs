param([Int32]$Min=20,[Int32]$Max=30)
function GeneratePassword{
    param (
        [Parameter()]
        [int]$PasswordMin,
        [int]$PasswordMax
    )
    #Prep parts
    $Symbols = "!","@","#","$","%","^","&","*","(",")"
    $UsableWords=Import-Csv -path 'words.csv'

    $pass=$UsableWords[(Get-Random -Maximum $UsableWords.Count -Minimum 0)].word+"-"+$UsableWords[(Get-Random -Maximum $UsableWords.Count -Minimum 0)].word
    $words=$pass.split("-")
    $newpass=""
    foreach($word in $words){$newpass=$newpass+$word.Substring(0,1).ToUpper() + $word.Substring(1) + $Symbols[(Get-Random -Maximum $Symbols.Count -Minimum 0)]}
    $newpass=$newpass+$(Get-Random -Maximum 10) + $Symbols[(Get-Random -Maximum $Symbols.Count -Minimum 0)]
    $CharacterCount = $($newpass | Measure-Object -Character).Characters
    if($CharacterCount -lt $PasswordMin -or $CharacterCount -gt $PasswordMax){
        GeneratePassword $PasswordMin $PasswordMax
    }else{
    Write-Host "Length: $CharacterCount" -ForegroundColor Green
    Write-Host $newpass -ForegroundColor Green
    }
}
GeneratePassword $Min $Max