#Start of script...
Import-Module ActiveDirectory

#Questions begin to determine variable data...

#Variable that represents the current graduated school...
$oldSchool = Read-Host 'Which school needs a group moved? Please type the school initials.
Please  Type in the initials of school.'

#This switch statement automatically sets $oldSchool to the proper variable for the next school after it is set by user...
#A new variables are created to represent the next school, which primary domain group they are in, and which web group by using if else...
If ($oldSchool -eq 'PPS' -or 'UMS')
{
  $newSchool = 'MBS'
  $ADgroup = 'MBS Students'
  $ADgroupWeb = 'MBS Students Web'
}
ElseIf ($oldSchool -eq 'MBS')
{
  $newSchool = 'CMS'
  $ADgroup = 'CMS Students'
  $ADgroupWeb = 'CMS Students Web'
}
ElseIf ($oldSchool -eq 'CMS')
{
  $newSchool = 'CHS'
  $ADgroup = 'CHS Students'
  $ADgroupWeb = 'CHS Students Web'
}
Else
{
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}

#The graduation year is set as a variable determined by user...
$gradYear = Read-Host 'Which graduation year group of students would you like to move? Please
type in the OU graduation year'

#This loop goes in and creates an array of students to be entered who are excluded from the process for whatever reason...
$exclude = @()
do {
 $input = (Read-Host 'Are there any students that should not be moved?(Ex. Not graduating)
Please type in there username. To exit entering usernames hit enter leaving it blank or type quit or exit')
 if ($input -ne '') {$exclude += $input}
}
until ($input -eq '' -or 'quit' -or 'exit')
$exclude	

#TODO: Look into how objects are moved if the operation was stopped our halted 
#Here is where the entire folder graduation year container is moved to its new location using this command...
Move-ADObject "CN=District,CN=$oldSchool,CN=$gradYear,DC=csd,DC=local -exclude $exclude" -TargetPath "CN=District,CN=$newSchool,DC=csd,DC=local"

#This begins with a three step process to remove the members from their groups...
# 1. Members are searched, found, and determined by these two commands and are set to a variable... 
$searchCN = "CN=District,CN=$newSchool,CN=$gradYear,DC=csd,DC=local"
$users = Get-ADuser -filter * -searchbase $searchCN -properties DistinguishedName | Select -expandProperty DistinguishedName | -Properties memberOf |

# 2. Retrieve groups that the users are a member of...
$groups = $users.memberOf |ForEach-Object {
    Get-ADGroup $_
} 

# 3. Go through the groups and remove the users...
Remove-ADGroupMember -Identity $_ -Members $users -Confirm:$false

#Add the users to their proper groups after being removed from their previous ones...
Add-ADGroupMember -Identity $ADgroup $_ -Members $users -Confirm:$false  
Add-ADGroupMember -Identity $ADgroupWeb $_ -Members $users -Confirm:$false