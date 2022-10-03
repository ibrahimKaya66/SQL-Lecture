select * from Persons p
join Addresses a on p.AddressID = a.ID

select * from Persons p
inner join Addresses a on p.AddressID = a.ID

select * from Persons p
left join Addresses a on p.AddressID = a.ID

select * from Persons p
left outer join Addresses a on p.AddressID = a.ID

select * from Persons p
right join Addresses a on p.AddressID = a.ID

select * from Persons p
right outer join Addresses a on p.AddressID = a.ID

select * from Persons p
full outer join Addresses a on p.AddressID = a.ID

select * from Persons p
full join Addresses a on p.AddressID = a.ID

--group by 
select Name_,Avg(AddressID),Count(*) from Persons
group by Name_
order by 1

select AddressID,Count(*) from Persons
--where AddressID = 1
where  count(*) > 1
group by AddressID
--having count(*) > 1
--having AddressID = 1
order by 1