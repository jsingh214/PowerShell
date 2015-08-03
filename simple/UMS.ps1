Import-Module ActiveDirectory

$searchOU = "OU=Teachers,OU=PPS,OU=District,DC=csd,DC=local"
$users = Get-ADuser -filter * -SearchBase $searchOU

foreach ($user in $users) {
$sam = (Get-Aduser -identity $user).samaccountname  
       
Set-ADUser $sam -HomeDirectory "\\csd160\PPSusers$\Teachers\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}