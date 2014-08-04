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
    $confirm = Read-Host 'If so type yes and hit enter'

    #Processes that run after verified that the correct users were in fact entered...
    #Question: Is there a way to check if a variable that you have matches something inside an array? I need it for 
    if($confirm -eq "yes") {
        $OUs = Get-ADOrganizationalUnit -filter * -SearchBase "OU=District,DC=csd,DC=local"
        foreach($OU in $OUs){
        if($OUs -match $excludeYear){
        $excludePath = Get-ADOrganizationalUnit -Identity $excludeYear
        }
        } 
        foreach($excludeUser in $excluded) {
            Move-ADObject -Identity $excludeUser -TargetPath "OU=$excludeYear,OU=Students,OU=$oldSchool,OU=District,DC=csd,DC=local"
            }   
    }

    else {
        Write-Host 'Not a valid answer. Please run the script again to continue...'
        exit
    }
}

$users = Get-ADuser -filter * -SearchBase "OU=$gradYear,OU=$oldSchool,OU=District,DC=csd,DC=local" -properties HomeDirectory
#TODO: Look into how objects are moved if the operation was stopped our halted 
#Here is where the entire folder graduation year container is moved to its new location using this command...

foreach ($user in $users) {
    Remove-QADMemberOf -Identity $user.dn -RemoveAll
    #Add the users to their proper groups after being removed from their previous ones...
    Add-ADGroupMember -Identity $ADgroup $_ -Members $user -Confirm:$false  
    Add-ADGroupMember -Identity $ADgroupWeb $_ -Members $user -Confirm:$false
    }

foreach ($user in $users) {
Move-ADObject -Identity $user -TargetPath "OU=$gradYear,OU=Students,OU=$newSchool,OU=District,DC=csd,DC=local"
    }


}
}
    #This else belongs to school OU check at beginning of script...
    else {            
        Write-Host 'The OU for the school you typed in does not exist, try again.'            
    }

    #This else belongs to graduation year OU check at beginning of script...
    else {            
        Write-Host 'The OU for the graduation year you typed in does not exist, try again.'            
    }