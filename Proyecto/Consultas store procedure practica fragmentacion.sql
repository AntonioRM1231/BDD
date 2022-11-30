--a
DROP PROCEDURE consulta_h;
GO
go 
create procedure consulta_a @cat int as 
begin
select soh.TerritoryID, sum(sod.linetotal) as VentasTotales
from PC7.AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join PC7.AdventureWorks2019_1.sales.SalesOrderHeader soh
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
	from PC7.PC7.AdventureWorks2019_1.sales.SalesOrderDetail sod
	inner join PC7.PC7.AdventureWorks2019_1.Sales.SalesOrderHeader soh
	on sod.SalesOrderID=soh.SalesOrderID
		where soh.TerritoryID in(
			select TerritoryID from PC7.PC7.AdventureWorks2019_1.sales.SalesTerritory
			where "Group"=@region
		)
	group by sod.ProductID, soh.TerritoryID
	order by ventas desc
end
execute consulta_b @region='Europe'

--c
select * from PC8.AdventureWorks2019_2.Production.ProductSubcategory
select * from PC8.AdventureWorks2019_2.Production.ProductInventory
go 
CREATE PROCEDURE consulta_c (@categoria int, @localidad int) as
begin
	update PC8.AdventureWorks2019_2.Production.ProductInventory
	set Quantity = Quantity*1.05
	where LocationID = @localidad
	and ProductID in(select ProductID
					from PC8.AdventureWorks2019_2.Production.Product
					where ProductSubcategoryID in (
					select ProductSubcategoryID
					from PC8.AdventureWorks2019_2.production.ProductSubcategory
					where ProductCategoryID = @categoria
					))
end
execute consulta_c @categoria=2, @localidad = 60
--c prima
go
create procedure consulta_c2 as
begin
	select * from PC8.AdventureWorks2019_2.Production.ProductInventory
end
execute consulta_c2



--d
go
create procedure consulta_d @territorio int as
 begin
  if exists(
	select (c.CustomerID) CIDc , (c.TerritoryID) TIDc,(soh.CustomerID) CIDs , (soh.TerritoryID) TIDs  
	from PC7.AdventureWorks2019_1.Sales.Customer c 
	inner join PC7.AdventureWorks2019_1.Sales.SalesOrderHeader soh
	on c.CustomerID =soh.CustomerID and c.TerritoryID<>soh.TerritoryID
	where  c.TerritoryID= @territorio

	)
	PRINT ' si hay clientes'
	ELSE 
	PRINT ' no hay clientes'
 end
execute consulta_d @territorio = 8

go
create procedure sp_p1_4 @territorio int as
 begin
	select (c.CustomerID) CIDc , (c.TerritoryID) TIDc,(soh.CustomerID) CIDs , (soh.TerritoryID) TIDs  
	from PC7.AdventureWorks2019_1.Sales.Customer c 
	inner join PC7.AdventureWorks2019_1.Sales.SalesOrderHeader soh
	on c.CustomerID =soh.CustomerID and c.TerritoryID<>soh.TerritoryID
	where  c.TerritoryID= @territorio
 end
 execute sp_p1_4 @territorio = 8
--e
go
create procedure consulta_e
(@OrdenId int, 
 @ProductId int,
 @Cantidad smallint
 ) as
 begin
 if exists(select productid
            from PC7.AdventureWorks2019_1.sales.SalesOrderDetail
            WHERE productid = @ProductId and 
                  SalesOrderID = @OrdenId
 )
 update PC7.AdventureWorks2019_1.sales.SalesOrderDetail
 set OrderQty = @Cantidad
 WHERE ProductID=@ProductId and SalesOrderID = @OrdenId
 ELSE 
 PRINT 'Orden o Producto no encontrado'
 end
 -- EJECUTAR EL PROCEDIMIENTO 
 EXECUTE consulta_e @productId = 776, @OrdenId = 43659, @Cantidad = 4--1

--f
go
create procedure consulta_f
(@shipMethodID int, 
 @salesorderID int
 ) as
 begin
 if exists(select soh.SalesOrderID
            from PC7.AdventureWorks2019_1.sales.SalesOrderheader soh
            WHERE SalesOrderID= @salesorderID 
		 )
 update PC7.AdventureWorks2019_1.sales.SalesOrderHeader
 set ShipMethodID = @shipMethodID
 WHERE SalesOrderID=@salesorderID 
 ELSE 
 PRINT 'SalesOrderID no encontrado'
 end
 -- EJECUTAR EL PROCEDIMIENTO 
 EXECUTE consulta_f @shipMethodID = 4, @SalesOrderID = 43659--1

select * 
from AdventureWorks2019.sales.SalesOrderHeader
--g
--h
go
create procedure consulta_h @territorio int as
begin
	select top 1 SalesPersonID, COUNT(SalesPersonID)Ordenes, TerritoryID from PC7.AdventureWorks2019_1.Sales.SalesOrderHeader
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
	from PC7.AdventureWorks2019_1.sales.SalesOrderHeader soh
	inner join PC7.AdventureWorks2019_1.sales.SalesOrderDetail sod
	on soh.SalesOrderID = sod.SalesOrderID
	inner join PC7.AdventureWorks2019_1.sales.SalesTerritory sst
	on soh.TerritoryID = sst.TerritoryID
		where OrderDate between @fecha_1 AND @fecha_2
	group by sst."Group"
end
execute consulta_i @fecha_1 = '2011-05-01', @fecha_2 = '2011-05-31'
--j
go
create procedure consulta_j @fecha_1 datetime, @fecha_2 datetime as
begin
select  top 5 sod.ProductID,sum(sod.LineTotal) ventas
from PC7.AdventureWorks2019_1.Sales.SalesOrderHeader soh
inner join PC7.AdventureWorks2019_1.sales.SalesOrderDetail sod
on soh.SalesOrderID = sod.SalesOrderID
where  OrderDate BETWEEN  @fecha_1 AND @fecha_2
group by sod.ProductID
order by ventas asc
end

execute consulta_j @fecha_1 = '2011-05-01', @fecha_2 = '2011-05-31'
