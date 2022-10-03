--Views(Sanal Tablolar)
alter view vw_Freight
--with encryption
as
select s.ShipperID, s.CompanyName, sum(o.Freight) [Total Freight]
from Shippers s
join Orders o on s.ShipperID = o.ShipVia
where (s.ShipperID = 1 or s.ShipperID = 3) and (Year(o.OrderDate) = 1996) and (datename(weekday,o.OrderDate) = 'Thursday') 
group by s.ShipperID, s.CompanyName


select * from vw_Freight


create view vw_products
as
select ProductID,ProductName from Products
with check option--crud işlemine yarar


insert vw_products
values('ibrahim')

select * from vw_products
order by 1


--categori adı-kıtaadı(ürünün tedarikçi kıtası)-toplam stoğunu yazdıran viewı yazınız.view şifreleme ve cruda açık olsun
create view vw_continent
with encryption
as
select c.CategoryName,
Kıta = (
case 
when s.Country in('USA','Brazil','Canada') then 'America'
when s.Country in ('Japan','Singapore') then 'Asya'
else 'Europe'
end
),
sum(p.UnitsInStock) Toplam_Stok
from Suppliers s
join Products p on p.SupplierID = s.SupplierID
join Categories c on p.CategoryID = c.CategoryID
group by c.CategoryName,
case 
when s.Country in('USA','Brazil','Canada') then 'America'
when s.Country in ('Japan','Singapore') then 'Asya'
else 'Europe'
end
with check option

--süre olayını anlatılacak
set statistics time on

alter view vw_deneme
as
select * from Orders
where OrderID  = 10248

select * from vw_deneme


set statistics time off


--view silme
drop view vw_deneme


--yedek tablo anlatılacak
select ProductID,ProductName
into UrunIDveAdi
from Products