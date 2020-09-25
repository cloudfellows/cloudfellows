Author        Kimberley Cabrera-Boggs
Date          September 24
Description   Eport from sql database into csv file 
Purpose       Make human readable


param
(
[String] $destination = 'C:\Users\Bigge\Desktop\',
[String] $ServerName = 'cloudfellows-db.database.windows.net', ## change it to your servername
[String] $dbname = 'SQL-server', #change this to the database name
[String] $TableName = 'SalesLT.Product', #table name 
[String] $usernames = 'admin123', #user name
[string] $password = 'Tester123@@@@@' # password
)
invoke-sqlcmd -Username $usernames -Password $password -query "SELECT * FROM $TableName" -database $dbname -serverinstance $ServerName |export-csv -path $destination$TableName.csv
