#==============================================================================
# File:    simpleMembershipChange.ps1
# Author:  Jason Singh
# Date:    8/6/2014
# Purpose: Changes group membersips for a specfied graduation year OU.
#==============================================================================

#This is needed to supress errors, in this case to supress null path errors.
$ErrorActionPreference = "SilentlyContinue"

#Imports AD module...
Import-Module ActiveDirectory

#Takes in a user inputted variable to determine which school students to change group memberships for...
$school = Read-Host 'Which school needs changes for home directories?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

#This is a check to see if school OU exists...
if([ADSI]::Exists("LDAP://OU=$school,OU=District,DC=csd,DC=local")) {    

$gradYear = Read-Host "`n"'Which graduation year group of students would you like to change home directories for? Please
type in the OU graduation year'

#This is a check to see if graduation year OU exists...
if([ADSI]::Exists("LDAP://OU=$gradYear,OU=Students,OU=$school,OU=District,DC=csd,DC=local")) {    

#Uses and if else statement to setup searchOU for graduation year student membership changes...
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

#Sets a variables to users and groups which is all users found in the specified OU and groups for membership changes...
$users = Get-ADuser -filter * -SearchBase $searchOU
$groups = Get-ADGroup -filter * -SearchBase "OU=GROUPS,OU=District,DC=csd,DC=local"


$newSchool = Read-Host "`n"'What is name of the new school the home directories are going to?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

#This is a check to see if new school OU exists...
if([ADSI]::Exists("LDAP://OU=$newSchool,OU=District,DC=csd,DC=local")) {    

#This is a check prompt to make sure that you have the following fields right for the change in group memberships....

Write-Host "`n"'Double check the following fields...'
Write-Host "Current School: $school"
Write-Host "Graduation Year Group of Students: $gradYear"
Write-Host "New School: $newSchool"

$confirm = Read-Host "`n"'Are the following fields correct? If so please type yes'


if($confirm = 'yes'){
#Goes through a for each loop to process new group memberships for each user...
foreach ($user in $users) {
$sam = (Get-Aduser -identity $user).samaccountname  

#The process for each if statement is: Assign appropriate groups need to variables->Adds new primary group->Changes new group to primary
#->Deletes all groups but it won't delete the one added because it is primary->Adds the web group after so it won't get deleted
If ($newSchool -eq 'PPS') {    
    $ADgroup = 'PPS Students'
    $ADgroupWeb = 'PPS Students Web'
    Add-ADGroupMember -Identity $ADgroup  -Members $user -Confirm:$false
    $newPrimaryGroup = Get-ADGroup $ADgroup
    $groupSid = $newPrimaryGroup.sid
    $GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)
    Get-ADUser $user | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
    foreach ($group in $groups){Remove-ADGroupMember $group -Members $user -Confirm:$false}
    Add-ADGroupMember -Identity $ADgroupWeb -Members $user -Confirm:$false
    Write-Host Changing group memberships for $sam...
}

ElseIf ($newSchool -eq 'UMS') {
    $ADgroup = 'UMS Students'
    $ADgroupWeb = 'UMS Students Web'
    Add-ADGroupMember -Identity $ADgroup  -Members $user -Confirm:$false
    $newPrimaryGroup = Get-ADGroup $ADgroup
    $groupSid = $newPrimaryGroup.sid
    $GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)
    Get-ADUser $user | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
    foreach ($group in $groups){Remove-ADGroupMember $group -Members $user -Confirm:$false}
    Add-ADGroupMember -Identity $ADgroupWeb -Members $user -Confirm:$false
    Write-Host Changing group memberships for $sam...
}

ElseIf ($newSchool -eq 'MBS') { 
    $ADgroup = 'MBS Students'
    $ADgroupWeb = 'MBS Students Web'
    Add-ADGroupMember -Identity $ADgroup  -Members $user -Confirm:$false
    $newPrimaryGroup = Get-ADGroup $ADgroup
    $groupSid = $newPrimaryGroup.sid
    $GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)
    Get-ADUser $user | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
    foreach ($group in $groups){Remove-ADGroupMember $group -Members $user -Confirm:$false}
    Add-ADGroupMember -Identity $ADgroupWeb -Members $user -Confirm:$false
    Write-Host Changing group memberships for $sam...
}

ElseIf ($newSchool -eq 'CMS') { 
    $ADgroup = 'CMS Students'
    $ADgroupWeb = 'CMS Students Web'
    Add-ADGroupMember -Identity $ADgroup  -Members $user -Confirm:$false
    $newPrimaryGroup = Get-ADGroup $ADgroup
    $groupSid = $newPrimaryGroup.sid
    $GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)
    Get-ADUser $user | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
    foreach ($group in $groups){Remove-ADGroupMember $group -Members $user -Confirm:$false}
    Add-ADGroupMember -Identity $ADgroupWeb -Members $user -Confirm:$false
    Write-Host Changing group memberships for $sam...
}

ElseIf ($newSchool -eq 'CHS') {
    $ADgroup = 'CHS Students'
    $ADgroupWeb = 'CHS Students Web' 
    Add-ADGroupMember -Identity $ADgroup  -Members $user -Confirm:$false
    $newPrimaryGroup = Get-ADGroup $ADgroup
    $groupSid = $newPrimaryGroup.sid
    $GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)
    Get-ADUser $user | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
    foreach ($group in $groups){Remove-ADGroupMember $group -Members $user -Confirm:$false}
    Add-ADGroupMember -Identity $ADgroupWeb -Members $user -Confirm:$false
    Write-Host Changing group memberships for $sam...
}
}
}

#Confirmation message...
Write-Host "`n"'Group membership changes successful...'

}

#Else messages for checks above to see if objects exist...
else {
Write-Host "`n"'The school you entered does not exist as an OU. Please recheck the name and rerun the script.'
}


}

else {
Write-Host "`n"'The graduation year for students you entered does not exist as an OU. Please recheck the year and rerun the script.'
}

}

else {
Write-Host "`n"'The new school you entered does not exist as an OU. Please recheck the name and rerun the script.'
}