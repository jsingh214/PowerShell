
$year = Read-Host 'Do you need to access the current year or last year database?(Please answer this for this year, or last for last year then hit Enter)'

If ($year -eq 'last') {
Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name DBConn
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name DBConn -Value "Provider=SQLOLEDB.1;Password=__;User ID=sa;Persist Security Info=True;Initial Catalog=WinSNAP_EOY_16-17;Data Source=WEBSMART;Connect Timeout=600"

#Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name SecurityDBConn
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name SecurityDBConn -Value "Provider=SQLOLEDB.1;Password=8hestA3;User ID=sa;Persist Security Info=True;Initial Catalog=WinSNAP_EOY_16-17;Data Source=Websmart;Connect Timeout=600"
Write-Host 'Success!'
}

ElseIf ($year -eq 'this') {
Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name DBConn
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name DBConn -Value "Provider=SQLOLEDB.1;Password=___;User ID=sa;Persist Security Info=True;Initial Catalog=WinSNAP;Data Source=WEBSMART;Connect Timeout=600"

#Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name SecurityDBConn
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\SNAP Systems, Inc\WinSNAP" -Name SecurityDBConn -Value "Provider=SQLOLEDB.1;Password=WebSMARTT312;User ID=sa;Persist Security Info=True;Initial Catalog=WinSNAPSecurity;Data Source=Websmart;Connect Timeout=600"
Write-Host 'Success!'
}

Else {
Write-Host 'Not a valid answer. Please run the script again to continue...'
exit
}


Write-Host "Success! The database paths have been changed. Please close this window."