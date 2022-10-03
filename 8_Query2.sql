--Fiyatı 30 dan büyük olan ürünleri list

select UnitPrice,ProductName from Products
where UnitPrice>30
order by 1


--fiyatı 20 ile 60 arasındaki ürünleri
select UnitPrice,ProductName from Products
--where UnitPrice>20 and UnitPrice<60
where UnitPrice between 20 and 60
order by 1



--Fiyatı 20,30,40 olanları listeleyiniz

select UnitPrice,ProductName from Products
--where UnitPrice=20 or UnitPrice=30 or UnitPrice=40
where UnitPrice in (20,30,40)
order by 1
--isminde c ile başlayan ürünleri küçük harflerle listeleyiniz
select lower(productname) from Products
	where ProductName like 'c%'


--isminin içerisinde a olan ürünleri büyük harflerle listeleyiniz

select upper(productname) from Products where ProductName like '%a%'

--Çalışanların ad ve soyadını tek bir kolanda listeleyiniz
select CONCAT(Employees.FirstName,' ',Employees.LastName) as [Ad Soyad] from Employees
--Tedarikçilerin region alanı null olanları 
select CompanyName,Region from Suppliers where Region is null
--ilk 5 tedarikçiyi ada göre list
select top 5 CompanyName from Suppliers
group by CompanyName
--müşterilerin adının başına ülkesine göre ülke kodu yazınız(switch-case) 

select
Customer = (case Country
when 'Germany' then 'DE'+CustomerID
when 'USA' then 'US'+CustomerID
when 'UK' then 'UK'+CustomerID
else 'TR'+CustomerID
END
) --as Customer
from Customers

select
Customer =  (case 
when Country =  'Germany' then 'DE'+CustomerID
when Country ='USA' then 'US'+CustomerID
when Country ='UK' then 'UK'+CustomerID
else 'TR'+CustomerID
END
) 
from Customers

--Ürün stoku 30 un altınsayda durumu kritik,
--30 ile 50 arasındaysa normal
--50 yukarısı stok fazlası
--0 sa stok yok

select ProductName,UnitsInStock,
Durumu = (case 
when UnitsInStock between 1 and 30 then 'Durumu Kritik'
when UnitsInStock between 30 and 40 then 'Durumu Normal'
when UnitsInStock>=40 then 'Stok fazlası'
else 'Stok yok'
End)
from Products


--en ucuz 5 ürünü listleyiniz ve bu ürünlerin ortalama fiyatını
declare @x int = (value1) --1.yol 
set @x = (value1)--2.yol
select @x=Methot() from ... --3.yol

declare @avg decimal(18,2)
select @avg = avg(EnUcuz) from(select top 5
UnitPrice as EnUcuz
 from Products
 order by UnitPrice ) as Table_


select top 5
UnitPrice as EnUcuz,
@avg as Ortalaması
 from Products
 order by UnitPrice 

--1998 yılı mart ayındaki siparişlerin adresi,çalışan adı ve soyadı

select o.OrderID,year(o.OrderDate), month(OrderDate),o.ShipAddress,
CONCAT(e.FirstName,space(1),e.LastName) İsim from Orders as O
join Employees e on e.EmployeeID = o.EmployeeID
where Year(OrderDate)=1998 and month(OrderDate)=3 

--1997 yılı şubat ayında kaç sipariş geçilmiş
select count(OrderID) Adet from Orders as o where Year(o.OrderDate) =1997 and Month(o.OrderDate) =2

--10248 nolu siparişin ürün adı,adedi,tedarikçi adı
select od.OrderID,p.ProductName,od.Quantity,
s.CompanyName
from [Order Details] od
join Products p on od.ProductID = p.ProductID
join Suppliers s on p.SupplierID = s.SupplierID
where od.OrderID = 10248

--3 numaralı ıd ye sahip çalışanın 1997 yılında sattığı ürünün adı ve adedi
select o.EmployeeID,
year(o.OrderDate),p.ProductName,od.Quantity
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Products p on od.ProductID = p.ProductID
where o.EmployeeID = 3 and 
	year(o.OrderDate) = 1997


--1997 yılında en çok satış cirosu yapan çalışanın Id,adını

select sum(od.UnitPrice*od.Quantity*(1-Discount)) Ciro
,e.EmployeeID,e.FirstName
from [Order Details] od 
join Orders o on od.OrderID = o.OrderID
join Employees e on o.EmployeeID = e.EmployeeID
where year(o.OrderDate) = 1997
group by e.EmployeeID,e.FirstName
order by 1 desc


--1997 yılında tek siparişte en çok satış cirosu yapan çalışanın Id,adını
select top 1 o.OrderID,e.FirstName,
sum(UnitPrice*Quantity*(1-Discount)) Ciro from [Order Details] od 
join Orders o on o.OrderID=od.OrderID
join Employees e on e.EmployeeID=o.EmployeeID
where YEAR(o.OrderDate)=1997 
group by o.OrderID,e.FirstName
order by Ciro desc 


--adet bazlı en çok satış yapılan ürünün Id ve name,adedi,categori adını ve tedarikçi adını

select p.ProductID,p.ProductName,c.CategoryName,s.CompanyName ,
 sum(od.Quantity) Adet
from [Order Details] od 
join Products p on od.ProductID = p.ProductID
join Categories c on p.CategoryID = c.CategoryID
join Suppliers s on p.SupplierID = s.SupplierID
group by p.ProductID,p.ProductName,c.CategoryName,s.CompanyName
order by 5 desc

--3 numarlı ıd ye sahip çalışanın son yılında kaç adet ürün sattı,cirosunu da bulunuz
declare @max_year int
set @max_year = 
( 
select top 1 year(OrderDate)  
from Orders o
where EmployeeID = 3
group by OrderDate
order by OrderDate desc
)
print @max_year
 

select @max_year,
e.EmployeeID,
concat(e.FirstName,space(1),e.LastName) Adı,
sum(od.Quantity) Adet,
Round(sum(UnitPrice*Quantity*(1-Discount)),2) Ciro
from Employees e
join Orders o on o.EmployeeID = e.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where e.EmployeeID = 3 and year(OrderDate) = @max_year
group by e.EmployeeID,e.FirstName,e.LastName


--20 numaralı Id ye sahip üründen son 3 ayda ne kadarlık ciro sağladım
declare @max_date datetime = (
select top 1 OrderDate from Orders
order by 1 desc
)
print 'Max date :'+Cast(@max_date as varchar)
declare @min_date datetime = 
dateadd(month,-3,@max_date)
print @min_date
select od.ProductID,
Round(sum(UnitPrice*Quantity*(1-Discount)),2) Ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
where od.ProductID = 20 
and (o.OrderDate between @min_date and @max_date)
group by ProductID


--son 5 siparişin ID,ortalama fiyatı
declare @avg_ciro decimal(6,2)
select @avg_ciro = avg(Ciro) from(select top 5 od.OrderID,
Round(sum(UnitPrice*Quantity*(1-Discount)),2) Ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
group by od.OrderID
order by 1 desc) Table_1
print @avg_ciro

select top 5 od.OrderID,
Round(sum(UnitPrice*Quantity*(1-Discount)),2) Ciro,
@avg_ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
group by od.OrderID
order by 1 desc

