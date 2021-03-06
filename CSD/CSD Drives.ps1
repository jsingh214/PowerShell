#==============================================================================
# File:    CSDDrives.ps1
# Author:  Jason Singh
# Date:    7/25/2016
# Purpose: Map drives for CSD Employees as a logon script.
#==============================================================================

#Notes: Remove N, and you need a plan for the shared server restructure to then redo some of this script.


$user = $env:username
$group1 = "CSD SpEd Teachers SLPs"
$group2 = "CO Staff"
$members1 = Get-ADGroupMember -Identity $group1 -Recursive | Select -ExpandProperty SamAccountName
$members2 = Get-ADGroupMember -Identity $group2 -Recursive | Select -ExpandProperty SamAccountName

#Imports AD module...
Import-Module ActiveDirectory


#Conditions to map L Drive
If ($members1 -contains $user) {
    New-PSDrive –Name “L” –PSProvider FileSystem –Root “\\CSD160\Apps\SLD” –Persist
 }


#Conditions to map O Drive
if ($members2 -contains $user) {
    New-PSDrive –Name “O” –PSProvider FileSystem –Root “\\CSD160\coshared$” –Persist
 }

#Conditions to map to S Drive
if (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=CHS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}


elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=CMS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}


elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=MBS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}


elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=ST SUBS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}



elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=CO,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}


elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=PPS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}

elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=UMS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}

#Conditions to map to Y Drive
if (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=MBS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “Y” –PSProvider FileSystem –Root “\\csd160\Apps” –Persist

}

elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=CMS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “Y” –PSProvider FileSystem –Root “\\csd160\Apps” –Persist

}

elseif (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=CHS,OU=District,DC=csd,DC=local"){
    New-PSDrive –Name “Y” –PSProvider FileSystem –Root “\\csd160\Apps” –Persist

}