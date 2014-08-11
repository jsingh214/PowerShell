#Start of script...
Import-Module ActiveDirectory

$oldSchool = Read-Host 'Which school needs a group moved? Please type the school initials.
Please  type in the initials of school'

$gradYear = Read-Host 'Which graduation year group of students would you like to move? Please
type in the OU graduation year'    

if ($oldSchool -eq 'PPS' -or 'UMS') {
    $newSchool = 'MBS'
    $ADgroup = 'MBS Students'
    $ADgroupWeb = 'MBS Students Web'
}
elseif ($oldSchool -eq 'MBS') {
    $newSchool = 'CMS'
    $ADgroup = 'CMS Students'
    $ADgroupWeb = 'CMS Students Web'   
    $searchOU = "OU=$gradYear,OU=Students,OU=CMS,OU=District,DC=csd,DC=local"
}
elseif ($oldSchool -eq 'CMS') {
    $newSchool = 'CHS'
    $ADgroup = 'CHS Students'
    $ADgroupWeb = 'CHS Students Web'
    $searchOU = "OU=$gradYear,OU=Students,OU=CHS,OU=District,DC=csd,DC=local"
}

else {
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}

$searchOU = "OU=$gradYear,OU=Students,OU=$oldSchool,OU=District,DC=csd,DC=local"

Write-Host 'Double check the following fields...'"`n"
Write-Host "Current School: $oldSchool"
Write-Host "Graduation Year Group of Students: $gradYear"
Write-Host "New School: $newSchool"

$confirm = Read-Host "`n"'Are the following fields correct? If so please type yes'
if($confirm = 'yes'){

$excludeYear = $gradYear + 1

else {
Write-Host 'Please rerun the script since you were opted out by your answer...'
exit
}

$excludeAnswer = Read-Host 'Are there any students that should not be moved?(Ex. Not graduating) If so please type yes'

if($excludeAnswer -eq "yes") {
    Write-Host 'Please type the usernames of the students to be excluded. To exit entering usernames hit enter leaving it blank, or type quit, or exit.'
    $excluded = @()
    do {
            $input = (Read-Host)

            if (dsquery user -samid $input) {
            $excluded += ,$input
            }
            else {
            Write-Host "Cannot find user in Active Diretory, please recheck username and type it again."
            }
       }
    until ($input -eq '' -or $input -eq 'quit' -or $input -eq 'exit')

    Write-Host "Are these the correct students to exlcude from the move? $excluded."
    $confirmExcluded = Read-Host 'If so type yes and hit enter'
 
    if($confirmExcluded -eq "yes") {
        $OUs = Get-ADOrganizationalUnit -filter * -SearchBase "OU=District,DC=csd,DC=local"
        foreach($OU in $OUs){
        if($OUs -contains $exCludeYear){
        $excludePath = Get-ADOrganizationalUnit -Identity $excludeYear
        }
        }
         
        foreach($excludeUser in $excluded) {
            Move-ADObject -Identity $excludeUser -TargetPath "OU=$excludeYear,OU=Students,OU=$oldSchool,OU=District,DC=csd,DC=local"
            }   
    }

    else {
        Write-Host 'Exiting the script. Please run the script again to continue...'
        exit
    }
}

else {
$users = Get-ADuser -filter * -SearchBase $searchOU -properties HomeDirectory


foreach ($user in $users) { 
$sam = (Get-Aduser -identity $user).samaccountname
$homeDir = (Get-Aduser -Identity $user -Properties HomeDirectory).HomeDirectory 
$dir = Split-Path $homeDir -Leaf
If($sam -eq $dir)
{
Write-Host Deleting $homeDir...
Remove-Item $user.HomeDirectory -Force -Recurse
}
}

Write-Host 'Student home directory removal successful.'

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

Write-Host "`n"'Home directory path changes successful.'

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
}
Write-Host 'Student membership changes successful.'

if([ADSI]::Exists("LDAP://OU=$gradYear,OU=$newSchool,OU=District,DC=csd,DC=local")) {
foreach ($user in $users){Move-ADObject -Identity $user -TargetPath "OU=$gradYear,OU=Students,OU=$newSchool,OU=District,DC=csd,DC=local"}
Remove-ADOrganizationalUnit -Identity "OU=$gradYear,OU=$oldSchool,OU=District,DC=csd,DC=local"
}

else {
Move-ADObject "OU=$gradYear,OU=Students,OU=$oldSchool,OU=District,DC=csd,DC=local" -TargetPath "OU=Students,OU=$newSchool,OU=District,DC=csd,DC=local"
}

}
}

