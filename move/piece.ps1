#==============================================================================
# File:    cleanupHomeDirectoriestudents.ps1
# Author:  Jason Singh
# Date:    7/24/2014
# Purpose: Cleans up student home directories from a specified school.
#==============================================================================

#This is needed to supress errors, in this case to supress null path errors.
#$ErrorActionPreference = "SilentlyContinue"

#Imports AD module...
Import-Module ActiveDirectory

#Takes in a user inputted variable to determine which school students to clean up home directories for...
$school = Read-Host 'Which school needs a student home directory clean up?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

$gradYear = Read-Host 'Which graduation year group of students would you like to change home directories for?? Please
type in the OU graduation year'

#Uses and if else statement to determine which school after input...
If ($school -eq 'PPS')
{
$searchOU = "OU=Test2,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'UMS')
{
$searchOU = "OU=Test2,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'MBS')
{
$searchOU = "OU=Test2,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'CMS')
{
$searchOU = "OU=Test2,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'CHS')
{
$searchOU = "OU=Test2,OU=District,DC=csd,DC=local"
}
Else
{
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}

#Sets a variable to users which is all users found in the specified OU and their home directories...
$users = Get-ADuser -filter * -SearchBase $searchOU -properties HomeDirectory

#Using a foreach loop it will look in each students home directory and delete everything except the home directory folder...
#It knows what to delete because there is a check to detemine that the home folder matches the accounts name...
foreach ($user in $users) {
If ($school -eq 'PPS')
{
$sam = (Get-Aduser -identity $user).samaccountname |           
Set-ADUser -HomeDirectory "\\pps2\ppsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
}
ElseIf ($school -eq 'UMS')
{ 
set-aduser $sam \\ums2\umsusers$\students\$gradYear\%username% -homedrive I:
}
ElseIf ($school -eq 'MBS')
{
set-aduser $sam \\mbs1\mbsusers$\Students\$gradYear\$user -homedrive I:
}
ElseIf ($school -eq 'CMS')
{
set-aduser $sam \\cms1\cmsusers$\students\$gradYear\$user -homedrive I:
}
ElseIf ($school -eq 'CHS')
{
set-aduser $sam \\chs1\chsusers$\students\$gradYear\$user -homedrive I:
}
}


#Confirmation message...
Write-Host 'Student file cleanup successful.'

