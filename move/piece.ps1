Import-Module ActiveDirectory
$oldSchool = Read-Host 'Which school needs a group moved? Please type the school initials.
Please  type in the initials of school'

if([ADSI]::Exists("LDAP://OU=$oldSchool,OU=District,DC=csd,DC=local")) {            
        Write-Host "Given OU exists"            
    } 
    
        else {            
        Write-Host "OU Not found"            
    }          




    $Username = $_.SamAccountName
set-aduser gbaldwin -homedirectory \\servername\shareneme\$Username -homedrive u: