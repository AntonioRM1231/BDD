
--servidores

-- variable @cat es el argumento de entrada que
-- corresponde a la categoría del producto
-- Se realiza un inner join para acceder a los
-- territorios y calcular mediante una suma
-- el total de las ventas que se encuentra en 
-- salesorderdetail.
select soh.TerritoryID, sum(sod.linetotal)
-- Sintaxis del from para el escenario que la consulta
-- se ejecute desde el servidor 1
-- from sales.SalesOrderDetail sod 
-- Sintaxis del from para el escenario de que la consulta
-- se ejkecute desde el servidor 2
from AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join AdventureWorks2019_1.sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
-- Se localiza la categoria del producto 
-- a considerar en la suma. La categpria se
-- accede mediante la tabla producto y la columna
-- productSubcategory y a su vez se evalúa la
-- variable @cat con la columna productCategory
-- de la tabla productSubcategory
where sod.ProductID in (
    select ProductID
    -- Sintaxis del from para el escenario que la consulta
    -- se ejecute desde el servidor 1
    -- from SRV2.Production.Product

 

    -- Sintaxis del from para el escenario que la consulta
    -- se ejecute desde el servidor 2
    from Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
         -- Sintaxis del from para el escenario que la consulta
         -- se ejecute desde el servidor 1
         -- from SRV2.Production.ProductSubcategory
         -- Sintaxis del from para el escenario que la consulta
         -- se ejecute desde el servidor 2
         from Production.ProductSubcategory
         where ProductCategoryID = 4
       )
    )
group by soh.TerritoryID

select	* from Production.ProductCategory

--Creacion de procedimiento almacenado 
go 
create procedure sp_p1_1 @cat int as 
begin
select soh.TerritoryID, sum(sod.linetotal) ventas
from AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join AdventureWorks2019_1.sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where sod.ProductID in (
    select ProductID
	from Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
		 from Production.ProductSubcategory
         where ProductCategoryID = @cat
       )
    )
group by soh.TerritoryID
end 
execute sp_p1_1 @cat=4

--Consulta b
select top 1 sod.ProductID, soh.TerritoryID,sum(sod.LineTotal)as ventas 
from AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join AdventureWorks2019_1.Sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
	where soh.TerritoryID in(
		select TerritoryID from AdventureWorks2019_1.sales.SalesTerritory
		where "Group"='Europe'
	)
group by sod.ProductID, soh.TerritoryID
order by ventas desc

go 
create procedure sp_p1_2 @reg nvarchar(50) as 
begin
select top 1 sod.ProductID, soh.TerritoryID,sum(sod.LineTotal)as ventas 
from AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join AdventureWorks2019_1.Sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
	where soh.TerritoryID in(
		select TerritoryID from AdventureWorks2019_1.sales.SalesTerritory
		where "Group"=@reg
	)
group by sod.ProductID, soh.TerritoryID
order by ventas desc
end
execute sp_p1_2 @reg='North America'
--Consulta c
--Consulta d 


select (c.CustomerID) CIDc , (c.TerritoryID) TIDc,(soh.CustomerID) CIDs , (soh.TerritoryID) TIDs  
from Sales.Customer c 
inner join Sales.SalesOrderHeader soh
on c.CustomerID =soh.CustomerID and c.TerritoryID<>soh.TerritoryID
where  c.TerritoryID= 4

select sohh.CustomerID, sc.TerritorioCustomer, sc.TerritorioHeader
from Sales.SalesOrderHeader sohh
inner join (select c.CustomerID,(c.TerritoryID) TerritorioCustomer,(soh.TerritoryID) TerritorioHeader
from sales.customer c
inner join sales.SalesOrderHeader soh
on c.TerritoryID = soh.TerritoryID
where c.TerritoryID=5) as sc
on sohh.CustomerID = sc.CustomerID

--Consulta e
--Consulta f
--Consulta g
--Consulta h 

select * from Person.Person
select * from Person.BusinessEntity
select * from Sales.SalesOrderDetail
where SalesOrderID=43659
select * from Sales.SalesOrderHeader
where CustomerID=2
select * from Sales.SalesTerritory
where CustomerID=29825
select BusinessEntityID,SalesPersonID from Sales.Store

select top 1 SalesPersonID, COUNT(SalesPersonID)Ordenes, TerritoryID from Sales.SalesOrderHeader
where TerritoryID = 5
group by SalesPersonID,TerritoryID
order by Ordenes desc

--Consulta i
--Consulta j
select  top 5 sod.ProductID,sum(sod.LineTotal) ventas
from Sales.SalesOrderHeader soh
inner join sales.SalesOrderDetail sod
on soh.SalesOrderID = sod.SalesOrderID
where  OrderDate BETWEEN '2011-05-01' AND '2011-05-31'
group by sod.ProductID
order by ventas asc


