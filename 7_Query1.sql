/*
Norhtwind
1-Categories : Categoriler
2-Customers :Müşteriler
3-Employees : Çalışanlar
4-Territories : Eyalet
5-Region : Bölge(Kuzey,Güney,Doğu, Batı)
6-Orders : Siparişler
7-Order Details : Sipariş Detayı
8-Products : Ürünler
9-Suppliers : Tedarikçiler
10-Shippers : Nakliyeciler(Kargo Şirketleri)
*/

--bulunduğumuz ayda  doğan çalışanları listeleyiniz.
Select concat(FirstName,space(1),LastName) [Name],BirthDate from Employees
where MONTH(BirthDate) = MONTH(GETDATE())

--Hangi çalışanım kime rapor veriyor 


select 
CONCAT(e1.FirstName,space(1),e1.LastName) Çalışan,
CONCAT(e2.FirstName,space(1),e2.LastName)
[Rapor verdiği]
from Employees e1
join Employees e2 on e1.ReportsTo = e2.EmployeeID

--Tüm Cirom ne kadar?
select 
Round(sum(UnitPrice*Quantity*(1-Discount)),2) 
Ciro
from [Order Details]

--Çalışanların yaptığı cirolar büyükten küçükten çalışanın adı soyadı ve cirosunu getirir
select e.EmployeeID,
CONCAT(e.FirstName,space(1),e.LastName) Çalışan,
Round(sum(UnitPrice*Quantity*(1-Discount)),2) 
Ciro
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Employees e on o.EmployeeID = e.EmployeeID
group by e.EmployeeID,e.FirstName,e.LastName
order by Ciro desc

--Hangi ülkelerde müşterim var
select Distinct Country from Customers
--Hangi ülkelere sipariş verdim
select Distinct ShipCountry from Orders
Order by 1

--Sipariş geçmediğim müşterileri listeleyiniz
select o.OrderID,c.CustomerID from Orders o
right join Customers c on o.CustomerID = c.CustomerID
where o.OrderID is null
--2.yol A/B except
select CustomerID from Customers
except
select CustomerID from Orders

--Her üründen yaptığım siparişlerde toplam adet ve ciro
--ürün ıd ,ürünadı toplam edet toplam ciro


select od.ProductID,
p.ProductName,
sum(od.Quantity) Adet,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by od.ProductID,p.ProductName
having Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) > 10000
order by 1
--Categoriye ait satış adetleri ve ciroları
select c.CategoryID,c.CategoryName,
sum(od.Quantity) Adet,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from [Order Details] od
join Products p on od.ProductID = p.ProductID
join Categories c on p.CategoryID = c.CategoryID
group by c.CategoryID,c.CategoryName

--Çalışanlara göre satış adetleri ve ciroları
select 
e.EmployeeID,
CONCAT(e.FirstName,space(1),e.LastName) Çalışan,
sum(od.Quantity) Adet,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Employees e on o.EmployeeID = e.EmployeeID
group by e.EmployeeID,e.FirstName,e.LastName
order by Ciro
--Çalışanların ürün bazlı satış adetleri ve ciroları
select 
CONCAT(e.FirstName,space(1),e.LastName) Çalışan,
p.ProductName,
sum(od.Quantity) Adet,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Products p on od.ProductID = p.ProductID
join Employees e on o.EmployeeID = e.EmployeeID
group by e.EmployeeID,e.FirstName,e.LastName,
		p.ProductName
		order by 1,2
--Hangi kargo şirketine ne kadar ödeme yapmışım,kaç adet siparişten ortalama ne kadar ödeme yapmışım
select s.CompanyName,
count(*) Adet,
Avg(o.Freight) [ortalama ücret],
sum(o.Freight) [toplam ücret]
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
group by s.CompanyName
order by 1

--Toast yapmayı seven çalışan hangisidir?
select 
CONCAT(FirstName,space(1),LastName) Çalışan,
SUBSTRING(Notes,Patindex('%toast%',Notes),Len('Toast'))  Note
from Employees 
where Notes like '%toast%'

--Hangi tedarikçiden aldığım ürünlerden ne kadarlık ciro yapmışım
select 
s.CompanyName,
p.ProductName,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from Products p
join Suppliers s on p.SupplierID = s.SupplierID
join [Order Details] od on p.ProductID = od.ProductID
group by s.SupplierID,s.CompanyName,p.ProductID,p.ProductName
order by 1,2

--En çok gelir getiren müşterimi  bulunuz
select top 1 c.CustomerID,c.CompanyName,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Customers c on o.CustomerID = c.CustomerID
group by c.CustomerID,c.CompanyName
order by Ciro desc
--Hangi ülkeye ne kadarlık satış yapmışım(ciro)
select o.ShipCountry,
Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) 
Ciro
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
group by o.ShipCountry
order by 1
--zamanında teslim edilmeyen siparişleri ve ne kadar geciktiğini gün bazlı yazınız
select OrderID,
DATEDIFF(day,RequiredDate,ShippedDate) [Gecikme Suresi]
from Orders
where ShippedDate> RequiredDate
order by 2
--zamanında teslim edilen siparişleri ve teslim tarihinden kaç gün önce teslim edildi bulunuz,siparişten kaç gün sonra teslim edildiğini de listeleyiniz.
select OrderID,
DATEDIFF(day,OrderDate,ShippedDate) [Siparişten Kaç gün Sonra gönderildiği],
DATEDIFF(day,ShippedDate,RequiredDate) [İstenilen Tarihten kaç gün önce gönderildiği]
from Orders
where RequiredDate> ShippedDate
order by 2
--ortalama satış miktarının üzerindeki satışları listeleyiniz.ortalama satış miktarını değişkende tutunuz
declare @avg_quantity int
select @avg_quantity = avg(Adet) 
from
(select OrderID,sum(Quantity) Adet from [Order Details] 
group by OrderID) Table_

select OrderID,sum(Quantity) from [Order Details]
group by OrderID
having sum(Quantity) > @avg_quantity
order by 2