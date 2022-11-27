 consulta inciso a del proyecto -- variable @cat es el argumento de entrada que
-- corresponde a la categoría del producto
-- Se realiza un inner join para acceder a los
-- territorios y calcular mediante una suma
-- el total de las ventas que se encuentra en
-- salesorderdetail.
select soh.TerritoryID, sum(sod.linetotal)
from sales.SalesOrderDetail sod
inner join sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
-- Se localiza la categoria del producto
-- a considerar en la suma. La categpria se
-- accede mediante la tabla producto y la columna
-- productSubcategory y a su vez se evalúa la
-- variable @cat con la columna productCategory
-- de la tabla productSubcategory
where sod.ProductID in (
    select ProductID
    from Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
         from Production.ProductSubcategory
         where ProductCategoryID = 4
       )
    )
group by soh.TerritoryID


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
select soh.TerritoryID, sum(sod.linetotal)
from AdventureWorks2019_1.sales.SalesOrderDetail sod
inner join AdventureWorks2019_1.sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where sod.ProductID in (
    select ProductID
	from Production.Product
    where ProductSubcategoryID in (
         select ProductSubcategoryID
		 from Production.ProductSubcategory
         where ProductCategoryID = 4
       )
    )
group by soh.TerritoryID
end 
execute sp_p1_1 @cat=4