--Functions
create{alter} function function_name
(
@param1 datatype --= value ,
...
)
returns table{datatype}
--as
begin--table da kullanılamaz
Query..
return value{select query}--table funct : select query ,value func : value
end----table da kullanılamaz


create function Topla
(
@x int = 5,@y int = 5
)
returns int
as
begin
return @x+@y
end


select dbo.Topla(default,default)
select ProductID,ProductName,UnitsInStock,UnitsOnOrder,dbo.Topla(UnitsInStock,UnitsOnOrder) from Products

drop function Topla

--ciro(fatura tutarı) hesaplaması yapan function ı yazınız.
create function Ciro
(
@q int,
@p money,
@d decimal
)
returns decimal
as
begin
return @q*@p*(1-@d)
end

select OrderID,sum(dbo.ciro(Quantity,UnitPrice,Discount)) from [Order Details]
group by OrderID

drop function Ciro


--personelin adı ve soyadını birleştirerk yazan function'ı yazınız
create function FullName
(
@name varchar(50),
@surname varchar(50)
)
returns varchar(50)
as
begin
return concat(@name,space(1),@surname)
end
select dbo.FullName(FirstName,LastName) as FullName from Employees
--id si girilen çalışanın kaç adet satış yaptığını function'la bulunuz

CREATE FUNCTION SATİS
(
@id int
)
returns int
as
begin
declare @emp int
set @emp = (SELECT COUNT(o.OrderID) FROM Employees e
join Orders o on o.EmployeeID = e.EmployeeID
WHERE e.EmployeeID = @id
GROUP BY e.EmployeeID)
return @emp
end

SELECT dbo.FullName(FirstName,LastName) as ISIM
,dbo.SATİS(EmployeeID) as SATIS FROM Employees

--Kategori id sine göre kaç adet ürün vardır.Bunu table döndüren functionu yazınız.
create function CategoryByCount
(
@id int
)
returns table
as
return (select p.CategoryID,c.CategoryName,count(*) Adet from Products p join Categories c on p.CategoryID = c.CategoryID
where c.CategoryID = @id
group by p.CategoryID,c.CategoryName)

declare @i int=1
while(@i <= 8)
begin
select * from CategoryByCount(@i)--table-valued func dbo. zorunlu değil 
set @i = @i+1
end

--çalışan ünvanına göre adı ve soyadadını tablo olarak döndürünüz
create function Unvan_
(@Unvan varchar(4) )
returns table
--as
return (select dbo.FullName(FirstName,LastName) Ad_Soyad,TitleOfCourtesy from Employees where TitleOfCourtesy = @Unvan )

select * from dbo.Unvan_('Mr.')

--math functionlardan sign metotunu kendiniz yazınız
create function fn_sign
(@x int)
returns int
as
begin
	if(@x > 0)
		return 1
	else if(@x < 0)
		return -1
		return 0
end
print dbo.fn_sign(-4)
print dbo.fn_sign(4)
print dbo.fn_sign(0)

--string func replicate func yazınız.
select replicate('12',4) -- 12121212

alter function fn_replicate(@text varchar(max),@num int)
returns varchar(max)
as 
begin
declare @x int
set @x = 0
declare @textson varchar(max)
set @textson = ''
while @x<@num
begin
set @textson = @text+@textson
set @x = @x+1
end
return @textson
end

print dbo.fn_replicate('i',5)

--ürün id si girilen ürünün id,ad,price listelensin
alter function Product_Info(@id int)
returns table
as
return select ProductID,ProductName,UnitPrice from Products
where ProductID = @id

select * from Product_Info(12)

--mail oluşturma functionını yazıp yeni tablo oluşturulup  mail kolonu default olarak değer atansın
--ad.soyad@smartpro.com

use Northwind
go
create function mailadress
(
@name varchar(20),
@surname varchar(20)
)
returns varchar(max)
as
begin
return (@name+'.'+@surname+'@smartpro.com')
end


create table deneme
(
name_ varchar(20),
surname varchar(20),
mail as dbo.mailadress(name_,surname)
)