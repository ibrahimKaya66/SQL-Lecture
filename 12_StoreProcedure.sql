--Store Procedure
--Syntax
create proc{procedure} proc_name
--(
@param1 datatype --= değeri,
@param2 datatype,
...
--)
--with encryption{recompile}
as
--begin
select query;
--end
--go;

--Ör:Müştrilerin adında girilen göre müşteri listesini getiriniz.

alter proc sp_CustByName 
(
	@name varchar(50)
)
--with encryption
as
select * from Customers 
where CompanyName like '%'+@name+'%'

exec sp_CustByName 'al'

--Customer Contacttitle parametresiyle girilen değere göre müşterinin siparişlerini listeleyiniz,Contacttitle ı girilmesiyse varsayılan owner olsun
create proc sp_ContactTitle
(
 @ContactTitle varchar(50) = 'Owner'
)
as
select CompanyName,ContactTitle,OrderID from Customers c
join Orders o on o.CustomerID = C.CustomerID
where c.ContactTitle like '%'+@ContactTitle+'%'
exec sp_ContactTitle --'Sales Representative'

--ürüngüncelleme procedure de parametre olarak adını,fiyatı ve stoğu güncelleyen procedure 'yi yazınız
alter proc sp_UpdateProduct
(
@ID int,
@Stock smallint = 150,
@Price money,
@_Name varchar(50)
)
as
UPDATE Products
set UnitPrice=@Price,UnitsInStock=@Stock,ProductName=@_Name
where ProductID=@ID

exec sp_UpdateProduct  1,100,10000,'Çikolata'

exec sp_UpdateProduct @_Name = 'kek',@ID = 5,@stock = 3,@price = 5

exec sp_UpdateProduct 1,default,100,'deneme'

--delete syntax
delete 
--from 
table_name
where id = 12

delete UrunIDveAdi where ProductID = 17
--şehri girilen veya posta kodu girilen müşteriyi bul 

create proc CustCountrPosta
(
@city varchar(50) = '',
@posta varchar(50) = ''
)
as
select CustomerID,CompanyName,City,PostalCode from Customers
where City = @city or PostalCode = @posta

exec CustCountrPosta @posta = 'T2F 8M4'

alter proc sp_CustCountrPosta
(
@c_p varchar(50) = ''
)
as
begin
 if(exists(
		select * from Customers
		where City = @c_p
		)
	)
	begin
	select CustomerID,CompanyName,City,PostalCode from Customers
	  where City = @c_p
	end
else
begin 
select CustomerID,CompanyName,City,PostalCode from Customers
	  where PostalCode = @c_p
end
end


exec sp_CustCountrPosta 'Madrid'
exec sp_CustCountrPosta '05021'


--çalışanların yas : 40(parametere) yaşında emekli olduğunu düşünürsek emekli olan çalışanları proceudur yazınız.
alter proc sp_EmployeeAge
(
@age int = 40
)
as
begin
declare @max_date datetime
select @max_date = max(OrderDate) from Orders
declare @i int = 1,@e_age int = 0
while(@i <= 9)
begin
select @e_age = DATEDIFF(YEAR,BirthDate,@max_date) from Employees
where EmployeeID = @i

if(@e_age > @age )
begin
 select EmployeeID,FirstName,LastName,DATEDIFF(YEAR,BirthDate,@max_date)
 from Employees where EmployeeID = @i
end

set @i = @i+1
end
end

exec sp_EmployeeAge 45

--Ürünün id sine göre getirisi 4000 in altındaysa ederi düşük ,4000-10000 ederi idare,10000den büyükse ederi yüksek
--ürün ederi =  stok*price

alter proc Urun_Getirisi
(
@id int
)
as
begin
declare @urun_ederi int
SELECT @urun_ederi = (UnitPrice*UnitsInStock) FROM Products
WHERE ProductID = @id
if(@urun_ederi < 4000)
begin
SELECT ProductID,ProductName,@urun_ederi URUN_EDERİ,'DÜŞÜK' DEĞER FROM Products
WHERE ProductID = @id
end
else if(@urun_ederi > 4000 AND @urun_ederi < 10000)
begin
SELECT ProductID,ProductName,@urun_ederi URUN_EDERİ,'İDARE EDER' DEĞER FROM Products
WHERE ProductID = @id
end
else if(@urun_ederi > 10000)
begin
SELECT ProductID,ProductName,@urun_ederi URUN_EDERİ,'YÜKSEK' DEĞER FROM Products
WHERE ProductID = @id
end
end

exec Urun_Getirisi 2
--substring string metodunu kendiniz procedure'ünü yazınız
create proc sp_Substring
(
@text varchar(50),
@index int,
@count int
)
as
declare @len int,@result varchar(50),@textindex int,@right_text varchar(50),@left_text varchar(50)
set @len = (select len(@text))
set @textindex = @len-@index+1
set @right_text = (select RIGHT(@text,@textindex))
set @result = (select LEFT(@right_text,@count))
print @result

exec sp_Substring 'ibrahim',3,5

--ürünün ıd si girelerek miktarı ve adını printe yazdırınız.
--out,output

alter proc sp_ProductQuantity
(
@p_id int,
@p_name varchar(50) out,
@p_Q int output
)
as
select @p_name = p.ProductName,@p_Q = sum(od.Quantity) from Products p
join [Order Details] od on od.ProductID = p.ProductID
where p.ProductID = @p_id
group by p.ProductName

declare @name varchar(50) = '',@Q int =0
exec sp_ProductQuantity 2,@name out,@Q out

select @name+' ürünün sipariş miktarı : '+cast(@Q as varchar(5))
