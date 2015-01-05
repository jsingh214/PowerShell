
#Uncomment to pull from a text list with computer names -- you will also need to comment out the next section
#$ADComputer = get-content C:\Users\singhj\Desktop\list.txt
######################################################################
#the 4 lines of code below will open an AD structure that allows selection of OU and computers listed there
######################################################################
$GetADOU = Get-ADOrganizationalUnit -Filter * -properties * | Select canonicalname,distinguishedname | sort-object canonicalname | Out-GridView -Title "Pick an OU for Group 1" -passthru
$ADOU = $GetADOU.distinguishedname 

$GetADComputer = get-adcomputer -LDAPFilter "(&(objectCategory=computer)(operatingSystem=Windows 7*))" -searchbase $ADOU -Properties name, operatingsystem |Select name, operatingsystem | sort-object name | Out-GridView -Title "Pick the computers to check" -passthru
$ADComputer = $GetADComputer.name
#######################################################################
#what file to search for on remote pc

$dest1 = "\c$\how_decrypt.gif"
$dest2 = "\c$\how_decrypt.html"

#location and name of logfile to save results
$logfile = "C:\Reports\results.txt"

foreach ($pc in $ADComputer){
if (test-connection -Computername $pc -count 1 -erroraction silentlycontinue)
{#Connection Found
"$pc found, checking..."

if(test-path \\$pc$dest1 -erroraction silentlycontinue){
Write-host $pc is good 
$log = "$pc - how_decrypt.html - YES"; add-content $logfile $log}
else {
write-host $pc "-" " no html virus found"
$log = "$pc - how_decrypt.html - NO"; add-content $logfile $log} 
}

else {
write-host "$pc - is not communicating"
$log = "$pc - offline"; add-content $logfile $log
}

}
