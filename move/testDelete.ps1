Import-Module ActiveDirectory

$searchOU = 'OU=Test2,OU=District,DC=csd,DC=local'
$users = Get-ADuser -filter * -SearchBase $searchOU -properties HomeDirectory

#Using a foreach loop it will look in each students home directory and delete everything except the home directory folder...
#It knows what to delete because there is a check to detemine that the home folder matches the accounts name...
foreach ($user in $users) 
{ 
$sam = (Get-Aduser -identity $user).samaccountname
$homeDir = (Get-Aduser -Identity $user -Properties HomeDirectory).HomeDirectory 
$dir = Split-Path $homeDir -Leaf
If($sam -eq $dir)
{
Write-Host Deleting $homeDir...
Remove-Item $user.HomeDirectory -Force -Recurse
}
}

#Confirmation message...
Write-Host 'Student home directory cleanup successful.'