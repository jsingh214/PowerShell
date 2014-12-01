Import-Module ActiveDirectory

$searchOU = "OU=Test2,OU=District,DC=csd,DC=local"

$users = Get-ADuser -filter * -SearchBase $searchOU

foreach ($user in $users) {

        $account = Get-ADUser -Identity $user
        <#$account | Set-ADAccountPassword -NewPassword $password -Reset#>
        $account | Set-AdUser -ChangePasswordAtLogon $true
        Write-Host "changed password for $user"
    }

