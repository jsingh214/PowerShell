# Get Printers
$printers = Get-WmiObject -Class Win32_Printer

# Delete Printers
$printers | ForEach-Object {
    if ($_.Name -Match "\\umsprint"){
        $_.Delete()
    }
}