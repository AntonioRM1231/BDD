--a
DROP PROCEDURE consulta_h;
GO
go 
create procedure consulta_a @cat int as 
begin
select soh.TerritoryID, sum(sod.linetotal) as VentasTotales
from AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join AdventureWorks2019_1.sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where sod.ProductID in (
    select ProductID
	from AdventureWorks2019_2.Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
		 from AdventureWorks2019_2.Production.ProductSubcategory
         where ProductCategoryID = @cat
       )
    )
group by soh.TerritoryID
end 
execute consulta_a @cat=4

--b
go 
create procedure consulta_b @region nvarchar(50) as 
begin
	select top 1 sod.ProductID, soh.TerritoryID,sum(sod.LineTotal)as ventas 
	from AdventureWorks2019_1.sales.SalesOrderDetail sod
	inner join AdventureWorks2019_1.Sales.SalesOrderHeader soh
	on sod.SalesOrderID=soh.SalesOrderID
		where soh.TerritoryID in(
			select TerritoryID from AdventureWorks2019_1.sales.SalesTerritory
			where "Group"=@region
		)
	group by sod.ProductID, soh.TerritoryID
	order by ventas desc
end
execute consulta_b @region='Europe'

--c
go 
CREATE PROCEDURE consulta_c (@categoria int, @localidad int) as
begin
	update AdventureWorks2019_2.Production.ProductInventory
	set Quantity = Quantity*1.05
	where LocationID = @localidad
	and ProductID in(select ProductID
					from AdventureWorks2019_2.Production.Product
					where ProductSubcategoryID in (
					select ProductSubcategoryID
					from AdventureWorks2019_2.production.ProductSubcategory
					where ProductCategoryID = @categoria
					))
end
execute consulta_c @categoria=1, @localidad = 1

--d
go
create procedure consulta_d @territorio int as
 begin
  if exists(
	select (c.CustomerID) CIDc , (c.TerritoryID) TIDc,(soh.CustomerID) CIDs , (soh.TerritoryID) TIDs  
	from AdventureWorks2019_1.Sales.Customer c 
	inner join AdventureWorks2019_1.Sales.SalesOrderHeader soh
	on c.CustomerID =soh.CustomerID and c.TerritoryID<>soh.TerritoryID
	where  c.TerritoryID= @territorio

	)
	PRINT ' si hay clientes'
	ELSE 
	PRINT ' no hay clientes'
 end
execute consulta_d @territorio = 8
--e
/*para actualizar, se reciben 3 numero de orden, numero de producto, y la cantidad a actualizar*/
--f
--g
--h
go
create procedure consulta_h @territorio int as
begin
	select top 1 SalesPersonID, COUNT(SalesPersonID)Ordenes, TerritoryID from AdventureWorks2019_1.Sales.SalesOrderHeader
	where TerritoryID = @territorio
	group by SalesPersonID,TerritoryID
	order by Ordenes desc
end
execute consulta_h @territorio= 5
--i
go
create procedure consulta_i @fecha_1 datetime, @fecha_2 datetime as
begin
	select sst."Group", sum(sod.LineTotal) as ventas
	from AdventureWorks2019_1.sales.SalesOrderHeader soh
	inner join AdventureWorks2019_1.sales.SalesOrderDetail sod
	on soh.SalesOrderID = sod.SalesOrderID
	inner join AdventureWorks2019_1.sales.SalesTerritory sst
	on soh.TerritoryID = sst.TerritoryID
		where OrderDate between @fecha_1 AND @fecha_2
	group�by�sst."Group"
end
execute consulta_i @fecha_1 = '2011-05-01', @fecha_2 = '2011-05-31'
--j
go
create procedure consulta_j @fecha_1 datetime, @fecha_2 datetime as
begin
select  top 5 sod.ProductID,sum(sod.LineTotal) ventas
from AdventureWorks2019_1.Sales.SalesOrderHeader soh
inner join AdventureWorks2019_1.sales.SalesOrderDetail sod
on soh.SalesOrderID = sod.SalesOrderID
where  OrderDate BETWEEN  @fecha_1 AND @fecha_2
group by sod.ProductID
order by ventas asc
end

execute consulta_j @fecha_1 = '2011-05-01', @fecha_2 = '2011-05-31'