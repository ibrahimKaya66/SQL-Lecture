
--System Function
--Aggregate Function
/*
1-Min
2-Max
3-Avg
4-Count
5-Sum
*/
create table Products
(
ProductId int identity(1,1),
ProductName varchar(50),
UnitPrice money,
Quantity smallint,
constraint PK_PID primary key(ProductId)
)
insert Products
values('Iphone',5500,3),
('Samsung',4300,5),
('Tv',7500,1),
('Laptop',12000,4),
('PS',8800,2)

select 
MIN(UnitPrice) [Min Fiyat] ,
Max(UnitPrice) Max_Fiyat,
avg(UnitPrice) 'Ortalama Fiyat',
COUNT(*) Adet,
Sum(UnitPrice) [Toplam Fiyat]
from Products


--Ortalama fiyat dan yüksek olan ürünlerinin adı ve fiyatını listeleyiniz
Select ProductName,UnitPrice from Products 
where UnitPrice > ( select avg(UnitPrice) from Products)

--Matematiksel Fonksiyonlar
/*
1-Abs ->mutlak değeri alır
2-Pi -> pi sayısını verir.
3-Power->üs alır
4-Round -> ondalıklı değeri yuvarlar
5-Sign ->işaretini verir
6-isnumeric -> sayı mı kontrol edilir
7-Sqrt -> karekök alır
8-Square -> karesini alır
*/


select 
ABS(-30),ROUND(PI(),2),POWER(5,2),CEILING(PI()),FLOOR(PI())
SELECT
LOG10(100),RAND(),SIGN(-5),SQRT(81),SQUARE(5),ISNUMERIC(234234)


--String Metotlar
/*
1-ASCII ->Ascii kodu verir
2-Char -> ascii kodun karakterini verir
3-Charindex -> karakterin indexi verir
4-Patindex -> kelimenin indexini verir
5-Difference -> iki kelimenin ortak sayısını verir
6-Left ->soldan kaç karakter alıcağını söyler
7-Right -> sağdan kaç karakter alıcağını söyler
8-Len -> kelimenin uzunluğunu verir
9-Lower->Kelimeyi küçük harfe çevirir
10- Upper ->Kelimeyi büyük harfe çevirir
11-Ltrim,Rtrim -> Soldan/Sağdan boşluk siler
12-Space -> boşluk bırakır
13-Replace -> ilgili karakteri bulur karakteri değiştirir
14-Reverse -> kelimeyi ters çevirir
15-Replicate->Girilen karakteri tekrar ettirir.
16-Substring ->kelimede belirli karaktere kadar alır.
17-string_Split -> ilgili karaktere göre ayrıştırır
18-Stuff -> ilgili karakteri bulur karakteri değiştirir
*/

select ASCII('A'),
CHAR(97),
CHARINDEX('i','İbrahim'),
CHARINDEX('i','İbrahim',4),
PATINDEX('%im','ibrahim'),
left('ibrahim',4),right('ibrahim',4),
len('ibrahim')
select
lower('IBRAhIm'),Upper('AsAsAd'),LTRIM('       ibrahim'),
RTRIM('ibrahim' + space(50))+'x',
REPLACE('ibr1him','1','a'),
Stuff('ibrahim',2,3,'abc'),REVERSE('ibrahim'),
REPLICATE('ibrahim ',3),SUBSTRING('ibrahim',2,3)

select value from string_split('bu metin boşluklarla ayrılmıştır',' ')

--Tarih ve Zaman Fonk
/*
1-getdate() -> şuanki tarihi getirir
2-getutcdate() ->utc tarihini getirir
3-day(),Month(),Year()->günü,ayı,yılı verir
 -interval : day,month,year,hour,week,...
4-datediff : tarih farkını verir
5-dateadd : tarih ekler
6-datename : tarihin adını verir
7-datepart:tarihin interval değerini verir
8-isdate : girilen metinin  tarih olup olmadığına bakar

*/

select getdate(),GETUTCDATE(),SYSDATETIME(),
day('1993-11-03'),MONTH('19931103'),YEAR('1993/11/03'),
day('1993.11.03'),MONTH(getdate()),DATEDIFF(WEEK,'1993-11-03',getdate()),
DATEADD(week,6,getdate())
select DATEADD(day,-15,GETDATE()),
datename(WEEKDAY,getdate()),datename(MONTH,getdate()),
DATEPART(WEEK,getdate()),DATEPART(WEEKday,getdate()),
ISDATE('03111999'),ISDATE('19991213')

--Convert Metotlar
/*
1-convert ->convert(type,value1)
--data-style 1 den 120 
2-Cast-->cast(valu1 as datatype)
*/

select cast(12.12 as int),cast(GETDATE() as varchar)
select convert(int,12.12),convert(varchar,getdate()),
convert(varchar,getdate(),6),convert(varchar,getdate(),106)

--isnull ve coalesce

select ISNULL(yas,0) from Students
select ISNULL(Name_,'Adı girilmemiş') from Students
select * from Students
select coalesce(Name_,Surname,'Hepsi boş') from Students

select coalesce('Ad : '+Name_,
'Soyad : '+Surname,
'Yas : '+cast(Yas as varchar),
'hepsi boş'
) from Students