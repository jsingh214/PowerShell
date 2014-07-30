#Start of script...
Import-Module ActiveDirectory

#$ErrorActionPreference = "SilentlyContinue"

#Apparently needed for moving groups...
#Add-PSSnapin Quest.ActiveRoles.ADManagement

#Questions begin to determine variable data...

#Variable that represents the current graduated school...
$oldSchool = 'Test2'
$newSchool = 'Test3'
$ADgroup = 'CHS Students'
$ADgroupWeb = 'CHS Students Web'


#This loop goes in and creates an array of students to be entered who are excluded from the process for whatever reason...
<#$exclude = @()
do {
 $input = (Read-Host 'Are there any students that should not be moved?(Ex. Not graduating)
Please type in there username. To exit entering usernames hit enter leaving it blank or type quit or exit')
 if ($input -ne '') {$exclude += $input}
}
until ($input -eq '' -or $input -eq 'quit' -or $input -eq 'exit')
$exclude#>

#This uses double quotes because its needed for any strings where you need to evaluate the variables within. 
$searchOU = "OU=$oldSchool,OU=District,DC=csd,DC=local" 
$users = Get-ADGroupMember $searchOU | Format-Table Name 
<#-filter * -SearchBase $searchOU -Exclude $exclude#>
#TODO: Look into how objects are moved if the operation was stopped our halted 
#Here is where the entire folder graduation year container is moved to its new location using this command...

<#foreach ($user in $users) {
Move-ADObject -Identity $user -TargetPath "OU=$newSchool,OU=District,DC=csd,DC=local"
}

#This begins with a three step process to remove the members from their groups...
# 1. Members are searched, found, and determined by these two commands and are set to a variable... 


foreach ($user in $users) {
 Remove-QADMemberOf -Identity $user.dn -RemoveAll
}


#Add the users to their proper groups after being removed from their previous ones...
#Add-ADGroupMember -Identity $ADgroup $_ -Members $users -Confirm:$false  
#Add-ADGroupMember -Identity $ADgroupWeb $_ -Members $users -Confirm:$false#>