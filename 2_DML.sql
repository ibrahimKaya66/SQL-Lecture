--DML 
--CRUD(Create,Read,Update,Delete)
--Insert->Veri ekler
--Select->Listeleme
--Update->Günceller
--Delete->Veriyi şarta göre siler

--Insert Syntax
insert {into} table_name --varsa (Columname1,...)
values(N'deger1',...)
select .,. from table_name

create database SmartPro

use SmartPro
go
create table Students
(
ID int identity(1,1),
Name_ varchar(30),
Surname varchar(30),
Sınıf varchar(5)
constraint PK_ primary key(ID)
)

insert Students
values('Ibrahim','Kaya','202')

insert into Students
values 
(N'Muhammet',N'Tülü','202'),
(N'Batuhan',N'Dişçi','202'),
(N'Ozan',N'Dinç','202'),
(N'Cansu',N'Alakuş','202')

insert into Students (Name_,Surname)
select 'Alperen','Aktaş'

--Update Syntax
update table_name
set column_name = value1,column_name2 = value2,...
where [condition]

update Students
set Name_ = 'Ömer'
where ID = 3

update Students
set Sınıf = '202'
where Sınıf is null

update Students
set Sınıf  = null
where not Sınıf is  null-- where Sınıf is not null

--Delete syntax
delete from table_name --from zorunlu değil
where [condition]

delete from Students
where (ID = 2) or (ID = 4)

--Select Sytax
--Select column1,...
--from table_name
--join table2 on {condition}
--where {condition}
--group by column_name
--having condition
--order by index{veya column_name} asc{desc}

select * from Students
--union all
select ID,Name_,Surname,Students.Sınıf from Students

select [ID] ,[Sınıf],[Baslangıc Tarihi] from Students

select Name_+space(1)+Surname as 'Ad ve Soyad ' from Students
select Name_+' '+Surname as 'Ad ve Soyad ' from Students

select CONCAT(s.Name_,space(1),s.Surname) [Ad Soyad] 
from Students as s


--Select te kullanılan komutlar
1-Aritmetik operatör
2-As takısı(takma Ad)
3-Top -> üsten belirtilen adet kadar veri getirir
4-distinct -> Aynı verileri tekrar etmeden getirir

select top 1* from Students


select distinct Name_ from Students

--where de kullanılanlar
--1-Matınksa Operatörler (=,<,<=,>,>=,<>,!=)
--2-and, or,not
--3-is null,is not null
--4-like 
--5-between
--6-in

alter table Students
add Yas int

select * from Students
where 
--Yas = 25
--Yas <= 20
--Yas <> 26
(Yas != 24) --or (Yas is null)

select * from Students
where
--(Yas > 25) and (Sınıf = '202') or Name_ = 'Ozan'
--Yas < 25 and Yas >15
--not yas > 20
yas is not null


select * from Students 
where 
--Name_ like '%ra%'
-- Name_ like 'ö%'
--Name_ like 'ı%'
-- Surname like '%uş'
-- Surname not like '%uş'
 --not Surname  like '%uş'
-- Name_ like '[A-H]%'
--Yas like '%[1-5]'
--Surname like '[DT]%'
--Surname like '%[^şü]'
--Name_ like '[^A-H]%'
--Surname like '_ü_ü'
--Soyadı ilk karakteri k 3. karakteri y olanları getirin
Surname like 'k_y%'

--between
select * from Students 
where 
--Yas between 20 and 25
--Yas not between 20 and 25
not Yas  between 20 and 25

in:içinde

select * from Students 
where 
--ID in(1,2,4,9)
Name_ in('ıbrahim','muhammet')

--order by :sırlama yapar
--Asc:varsayılandır.A dan Z ye küçükten büyüğe sıralar
--Desc : Z den A ya büyükten küçüğe doğru sıralar
--Order by dan sonra columnname veya column un indexi yazılır

select * from Students
--order by 3
order by Surname desc

select Yas,ID,Sınıf from Students
order by 3

--union(AUB),union all(A+B),except(A/B)

select * from Students
where Yas >20
union 
Select * from Students
where Yas < 25

select * from Students
where Yas >20
union all
Select * from Students
where Yas < 25

select * from Students
where Yas >20
except
Select * from Students
where Yas < 25



