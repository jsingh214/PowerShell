#==============================================================================
# File:    cleanupHomeDirectoriestudents.ps1
# Author:  Jason Singh
# Date:    7/24/2014
# Purpose: Cleans up student home directories from a specified school.
#==============================================================================

#This is needed to supress errors, in this case to supress null path errors.
$ErrorActionPreference = "SilentlyContinue"

#Imports AD module...
Import-Module ActiveDirectory

#Takes in a user inputted variable to determine which school students to clean up home directories for...
$school = Read-Host 'Which school needs a student home directory clean up?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

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
#It knows what to delete because there is a check to detemine that the home folder matches the accounts name...
If ($school -eq 'PPS' -or $school -eq 'UMS' -or $school -eq 'MBS' -or $school -eq 'CMS')
{
foreach ($user in $users) 
{ 
$sam = (Get-Aduser -identity $user).samaccountname
$homeDir = (Get-Aduser -Identity $user -Properties HomeDirectory).HomeDirectory 
$dir = Split-Path $homeDir -Leaf
If($sam -eq $dir)
{
Write-Host Cleaning $homeDir..
Get-ChildItem $user.HomeDirectory | Remove-Item -Force -Recurse
}
}
}
#Confirmation message...
Write-Host 'Student file cleanup successful.'


#TODO: add condition that deletes the senior home folders, you can do this by adding an if else within the option of selecting CHS at the top
If ($school -eq 'CHS')
{
foreach ($user in $users) 
{ 
$sam = (Get-Aduser -identity $user).samaccountname
$homeDir = (Get-Aduser -Identity $user -Properties HomeDirectory).HomeDirectory 
$dir = Split-Path $homeDir -Leaf
If($sam -eq $dir)
{
Write-Host Deleting $homeDir..
Remove-Item $user.HomeDirectory -Force -Recurse
}
}
}