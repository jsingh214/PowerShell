Import-Module ActiveDirectory

$users = Get-Content users.txt

foreach ($user in $users) {

    Remove-Item $user.HomeDirectory
    Remove-ADUser $user.samAccountName -Confirm:$False

}