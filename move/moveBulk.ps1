#Start of script...
Import-Module ActiveDirectory

#Questions begin to determine variable data...
#Variable that represents the current graduated school...
$oldSchool = Read-Host 'Which school needs a group moved? Please type the school initials.
Please  type in the initials of school'

#This if makes a check to see that an OU exists for the school initals typed in...
if([ADSI]::Exists("LDAP://OU=$oldSchool,OU=District,DC=csd,DC=local")) {    

#This if else statement automatically sets $oldSchool to the proper variable for the next school after it is set by user...
#All new variables are created to represent the next school, which primary domain group they are in, and which web group by using if else...
if ($oldSchool -eq 'PPS' -or 'UMS') {
    $newSchool = 'MBS'
    $ADgroup = 'MBS Students'
    $ADgroupWeb = 'MBS Students Web'
}
elseif ($oldSchool -eq 'MBS') {
    $newSchool = 'CMS'
    $ADgroup = 'CMS Students'
    $ADgroupWeb = 'CMS Students Web'   
}
elseif ($oldSchool -eq 'CMS') {
    $newSchool = 'CHS'
    $ADgroup = 'CHS Students'
    $ADgroupWeb = 'CHS Students Web'
}
else {
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}

#The graduation year is set as a variable determined by user...
$gradYear = Read-Host 'Which graduation year group of students would you like to move? Please
type in the OU graduation year'

#This if makes a check to see that an OU exists for the graduation year typed in...
if([ADSI]::Exists("LDAP://OU=$gradYear,OU=$oldSchool,OU=District,DC=csd,DC=local")) { 


#This is a check prompt to make sure that you have the following fields right for the change in group memberships....

Write-Host "`n"'Double check the following fields...'
Write-Host "Current School: $school"
Write-Host "Graduation Year Group of Students: $gradYear"
Write-Host "New School: $newSchool"

$confirm = Read-Host "`n"'Are the following fields correct? If so please type yes'
if($confirm = 'yes'){

#This variable is the OU year of which the excluded students have to stay back. You add one year to the current year because thats what year if they were to stay back they would be put into...
$excludeYear = $gradYear + 1

#This loop goes in and creates an array of students to be entered who are excluded from the process for whatever reason...
$excludeAnswer = Read-Host 'Are there any students that should not be moved?(Ex. Not graduating) If so please type yes'

#Within this loop it is taking inputs from the person running the script. They will be entering usernames of students and as they enter them there is also a check to see if the username itself exists. If the username does not exist, it does not add it to the array...
if($excludeAnswer -eq "yes") {
    Write-Host 'Please type the usernames of the students to be excluded. To exit entering usernames hit enter leaving it blank, or type quit, or exit.'
    $excluded = @()
    do {
            $input = (Read-Host)
            #This if is another check which will check to see if the username typed in actually exists in active directory...
            if (dsquery user -samid $input) {
            $excluded += ,$input
            }
            else {
            Write-Host "Cannot find user in Active Diretory, please recheck username and type it again."
            }
       }
    until ($input -eq '' -or $input -eq 'quit' -or $input -eq 'exit')

    #A user check message that checks if the students typed and displayed from the loop are the correct user names...
    Write-Host "Are these the correct students to exlcude from the move? $excluded."
    $confirmExcluded = Read-Host 'If so type yes and hit enter'

    #Processes that run after verified that the correct users were in fact entered...
    #Question: Is there a way to check if a variable that you have matches something inside an array? I need it for 
    if($confirmExcluded -eq "yes") {
        $OUs = Get-ADOrganizationalUnit -filter * -SearchBase "OU=District,DC=csd,DC=local"
        foreach($OU in $OUs){
        if($OUs -match $excludeYear){
        $excludePath = Get-ADOrganizationalUnit -Identity $excludeYear
        }
        }
         
        foreach($excludeUser in $excluded) {
        #TODO: Have it make a check that excludeyear exists and if it does move those users other wise create the OU then move
            Move-ADObject -Identity $excludeUser -TargetPath "OU=$excludeYear,OU=Students,OU=$oldSchool,OU=District,DC=csd,DC=local"
            }   
    }

    else {
        Write-Host 'Exiting the script. Please run the script again to continue...'
        exit
    }
}

$users = Get-ADuser -filter * -SearchBase "OU=$gradYear,OU=$oldSchool,OU=District,DC=csd,DC=local" -properties HomeDirectory

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

#Confirmation message for home directory cleanup...
Write-Host 'Student home directory deletion successful.'

foreach ($user in $users) { 

If ($newSchool -eq 'PPS') {        
Set-ADUser $sam -HomeDirectory "\\pps2\ppsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}

ElseIf ($newSchool -eq 'UMS') {
Set-ADUser $sam -HomeDirectory "\\ums2\umsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}

ElseIf ($newSchool -eq 'MBS') { 
Set-ADUser $sam -HomeDirectory "\\mbs1\mbsusers$\Students\$gradYear\$sam" -HomeDrive "I:" 
Write-Host Changing home directory for $sam... 
}

ElseIf ($newSchool -eq 'CMS') { 
Set-ADUser $sam -HomeDirectory "\\cms1\cmsusers$\Students\$gradYear\$sam" -HomeDrive "I:" 
Write-Host Changing home directory for $sam... 
}

ElseIf ($newSchool -eq 'CHS') { 
Set-ADUser $sam -HomeDirectory "\\chs1\chsusers$\Students\$gradYear\$sam" -HomeDrive "I:"
Write-Host Changing home directory for $sam...  
}
}

#Confirmation message for home directory path changes...
Write-Host "`n"'Home directory path changes successful...'

#This is the process for changing of group memberships...
foreach ($user in $users) {
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

#Confirmation message of membership changes...
Write-Host 'Student membership changes successful.'

#This command moves the OU that was selected by the user to be moved to moved to the new school OU...
If ($newSchool -eq 'PPS' -or 'UMS') {
if([ADSI]::Exists("LDAP://OU=$gradYear,OU=$newSchool,OU=District,DC=csd,DC=local")) {foreach ($user in $users){Move-ADObject -Identity $user -TargetPath "OU=$gradYear,OU=Students,OU=$newSchool,OU=District,DC=csd,DC=local"}
Remove-ADOrganizationalUnit -Identity "OU=$gradYear,OU=$newSchool,OU=District,DC=csd,DC=local"
}

else {Move-ADObject "OU=$gradYear,OU=Students,OU=$oldSchool,OU=District,DC=csd,DC=local" -TargetPath "OU=Students,OU=$newSchool,OU=District,DC=csd,DC=local"}

}
}
else {
Write-Host "`n"'Exiting the script. To continue rerun the script...'
}

}
#Else messages for checks above to see if objects exist...
else {
Write-Host "`n"'The school you entered does not exist as an OU. Please recheck the name and rerun the script.'
}


}
else {
Write-Host "`n"'The graduation year for students you entered does not exist as an OU. Please recheck the year and rerun the script.'
}
