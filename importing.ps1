# Script Name: Importing Excel to the Sql Database
# Author: Jin Kim
# Date of last revision: 09/24/2020
# Description of purpose: To import excel file to the database and dropping table when the table exists.


$CSVFileName = "C:\Users\Bigge\Desktop\SalesLT.Product.csv"
$SQLInstance = "cloudfellows-db.database.windows.net"
$SQLDatabase = "SQL-server"
$SQLTable = "SalesLT.Product"
##############################################
# Prompting for SQL credentials
##############################################
$SQLUsername = UserName
$SQLPassword = Password
##############################################
# Dropping Temp Table using SQL DROP
##############################################
$SQLDrop = "
DROP TABLE IF EXISTS $SQLTable;"      
Invoke-SQLCmd -Query $SQLDrop -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword -Database $SQLDatabase
##############################################
# Creating Temp SQL Table
##############################################
"Creating SQL Table $SQLTempTable for CSV Import" 
$SQLCreateTempTable = "
    CREATE TABLE $SQLTable (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
	Name varchar(100),
	ProductNumber varchar(100),
    Color varchar(255),
	StandardCost varchar(255),
    ListPrice varchar(100),
    Size varchar(10),
    Weight varchar(20),
    Quantities varchar(10),
    ProductModelID varchar(5),
    SellStartDate datetime
);"
Invoke-SQLCmd -Query $SQLCreateTempTable -ServerInstance $SQLInstance -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword
##############################################
# Importing CSV and processing data
##############################################
$CSVImport = Import-CSV $CSVFileName
$CSVRowCount = $CSVImport.Count
##############################################
# ForEach CSV Line Inserting a row into the Temp SQL table
##############################################
"Inserting $CSVRowCount rows from CSV into SQL Table $SQLTempTable"
ForEach ($CSVLine in $CSVImport)
{
# Setting variables for the CSV line, ADD ALL 170 possible CSV columns here
$CSVName = $CSVLine.Name
$CSVProductNumber = $CSVLine.ProductNumber
$CSVColor = $CSVLine.Color
$CSVStandardCost = $CSVLine.StandardCost
$CSVListPrice = $CSVLine.ListPrice
$CSVSize =$CSVLine.Size
$CSVWeight = $CSVLine.Weight
$CSVQuantities = $CSVLine.Quantities
$CSVProductModelID = $CSVLine.ProductModelID
$CSVSellStartDate = $CSVLine.SellStartDate
##############################################
# SQL INSERT of CSV Line/Row
##############################################
$SQLInsert = "
INSERT INTO $SQLTable (Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, Quantities, ProductModelID, SellStartDate)
VALUES('$CSVName', '$CSVProductNumber', '$CSVColor', '$CSVStandardCost', '$CSVListPrice', '$CSVSize', '$CSVWeight', '$CSVQuantities', '$CSVProductModelID', '$CSVSellStartDate');"
# Running the INSERT Query
Invoke-SQLCmd -Query $SQLInsert -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword -Database $SQLDatabase;
}

Remove-Item -Path "$CSVFileName"
