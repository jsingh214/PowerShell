#==============================================================================
# File:    CSDITDrives.ps1
# Author:  Jason Singh
# Date:    7/25/2016
# Purpose: Map drives for CSD IT Admins as a logon script.
#==============================================================================

$user = $env:username

#Imports AD module...
Import-Module ActiveDirectory

#Maps S Drive to user
if (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=Users,OU=CSD IT,DC=csd,DC=local"){
    New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

}

#Maps U Drive to user
if (Get-ADUser -Filter {SamAccountName -like $user} -SearchBase "OU=Users,OU=CSD IT,DC=csd,DC=local"){
    New-PSDrive –Name “U” –PSProvider FileSystem –Root “\\CSD160\ITAdmins” –Persist

}