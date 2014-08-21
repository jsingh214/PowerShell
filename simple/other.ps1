Get-ChildItem -Path C:\Test\users | ForEach-Object {

    Copy-Item -LiteralPath $_.FullName -Destination C:\Test2\users |

    Get-Acl -Path $_.FullName | Set-Acl -Path "C:\Test2\Users\$(Split-Path -Path $_.FullName -Leaf)"

}