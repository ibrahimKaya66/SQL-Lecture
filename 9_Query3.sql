--Her üründen 1 tane sipariş alsam ne kadar ödeme yaparım
select sum(UnitPrice) from Products

--Depoda(ürünler) kaç liralık ürün var
select sum(UnitsInStock*UnitPrice) from Products

--1 ve 3 ıd li kargo şirketlerine 1996 yılı perşembe günleri toplam ne kadar ödeme yapmışım
select s.ShipperID, s.CompanyName, sum(o.Freight) from Shippers s
join Orders o on s.ShipperID = o.ShipVia
where (s.ShipperID = 1 or s.ShipperID = 3) and (Year(o.OrderDate) = 1996) and (datename(weekday,o.OrderDate) = 'Thursday') 
group by s.ShipperID, s.CompanyName


--ürünler taplosunda ürünlerin satışta olup olmadığını yazdırınız
select p.ProductName,p.Discontinued,
Durum=(Case p.Discontinued When 0 Then 'Satışda' When 1 Then 'Satışta Değil' End) 
from Products p

--ülkeye göre çalışan sayısı
select Country,
Count(*) from Employees
group by Country
--Nancy,Andrew ve Janet tarafından alınan siparişlerin orderID,Çalışan Adı
select orders.OrderID, Employees.FirstName from Orders
join Employees on Employees.EmployeeID = Orders.EmployeeID
where Employees.FirstName in('Nancy','Andrew','Janet') 
--federal Shipping ile taşınmış nancy nin vermiş olduğu siparişler
select o.OrderID,s.CompanyName,e.FirstName
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
join Employees e on o.EmployeeID = e.EmployeeID
where s.CompanyName = 'federal Shipping' and
e.FirstName = 'Nancy'

--şirket adında a geçen müşterilerin vermiş olduğu Nancy,Andrew ya da Janet tarafından alınmış siparişlerin Speedy Express ile taşınmamış sipaarişlere toplam ne kadarlık ödeme yaptım
SELECT s.CompanyName,
SUM(o.Freight) FROM Employees e
join Orders o on o.EmployeeID = e.EmployeeID
join Shippers s on s.ShipperID = o.ShipVia
join Customers c on c.CustomerID = o.CustomerID
WHERE e.FirstName IN('Nancy','Andrew','Janet')
AND c.CompanyName LIKE '%a%' 
AND s.CompanyName != 'Speedy Express'
group by s.CompanyName
--En çok ürün aldığımız toptancıyı ve ürün adetlerini yazdırınız
select top 5 p.SupplierID,s.CompanyName,COUNT(*) Miktar from Products p
join Suppliers s on s.SupplierID=p.SupplierID
group by p.SupplierID,s.CompanyName
order by Miktar desc
--ürünlerin sipariş miktarı 1200 ün üzerinde olanların adlarını ve sipariş miktarlarını

select p.ProductID,p.ProductName,
sum(od.Quantity)
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by p.ProductID,p.ProductName
having sum(od.Quantity) > 1200

--250 den fazla sipariş taşımış kargo firmalarının adları,telefon numaraları ve sipariş sayısı

select s.ShipperID,s.CompanyName,s.Phone,
count(*) Adet
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
group by s.ShipperID,s.CompanyName,s.Phone
having count(*)>250

----çalışanların adlarının  başına ünvanlarını yazınız
/*Mr. : bay
MRs.Ms. : Bayan
DR : Bay
*/
select
Ad =(case 
when TitleOfCourtesy in('Mr.','Dr.') then 'Bay '+Employees.FirstName
when TitleOfCourtesy in('Mrs.','Ms.') then 'Bayan '+Employees.FirstName
End
)
from Employees


--Ürünleri fiyatı pahalıda ucuza stokları küçükten büyüğe listeleyiniz(Ürün ad-Fiyat-Stok)

select ProductName, UnitPrice, UnitsInStock from Products
order by UnitPrice desc, UnitsInStock 

--Her bir kategoriye ait ürün adedi ve toplam ürün sayısı

SELECT c.CategoryID,COUNT(*) ÜRÜN_ADEDİ,SUM(UnitsInStock+UnitsOnOrder) TOPLAM_URUN_SAYISI FROM Categories c
join Products p on p.CategoryID = c.CategoryID
group by c.CategoryID

--ürünü olmayan tedarikçileri list
select s.CompanyName,p.ProductName from Suppliers s left join Products p on s.SupplierID=p.SupplierID where p.ProductName is null 
--ülkesi brazil olan müşterilerin fax nosu olmayan müşteriler
SELECT CustomerID, Country, Fax FROM Customers
WHERE Country ='Brazil' and Fax is null
--ülkesi brazil olan müşterilerin teslimat tarihi aynı gün olan müşteriler
select ShippedDate,c.Country,Count(*) from Orders o
join Customers c on o.CustomerID = c.CustomerID
where Country = 'Brazil'
group by ShippedDate,Country
having count(*) > 1
order by ShippedDate
--en az kazandıran şipariş 

select top 1 OrderId,SUM(Quantity*UnitPrice*(1-Discount)) from [Order Details]
group by OrderID
order by 2
--çalışanlar kaç yaşında işe başladı
select FirstName,DATEDIFF(YEAR,BirthDate,HireDate ) Yaş from Employees
order by 2
--Çalışanların ortalma yaşları
select AVG(DATEDIFF(YEAR, BirthDate, GETDATE())) AS CalisanlarinOrtalamaYaslari
from dbo.Employees
--
declare @max_date datetime
select @max_date = Max(OrderDate) from Orders

select AVG(DATEDIFF(YEAR, BirthDate,@max_date)) AS CalisanlarinOrtalamaYaslari
from dbo.Employees e
--hangi çalışanım hangi bölgeden sorumlu
select Firstname,t.TerritoryDescription from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
--Michael ve lauranın hemşerisi olan çalışanlar
declare @first_hemseri varchar(100)
set @first_hemseri = (SELECT City FROM Employees Where FirstName LIKE 'Michael')


declare @second_hemseri varchar(100)
set @second_hemseri = (SELECT City FROM Employees Where FirstName LIKE 'Laura')

SELECT FirstName,City FROM Employees
WHERE City IN(@first_hemseri,@second_hemseri)
---
SELECT FirstName,City FROM Employees
WHERE City IN( 
(select City From Employees 
Where FirstName IN('Michael','Laura')))
--Mexico D.F' da ikamet eden şirket sahibi müşteriler
select c.CompanyName from Customers c
where city = 'México D.F.' and c.ContactTitle='owner'
--restaurant olan müşteriler
select CompanyName from Customers
where  CompanyName like '%restaurant%' or  CompanyName like '%gastr%'
--en uzun isimli müşterim 
select top 1 CompanyName,len(CompanyName) from Customers
order by len(CompanyName) desc