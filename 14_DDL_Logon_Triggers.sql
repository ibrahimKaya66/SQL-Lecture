--DDL Trigger ve Logon Trigger
--DDL Trigger
use Northwind 
go
create table Vt_Kayıt
(
ID int identity(1,1),
KAYIT_ZAMANI datetime,
EVENTCONTENT xml
)

CREATE TRIGGER TG_Vt_Kayitlar
    ON all server 
    FOR CREATE_DATABASE --drop_databse ater_database
    AS
    BEGIN
        IF OBJECT_ID('dbo.VT_KAYITLAR') IS NOT NULL
        BEGIN
            BEGIN TRY
                DECLARE @Eventcontent XML;
                SET @Eventcontent = EVENTDATA();
                INSERT dbo.VT_KAYITLAR (
                  KAYIT_ZAMANI
                , EVENTCONTENT
                )
                VALUES (
                  GETDATE()
                , @Eventcontent
                );
            END TRY
            BEGIN CATCH
                SET @Eventcontent= NULL;
            END CATCH
        END
    END


use master 
go
create database deneme2
alter Trigger TG_Vt_Kayitlar
ON ALL SERVER
FOR CREATE_DATABASE
AS
PRINT 'Veritabanı oluşturamazsınız.'
ROLLBACK

use Northwind
go
DROP TRIGGER TG_Vt_Kayitlar ON all server

drop table [dbo].[Vt_Kayıt]

--Logon Trigger
alter trigger TrpcName
on all server with execute as 'sa'
for Logon
as
begin
declare @message varchar(50) = 'ibrahim kaya giriş yaptı'
if(ORIGINAL_LOGIN() != '202-001')
begin
	commit
	
end
else
begin
	print @message
	rollback
end
end

exec sp_readerrorlog