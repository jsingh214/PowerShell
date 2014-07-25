﻿#==============================================================================
# File:    cleanupHomeDirectoriestudents.ps1
# Author:  Jason Singh
# Date:    7/24/2014
# Purpose: Cleans up student home directories from a specified school.
#==============================================================================

#Imports AD module...
Import-Module ActiveDirectory

#Takes in a user inputted variable to determine which school students to clean up home directories for...
$school = Read-Host 'Which school needs student home directories cleaned up?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

#Uses and if else statement to determine which school after input...
If ($school -eq 'PPS')
{
$searchOU = 'OU=Students,OU=PPS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'UMS')
{
$searchOU = 'OU=Students,OU=UMS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'MBS')
{
$searchOU = 'OU=Students,OU=MBS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'CMS')
{
$searchOU = 'OU=Students,OU=CMS,OU=District,DC=csd,DC=local'
}
ElseIf ($school -eq 'CHS')
{
$searchOU = 'OU=Students,OU=CHS,OU=District,DC=csd,DC=local'
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
$userHomeFolder = -join $user.homedirectory
If (Test-Path $userHomeFolder) { 
Get-ChildItem $user.HomeDirectory | Remove-Item -Recurse
}
}

Write-Host 'Student file cleanup successful.'