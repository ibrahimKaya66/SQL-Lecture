--DDL
--create
use master 
go
create database Deneme2
use Deneme2
go
--
/*
create table Students
(
ID int primary key identity(1,1),
No_ int not null,
Name_ varchar(20),
Surname varchar(30)
)
*/
create table Students
(
ID int not null,
No_ int not null,
Name_ varchar(20),
Surname varchar(30),
constraint PK_Id primary key(ID)--primary key(ID,No_)
)

alter table Students
drop constraint PK_Id

--column add
alter table Students
add Yas int

alter table Students
add colum1 int,colum2 date
--alter
alter table Students
alter column Yas varchar(10)

exec sp_rename 'Students.colum1','newColumn','COLUMN'
exec sp_rename 'Students','Ogrenciler'
use master
go
exec sp_renamedb 'Deneme2','SmartPro'

alter database SmartPro modify name = Deneme2
--Drop
use Deneme2
go
alter table Ogrenciler
drop column colum2

alter table Ogrenciler
drop column newColumn,Yas

drop table Ogrenciler

use master
go
drop database Deneme2

--truncate table
use Deneme
go
truncate table Ogrenciler