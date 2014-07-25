#Start of script...
Import-Module ActiveDirectory

#Questions begin to determine variable data...

#Variable that represents the current graduated school...
$oldSchool = 'Test2'
$newSchool = 'Test3'
$ADgroup = 'CHS Students'
$ADgroupWeb = 'CHS Students Web'


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
Move-ADObject 'OU=$oldSchool,OU=District,DC=csd,DC=local -exclude $exclude' -TargetPath 'OU=$newSchool,OU=District,DC=csd,DC=local'

#This begins with a three step process to remove the members from their groups...
# 1. Members are searched, found, and determined by these two commands and are set to a variable... 
$searchCN = 'OU=$newSchool,OU=District,DC=csd,DC=local'
$users = Get-ADuser -filter * -searchbase $searchCN -properties DistinguishedName | Select -expandProperty DistinguishedName | -Properties memberOf

<# 2. Retrieve groups that the users are a member of...
$groups = $users.memberOf |ForEach-Object {
    Get-ADGroup $_
} 

# 3. Go through the groups and remove the users...
Remove-ADGroupMember -Identity $_ -Members $users -Confirm:$false

#Add the users to their proper groups after being removed from their previous ones...
Add-ADGroupMember -Identity $ADgroup $_ -Members $users -Confirm:$false  
Add-ADGroupMember -Identity $ADgroupWeb $_ -Members $users -Confirm:$false

Test input array:
[array]$employees = (Read-Host “Employee (separate with comma)”).split(“,”) | %{$_.trim()} #>