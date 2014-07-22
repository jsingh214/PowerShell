Import-Module ActiveDirectory
$searchOU = "OU=District,OU=PPS,DC=csd,DC=local"
Get-ADuser -filter * -searchbase $searchOU -properties DistinguishedName | Select -expandProperty DistinguishedName |
ForEach-Object { 
$user = [adsi]"LDAP://$_"
$CurrentHomeFolder = -join $user.homedirectory
If (Test-Path $CurrentHomeFolder) { 
Get-ChildItem $CurrentHomeFolder -Force -Recurse | Remove-Item -Force -Recurse
}
}