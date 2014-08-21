Import-Module ActiveDirectory 
$Users = Import-Csv -Path ".\UMS.csv"  
foreach ($User in $Users)  
{  
    $OU = "OU=2026,OU=Students,OU=UMS,OU=District,DC=csd,DC=local"  
    $Description = $User.Description 
    $GivenName = $User.GivenName 
    $Surname = $User.Surname 
    $Detailedname = $User.GivenName + " " + $User.Surname 
    $FirstLetterFirstname = $GivenName.substring(0,1) 
    New-ADUser -Name $Detailedname -SamAccountName $User.sAMAccountName -UserPrincipalName $User.sAMAccountName -Description $Description -DisplayName $Detailedname -GivenName $user.GivenName -Surname $user.Surname -AccountPassword (ConvertTo-SecureString ChangeMe! -AsPlainText -Force) -Enabled $true -Path $OU  
} 

