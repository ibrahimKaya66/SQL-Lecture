--Login & User
--Login
create login ibrahim with password = 'ik1993',
check_policy = off,check_expiration = off,default_database = [master] 
alter server role [sysadmin] add member [ibrahim]
--User

create user [ibrahim] for login [ibrahim]
go
use SmartPro
go
alter role [db_datareader] add member [ibrahim]



exec sp_droprolemember 'db_datareader','ibrahim'

sp_addrolemember 'db_owner','ibrahim'

exec sp_droprolemember 'db_owner','ibrahim'
alter role [db_datareader] add member [ibrahim]

--grant (tablo bazlı yetki verme)

grant insert on Products to [ibrahim]
revoke insert on Products to [ibrahim]

insert Products(Name_)
values('asdas')

use SmartPro
go
drop user [ibrahim]

use master
go
drop login [ibrahim]

--Ör:
--Login ve user oluşturmanızı
logine sysadmin role eklenecek
usere datawriter role eklenecerk
smartpro nun product tablosuna select yetkisi atanacak
insert yetkisi silinecek

--user ve login silinecek
create login yunus with password = 'yns69',
check_policy = off,check_expiration = off,
default_database = [master]

alter server role [sysadmin] add member [yunus]
--USER
create user yunus for login yunus

use [Northwind]
go
alter role [db_datawriter] add member yunus

grant select,update,delete on Products to yunus

revoke select on Products to yunus

drop user yunus

drop login yunus--ssms kapatılıp yönetici olarak yeniden çalıştırılacak ve sa ile giriş yapılacak
