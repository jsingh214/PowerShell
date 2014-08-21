  $Users = Import-Csv -Path ".\UMS.csv"  
  foreach ($User in $Users)  
{  
    $GivenName = $User.GivenName 
$FirstLetterFirstname = $GivenName.substring(0,1) 
    $SAM =  $User.Surname + $FirstLetterFirstname
    $SAM
    }