#Imports AD module...
Import-Module ActiveDirectory

#Takes in a user inputted variable to determine which school students to clean up home directories for...
$school = Read-Host 'Which school needs student home directories cleaned up?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

#Uses and if else statement to determine which school after input...
If ($school -eq 'PPS')
{
$searchOU = 'Ou=Students,OU=PPS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'UMS')
{
$searchOU = 'Ou=Students,OU=UMS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'MBS')
{
$searchOU = 'Ou=Students,OU=MBS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'CMS')
{
$searchOU = 'Ou=Students,OU=CMS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'CHS')
{
$searchOU = 'Ou=Students,OU=CHS,OU=District,DC=csd,DC=local'
}
Else
{
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}

#Sets a variable to users which is all users found in the specified OU and their home directories...
$users = Get-ADuser -filter * -SearchBase $searchOU -properties HomeDirectory

#Using a foreach loop it will look in each students home directory and delete everything except the home directory folder...
foreach ($user in $users) { 
$delete = Get-ChildItem $user.HomeDirectory -Force | Remove-Item -Force -Recurse
echo $delete
}
Write-Host 'Processing, please wait for confirmation...'

Out-File C:\logs\cleanup.txt

Write-Host 'Student file cleanup successful, see resutls in C:\logs\cleanup.txt...'