# Get Printers
$printers = Get-WmiObject -Class Win32_Printer

# Delete Printers
$printers | ForEach-Object {
    if ($_.Name -Match "\\chs1"){
        $_.Delete()
    }
}

$printers | ForEach-Object {
    if ($_.Name -Match "\\cms1"){
        $_.Delete()
    }
}