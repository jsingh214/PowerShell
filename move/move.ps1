#Start of script...
Import-Module ActiveDirectory

#Questions begin to determine variable data

#Variable that represents the current graduated school
$oldSchool = Read-Host 'Which school needs a group moved? Please type the school initials.
Please  Type in the initials of school.'

#This switch statement automatically sets $oldSchool to the proper variable for the next school after it is set by user
#A new variable is created to represent the next school and is deteremined with if else
If ($oldSchool -eq 'PPS' -or 'UMS')
{
  $newSchool = 'MBS'
}
ElseIf ($oldSchool -eq 'MBS')
{
  $newSchool = 'CMS'
}
ElseIf ($oldSchool -eq 'CMS')
{
  $newSchool = 'CHS'
}

#
$gradyear = Read-Host 'Which graduation year group of students would you like to move? Please
type in the OU graduation year. .'

$exclude = @()
do {
 $input = (Read-Host "Are there any students that should not be moved?(Ex. Not graduating)
Please type in there username.")
 if ($input -ne '') {$exclude += $input}
}
until ($input -eq '')
$exclude	


Move-ADObject "OU=District,OU=$oldSchool,OU=$gradyear,DC=csd,DC=local -exclude $exclude" -TargetPath "OU=District,OU=$newSchool,OU=$gradyear,DC=csd,DC=local"

Set-ADGroup "CN=gj test2,OU=TEST_GRAHAM,OU=TEST OU,DC=X,DC=XX,DC=XXX" -Remove @{exclude}