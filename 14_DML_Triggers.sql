--DML Trigger Syntax
create{alter} trigger trigger_name
on table_name--dbo.tablename yazılabilir
after{for}{instead of}
insert{update}{delete}
--with encryption
as
--begin
sql statement
--end

/*
1-tablo adı belirtilir
2-ne zaman tetikleneceği
3-hangi sql sorgusunda tetikleneceği
4-sql query
*/
--sipariş eklendiğinde ürünün stoğu azalsın
alter trigger insert_order
on [Order Details]
--with encryption
after insert
as
declare @p_id int,@quantity int
select @p_id = ProductId,@quantity = Quantity from inserted
update Products
set UnitsInStock -=@quantity
where ProductID = @p_id

insert into [Order Details] 
values (10250,4,1000,3,0)

--ürün silindiğinde ve güncellendiğinde ürün stoğu değişsin

create trigger product_delete
on [Order Details]
for delete
as
declare @p_id int,@quantity int
select @p_id=ProductId,@quantity=Quantity from deleted
update Products
set 
UnitsInStock +=@quantity
where ProductId=@p_id

delete [Order Details]
where OrderID=10250 and ProductID=4

create trigger updateOrder
on [dbo].[Order Details]
after update
as
declare @p_id int, @quantity int, @quantitynew int
select @p_id = ProductID,@quantity=Quantity from deleted
select @quantitynew=Quantity from inserted
update Products
set UnitsInStock += @quantity-@quantitynew where ProductID=@p_id

select * from Products where ProductID=11

update [dbo].[Order Details] set Quantity = 10 where ProductID =11 and OrderID = 10248

--ilgili trigger'ı enable/disable Trigger
--1.yol enable{disable} trigger trigger_name on table_name
--2.yol  enable{disable} table_name.trigger_name on table_name
--3.yol alter table table_name enable{disable} trigger trigger_name
disable trigger insert_order on [Order Details]

disable trigger [Order Details].product_delete on [Order Details]

alter table [Order Details]
disable trigger updateOrder

enable trigger all on [Order Details]

if OBJECT_ID('insert_order','TR') is not null
	disable trigger insert_order on [Order Details]

disable trigger all on [Order Details]

--update,delete ve insert sipariş için stok güncellemesi yapan tek bir trigger yazınız

create trigger statusOrders
on [order Details]
after update ,delete,insert
as
begin
	declare @id int , @d_miktar int ,@i_miktar int
	if(exists(select * from deleted))
	begin
		if(exists(select * from inserted))
		begin
			select @id=productID,@d_miktar=Quantity from deleted
			select @i_miktar=Quantity from inserted
			update Products
			set UnitsInStock += @d_miktar-@i_miktar where ProductID=@id 
		end

		else 
		begin
			select @id=productID,@d_miktar=Quantity from deleted
			update Products
			set UnitsInStock += @d_miktar where ProductID=@id
		end
	end
	else
	begin
		select @i_miktar=Quantity,@id=ProductID from inserted
		update Products
		set UnitsInStock -= @i_miktar where ProductID=@id
	end
end

--pid : 11->stok : 24
delete [Order Details]
where OrderID = 10248 and ProductID = 11
select ProductID,ProductName,UnitsInStock from Products where ProductID = 11

alter trigger allOrder1
on [dbo].[Order Details]
after update,delete,insert
as
declare @p_id int, @quantity int, @quantitynew int
select @p_id = ProductID,@quantity=Quantity from deleted
select @quantitynew=Quantity from inserted
update Products
set UnitsInStock += @quantity-@quantitynew where ProductID=@p_id



delete [Order Details]
where OrderID = 10248 and ProductID = 72
select ProductID,ProductName,UnitsInStock from Products where ProductID = 72


--Employees tablosundaki TitleOfCourtsy değiştirilemesin
alter trigger t_degistirilmez
on employees
instead of update 
as
declare @dtoc varchar(10) ,@itoc varchar(10) 
select @dtoc = Titleofcourtesy from deleted
select @itoc = Titleofcourtesy from inserted
if(@dtoc!=@itoc)
raiserror('Cinsiyet değiştirilemez Alperen .',5,10)

update Employees set TitleOfCourtesy = 'Dr.' where EmployeeID=1

--raiseerror level parametresi
--0-10 : bilgi mesajı
--11-16:Kullanıcı kaynaklı


--Çalışan silindiği zaman çalışan tablosunda silindi kolonu true(1) olsun
use Northwind
go
alter table Employees
add isDelete bit

update Employees
set isDelete = 0

create trigger Emp_Delete
on Employees
instead of Delete
as
declare @id int
select @id = EmployeeID from deleted
update Employees
set isDelete = 1
where EmployeeID = @id

delete Employees
where EmployeeID = 1

select EmployeeID,isDelete from Employees

disable trigger [t_degistirilmez] on [dbo].[Employees]

--ürün silindiği zaman silinen ürünler tablosuna eklensin
use SmartPro
go
create table DeleteProducts
(
ID int ,
Name_ varchar(50)
)

alter trigger AddDelProduct
on Products
for delete
as
insert DeleteProducts
select P_ID,Name_ from deleted

delete Products
where P_Id = 3

select * from Products
select * from DeleteProducts
