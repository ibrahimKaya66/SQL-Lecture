--Değişken tanımlama
declare @degisken_adı type --1.yol = {varsa değeri}
--2.yol set  @degisken_adı = value
--3.yol select @degisken_adı = value from...

declare @avg_price money
select  @avg_price = AVG(UnitPrice) from Products


select * from Products
where UnitPrice > @avg_price


declare @sayi1 int = 12
declare @sayi2 int
set @sayi2 = 15

print @sayi1+@sayi2


--Constraint
/*
1-Primary key
2-Unique
3-Default : create de oluşturulamaz alter table da oluşturur
4-Check
5-Foreign key
*/

create table Users
(
ID int not null identity(1,1),
TC varchar(11),
Username varchar(15),
Pass varchar(8),
Email varchar(max),
Gsm varchar(15),
Login_Date datetime
constraint PK_UID primary key(ID),
constraint UNQ Unique(TC)
)

ALTER TABLE Users
ADD constraint D_Login Default getdate() for Login_Date

truncate table Users

Alter table Users
Add constraint Chck Check((Pass is not null)
and (len(pass)<5)
and (patindex('%[0-9]%',Pass) > 0)
and (patindex('%[a-z]%',Pass) > 0)
and (charindex('@',Email) > 0)
and (charindex('@',Email) > 0)
and (charindex('.',Email,charindex('@',Email)) > 0)
and (Gsm like '05[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

alter table Users
drop constraint Chck

/*bir ürünün 1 kategori olur.
1kategoriye ait n kadar ürün olabilir.*/
--1 -n ilişiki 
--ilişkisel veri tabanı

create table Categories
(
ID int identity(1,1),
CategoryName varchar(15),
constraint PK_ID primary key(ID)
)

insert into Categories
values
('Telefon'),('Laptop'),('Beyaz Eşya'),('Elektronik Eşya')

create table Products
(
P_ID int identity(1,1),
C_ID int ,
Name_ varchar(20),
Price money,
Stock smallint,
Color varchar(20)
--constraint FK_ foreign key(C_ID) references Categories(ID)
)

--Foreign key
alter table Products
add constraint FK_Products_Categories foreign key(C_ID) references Categories(ID)

alter table Products
drop constraint FK_Products_Categories 

create table Products
(
P_ID int identity(1,1),
Name_ varchar(20),
Price money,
Stock smallint,
Color varchar(20)
)
alter table Products
add constraint Pk_PD primary key(P_ID)

create table Products_Category
(
P_id int,
C_id int
)

alter table Products_Category
add constraint FK_P 
foreign key(P_id) references Products(P_ID),
foreign key(C_id) references Categories(ID)




