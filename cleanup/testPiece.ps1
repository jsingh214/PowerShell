#Start of script...
Import-Module ActiveDirectory
$searchOU = 'OU=Test2,OU=District,DC=csd,DC=local'

$excludeAnswer = Read-Host 'Are there any students that should not be moved?(Ex. Not graduating) If so please type yes.'
if($excludeAnswer -eq "yes") {
    Write-Host 'Please type in there username. To exit entering usernames hit enter leaving it blank, or type quit, or exit.'
    $excluded = @()
    do {
            $input = (Read-Host)
            $excluded += ,$input
       }
    until ($input -eq '' -or $input -eq 'quit' -or $input -eq 'exit')

    Write-Host "Are these the correct students to exlcude from the move? $excluded."
    $confirm = Read-Host 'If so type yes and hit enter'

    if($confirm -eq "yes") {
        foreach($excludeUser in $excluded) {
            Get-ADAccountAuthorizationGroup $excludeUser | Remove-ADGroupMember
        }
    }
}


    else {
        Write-Host 'Not a valid answer. Please run the script again to continue...'
        exit
    }
