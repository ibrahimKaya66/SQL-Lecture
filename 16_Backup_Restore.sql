--Backup Database
--Manuel Backup
/*
1-Task>Backup
2-Script ile backup
3-Server Object>Backup Device >new Backup and Bacup database
*/

--Otomatik Backup : Server Agent açık olması gerekli
/*
1-Maintenance Plans ile :Management>Maintenance Plans>Maintenance Plans Wizard

2-Job ile yedek alma: Server Agent>Jobs>new Job
*/

BACKUP DATABASE [Northwind]
TO
DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\Northwind2.bak' WITH NOFORMAT,
NAME = 'NORTHWHIND BACKUP'
GO