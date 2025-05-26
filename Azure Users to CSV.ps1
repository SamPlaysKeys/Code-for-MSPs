#Azure Users to CSV 
$objs = Get-AzureADUser
echo "DisplayName,UserPrincipalName,SAMAccountName,First,Last" | Out-File -Append -FilePath "~\EntraUserExport.csv"
$CSVFile = "~\EntraUserExport.csv"
foreach($obj in $objs){
    $User = Get-MsolUser -UserPrincipalName $obj.UserPrincipalName
    "$($User.DisplayName)," | Add-Content $CSVFile -NoNewline
    "$($User.UserPrincipalName)," | Add-Content $CSVFile -NoNewline
    "$($User.FirstName).$($User.LastName)," | Add-Content $CSVFile -NoNewline
    "$($User.FirstName)," | Add-Content $CSVFile -NoNewline
    "$($User.LastName)" | Add-Content $CSVFile
}


