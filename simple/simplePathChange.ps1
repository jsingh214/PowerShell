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
$school = Read-Host 'Which school needs changes for home directories?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

$gradYear = Read-Host 'Which graduation year group of students would you like to change home directories for? Please
type in the OU graduation year'

#Uses and if else statement to determine which school after input...
If ($school -eq 'PPS') {
$searchOU = "OU=$gradYear,OU=Students,OU=PPS,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'UMS') {
$searchOU = "OU=$gradYear,OU=Students,OU=UMS,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'MBS') {
$searchOU = "OU=$gradYear,OU=Students,OU=MBS,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'CMS') {
$searchOU = "OU=$gradYear,OU=Students,OU=CMS,OU=District,DC=csd,DC=local"
}
ElseIf ($school -eq 'CHS') {
$searchOU = "OU=$gradYear,OU=Students,OU=CHS,OU=District,DC=csd,DC=local"
}
Else {
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}

#Sets a variable to users which is all users found in the specified OU and their home directories...
$users = Get-ADuser -filter * -SearchBase $searchOU -properties HomeDirectory

$newSchool = Read-Host 'What is name of the new school the home directories are going to?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

#Using a foreach loop it will look in each students home directory and delete everything except the home directory folder...
#It knows what to delete because there is a check to detemine that the home folder matches the accounts name...
foreach ($user in $users) {

If ($newSchool -eq 'PPS') {
$sam = (Get-Aduser -identity $user).samaccountname |           
Set-ADUser -HomeDirectory "\\pps2\ppsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}

ElseIf ($newSchool -eq 'UMS') {
$sam = (Get-Aduser -identity $user).samaccountname |  
Set-ADUser -HomeDirectory "\\ums2\umsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}

ElseIf ($newSchool -eq 'MBS') {
$sam = (Get-Aduser -identity $user).samaccountname | 
Set-ADUser -HomeDirectory "\\mbs1\mbsusers$\Students\$gradYear\$sam" -HomeDrive "I:" 
Write-Host Changing home directory for $sam... 
}

ElseIf ($newSchool -eq 'CMS') {
$sam = (Get-Aduser -identity $user).samaccountname | 
Set-ADUser -HomeDirectory "\\cms1\cmsusers$\Students\$gradYear\$sam" -HomeDrive "I:" 
Write-Host Changing home directory for $sam... 
}

ElseIf ($newSchool -eq 'CHS') {
$sam = (Get-Aduser -identity $user).samaccountname | 
Set-ADUser -HomeDirectory "\\chs1\chsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}
}


#Confirmation message...
Write-Host 'Home directory changes successful...'
