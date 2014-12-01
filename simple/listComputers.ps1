ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\output.txt -append
$strCategory = "computer"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.Filter = ("(objectCategory=$strCategory)")

$colProplist = "name"
foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}

$colResults = $objSearcher.FindAll()


foreach ($objResult in $colResults)
    {$objComputer = $objResult.Properties; $objComputer.name}
    Stop-Transcript