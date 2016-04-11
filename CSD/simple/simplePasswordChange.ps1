#Imports AD module...
Import-Module ActiveDirectory

#Takes in a user inputted variable to determine which school students to change home directories for...
$school = Read-Host 'Which school needs changes for home directories?(Please answer, PPS, UMS, MBS, CMS, or CHS.)'

#This is a check to see if school OU exists...
if([ADSI]::Exists("LDAP://OU=$school,OU=District,DC=csd,DC=local")) {    

$gradYear = Read-Host "`n"'Which graduation year group of students would you like to change home directories for? Please
type in the OU graduation year'

#This is a check to see if graduation year OU exists...
if([ADSI]::Exists("LDAP://OU=$gradYear,OU=Students,OU=$school,OU=District,DC=csd,DC=local")) {    

#Uses and if else statement to setup searchOU to proper home directory path...
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

#Sets a variable to users which is all users found in the specified OU and their home directory properties...
$users = Get-ADuser -filter * -SearchBase $searchOU

#This is a check prompt to make sure that you have the following fields right for the change in home directories....

Write-Host "`n"'Double check the following fields...'
Write-Host "Current School: $school"
Write-Host "Graduation Year Group of Students: $gradYear"

$confirm = Read-Host "`n"'Are the following fields correct? If so please type yes'


if($confirm = 'yes'){
#Goes through a for each loop to process new home directory path for each user...
foreach ($user in $users) {

 if ( -not (Get-ADUser -LDAPFilter "(sAMAccountName=$user)")) { 
        Write-Host "Can't find $user"
    }
    else { 
        $account = Get-ADUser -Identity $user
        $account | Set-ADAccountPassword -NewPassword $password -Reset
        $account | Set-AdUser -ChangePasswordAtLogon $true
        Write-Host "changed password for $user"
    }


#Confirmation message...
Write-Host "`n"'Home directory changes successful...'

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