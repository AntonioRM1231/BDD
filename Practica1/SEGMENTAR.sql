--EQUIPO 11 
--RODRIGUEZ MARQUEZ JOSE ANTONIO
--SALTO CRUZ ANAHI
--1 USAR LA BASE COVIDHISTORICO
use covidHistorico

--2 CREAR UNA TABLA DE ENTIDADES
create table dbo.cat_entidades (
  clave varchar(3),
  entidad varchar(150),
  abreviatura varchar(3)
)

--3 INSERTAR EL NOMBRE DE LAS ENTIDADES
insert into cat_entidades values ('01','AGUASCALIENTES','AS')
insert into cat_entidades values ('02','BAJA CALIFORNIA','BC')
insert into cat_entidades values ('03','BAJA CALIFORNIA SUR','BS')
insert into cat_entidades values ('04','CAMPECHE','CC')
insert into cat_entidades values ('05','COAHUILA DE ZARAGOZA','CL')
insert into cat_entidades values ('06','COLIMA','CM')
insert into cat_entidades values ('07','CHIAPAS','CS')
insert into cat_entidades values ('08','CHIHUAHUA','CH')
insert into cat_entidades values ('09','CIUDAD DE MÉXICO','DF')
insert into cat_entidades values ('10','DURANGO','DG')
insert into cat_entidades values ('11','GUANAJUATO','GT')
insert into cat_entidades values ('12','GUERRERO','GR')
insert into cat_entidades values ('13','HIDALGO','HG')
insert into cat_entidades values ('14','JALISCO','JC')
insert into cat_entidades values ('15','MÉXICO','MC')
insert into cat_entidades values ('16','MICHOACÁN DE OCAMPO','MN')
insert into cat_entidades values ('17','MORELOS','MS')
insert into cat_entidades values ('18','NAYARIT','NT')
insert into cat_entidades values ('19','NUEVO LEÓN','NL')
insert into cat_entidades values ('20','OAXACA','OC')
insert into cat_entidades values ('21','PUEBLA','PL')
insert into cat_entidades values ('22','QUERÉTARO','QT')
insert into cat_entidades values ('23','QUINTANA ROO','QR')
insert into cat_entidades values ('24','SAN LUIS POTOSÍ','SP')
insert into cat_entidades values ('25','SINALOA','SL')
insert into cat_entidades values ('26','SONORA','SR')
insert into cat_entidades values ('27','TABASCO','TC')
insert into cat_entidades values ('28','TAMAULIPAS','TS')
insert into cat_entidades values ('29', 'TLAXCALA','TL')
insert into cat_entidades values ('30','VERACRUZ DE IGNACIO DE LA LLAVE','VZ')
insert into cat_entidades values ('31','YUCATÁN','YN')
insert into cat_entidades values ('32','ZACATECAS','ZS')
insert into cat_entidades values ('36','ESTADOS UNIDOS MEXICANOS','EUM')
insert into cat_entidades values ('97','NO APLICA','NA')
insert into cat_entidades values ('98','SE IGNORA','SI')
insert into cat_entidades values ('99','NO ESPECIFICADO','NE')

--4 COMPROBAR LA CREACION DE LA TABLA
select * from covidHistorico.dbo.cat_entidades

--5 Segmentación /*REGION NOROESTE*/
create database region_noroeste

--6
use region_noroeste

--7
select * into datoscovid
from covidHistorico.dbo.datoscovid 
where entidad_res in (
                      select clave
					  from covidHistorico.dbo.cat_entidades
					  where entidad in ('BAJA CALIFORNIA',
					  'BAJA CALIFORNIA SUR','CHIHUAHUA',
		              'SINALOA','SONORA'))

--8 Segmentación /*REGION NORESTE*/
create database region_noreste

--9
use region_noreste

--10 creamos la data datoscovid dentro de la region noreste
select * into datoscovid
from covidHistorico.dbo.datoscovid 
where entidad_res in (
                      select clave
					  from covidHistorico.dbo.cat_entidades
					  where entidad in ('COAHUILA DE ZARAGOZA',
					  'DURANGO','NUEVO LEÓN',
		              'SAN LUIS POTOSÍ','TAMAULIPAS'))

--11 /*REGION CENTRO*/
create database region_centro

--12
use region_centro

--13
select * into datoscovid
from covidHistorico.dbo.datoscovid 
where entidad_res in (
                      select clave
					  from covidHistorico.dbo.cat_entidades
					  where entidad in ('Ciudad de México',
					  'México','Guerrero',
		              'Hidalgo','Morelos','Puebla','Tlaxcala'))

/*REGION occidente*/
create database region_occidente

use region_occidente

select * into datoscovid
from covidHistorico.dbo.datoscovid 
where entidad_res in (
                      select clave
					  from covidHistorico.dbo.cat_entidades
					  where entidad in ('AGUASCALIENTES',
					  'COLIMA','GUANAJUATO',
		              'JALISCO','MICHOACÁN DE OCAMPO','NAYARIT','QUERÉTARO','ZACATECAS'))


/*REGION sureste*/
create database region_sureste

use region_sureste

select * into datoscovid
from covidHistorico.dbo.datoscovid 
where entidad_res in (
                      select clave
					  from covidHistorico.dbo.cat_entidades
					  where entidad in ('CAMPECHE',
					  'CHIAPAS','OAXACA',
		              'QUINTANA ROO','TABASCO','VERACRUZ DE IGNACIO DE LA LLAVE','YUCATÁN'))

/*1. Listar por entidad de residencia cuantos 
     casos confirmados / casos registrados por mes
	 de los años 2020 y 2021.
	 by Anahi Salto Cruz
*/



(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio)
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio)
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
order by A.ENTIDAD_RES, A.mes, A.anio


/*Creando vista de la consulta 1*/

use covidHistorico
create view consultaUno
as 
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio)
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio)
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)
--order by A.ENTIDAD_RES, A.mes, A.anio
UNION
(select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, B.total_registrados
from
(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid) as T
where CLASIFICACION_FINAL between 1 and 3
group by entidad_res, mes, anio)  as A
inner join
(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid) as T
group by entidad_res, mes, anio)  as B
on A.ENTIDAD_RES = B.ENTIDAD_RES and
   A.mes = B.mes and A.anio = B.anio)

   select * from consultaUno order by ENTIDAD_RES, mes, anio

/*
2. Determinar en que entidad de residencia y en 
   que mes se reportaron más casos confirmados.
   by Anahi Salto Cruz 
*/

select top 1 total_confirmados, mes, entidad_res
	from covidHistorico.dbo.consultaUno
	order by total_confirmados desc;

/*
3. Determinar cuantos casos fueron atendidos en 
   entidades distintas a la entidad de residencia.
   by Jose Antonio Rodriguez Marquez
*/
select sum(C.casos_distintos) casos_distintos_totales from
(select count(*) as casos_distintos	
from region_noroeste.dbo.datoscovid
where entidad_um != entidad_res
union
select count(*) as casos_distintos
from region_noreste.dbo.datoscovid
where entidad_um != entidad_res
union
select count(*) as casos_distintos
from region_centro.dbo.datoscovid
where entidad_um != entidad_res
union
select count(*) as casos_distintos
from region_occidente.dbo.datoscovid
where entidad_um != entidad_res
union
select count(*) as casos_distintos
from region_sureste.dbo.datoscovid
where entidad_um != entidad_res) as C
/*
4. Determinar la evolución de la pandemia 
   (casos registrados / casos sospechosos / 
   casos confirmados por mes) en cada una de las entidades 
   del país. Esta información permitirá identificar
   los picos de casos en las diferentes olas de contagio
   registradas.
   by Jose Antonio Rodriguez Marquez 
*/
select U.entidad_res,U.mes,U.anio,U.casos_registrados,W.casos_confirmados,Y.casos_sospechosos
from
(select S.entidad_res,S.mes,S.anio,count(*) as casos_registrados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid)as S
	   group by entidad_res,mes,anio)as U
left join
(select V.entidad_res,V.mes,V.anio,count(*) as casos_confirmados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid)as V
	   where CLASIFICACION_FINAL between 1 and 3
	   group by entidad_res,mes,anio)AS W
on U.ENTIDAD_RES = W.ENTIDAD_RES AND
   U.mes = W.mes AND U.anio =W.anio
left join
(select X.entidad_res,X.mes,X.anio,count(*) as casos_sospechosos
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noroeste.dbo.datoscovid)as X
	   where CLASIFICACION_FINAL = 6
	   group by entidad_res,mes,anio)AS Y
on U.ENTIDAD_RES = Y.ENTIDAD_RES AND
   U.mes = Y.mes AND U.anio =Y.anio

UNION 

select U.entidad_res,U.mes,U.anio,U.casos_registrados,W.casos_confirmados,Y.casos_sospechosos
from
(select S.entidad_res,S.mes,S.anio,count(*) as casos_registrados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid)as S
	   group by entidad_res,mes,anio)as U
left join
(select V.entidad_res,V.mes,V.anio,count(*) as casos_confirmados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid)as V
	   where CLASIFICACION_FINAL between 1 and 3
	   group by entidad_res,mes,anio)AS W
on U.ENTIDAD_RES = W.ENTIDAD_RES AND
   U.mes = W.mes AND U.anio =W.anio
left join
(select X.entidad_res,X.mes,X.anio,count(*) as casos_sospechosos
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_noreste.dbo.datoscovid)as X
	   where CLASIFICACION_FINAL = 6
	   group by entidad_res,mes,anio)AS Y
on U.ENTIDAD_RES = Y.ENTIDAD_RES AND
   U.mes = Y.mes AND U.anio =Y.anio

UNION

select U.entidad_res,U.mes,U.anio,U.casos_registrados,W.casos_confirmados,Y.casos_sospechosos
from
(select S.entidad_res,S.mes,S.anio,count(*) as casos_registrados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid)as S
	   group by entidad_res,mes,anio)as U
left join
(select V.entidad_res,V.mes,V.anio,count(*) as casos_confirmados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid)as V
	   where CLASIFICACION_FINAL between 1 and 3
	   group by entidad_res,mes,anio)AS W
on U.ENTIDAD_RES = W.ENTIDAD_RES AND
   U.mes = W.mes AND U.anio =W.anio
left join
(select X.entidad_res,X.mes,X.anio,count(*) as casos_sospechosos
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_centro.dbo.datoscovid)as X
	   where CLASIFICACION_FINAL = 6
	   group by entidad_res,mes,anio)AS Y
on U.ENTIDAD_RES = Y.ENTIDAD_RES AND
   U.mes = Y.mes AND U.anio =Y.anio

 UNION

 select U.entidad_res,U.mes,U.anio,U.casos_registrados,W.casos_confirmados,Y.casos_sospechosos
from
(select S.entidad_res,S.mes,S.anio,count(*) as casos_registrados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid)as S
	   group by entidad_res,mes,anio)as U
left join
(select V.entidad_res,V.mes,V.anio,count(*) as casos_confirmados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid)as V
	   where CLASIFICACION_FINAL between 1 and 3
	   group by entidad_res,mes,anio)AS W
on U.ENTIDAD_RES = W.ENTIDAD_RES AND
   U.mes = W.mes AND U.anio =W.anio
left join
(select X.entidad_res,X.mes,X.anio,count(*) as casos_sospechosos
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_occidente.dbo.datoscovid)as X
	   where CLASIFICACION_FINAL = 6
	   group by entidad_res,mes,anio)AS Y
on U.ENTIDAD_RES = Y.ENTIDAD_RES AND
   U.mes = Y.mes AND U.anio =Y.anio

UNION

select U.entidad_res,U.mes,U.anio,U.casos_registrados,W.casos_confirmados,Y.casos_sospechosos
from
(select S.entidad_res,S.mes,S.anio,count(*) as casos_registrados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid)as S
	   group by entidad_res,mes,anio)as U
left join
(select V.entidad_res,V.mes,V.anio,count(*) as casos_confirmados
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid)as V
	   where CLASIFICACION_FINAL between 1 and 3
	   group by entidad_res,mes,anio)AS W
on U.ENTIDAD_RES = W.ENTIDAD_RES AND
   U.mes = W.mes AND U.anio =W.anio
left join
(select X.entidad_res,X.mes,X.anio,count(*) as casos_sospechosos
from
(select id_registro, entidad_res, month(FECHA_INGRESO) mes,
              year(fecha_ingreso) anio, CLASIFICACION_FINAL
       from region_sureste.dbo.datoscovid)as X
	   where CLASIFICACION_FINAL = 6
	   group by entidad_res,mes,anio)AS Y
on U.ENTIDAD_RES = Y.ENTIDAD_RES AND
   U.mes = Y.mes AND U.anio =Y.anio

/*5. Determinar cuantos registros se repiten en la 
      base de datos, considerando las siguientes columnas: 
	  [ENTIDAD_UM],[SEXO],[ENTIDAD_NAC],[ENTIDAD_RES]
      ,[MUNICIPIO_RES],[EDAD],[NACIONALIDAD]      
      ,[HABLA_LENGUA_INDIG],[INDIGENA],[DIABETES]
      ,[EPOC],[ASMA],[INMUSUPR],[HIPERTENSION],[OTRA_COM]
      ,[CARDIOVASCULAR],[OBESIDAD],[RENAL_CRONICA]
      ,[TABAQUISMO],[OTRO_CASO],[MIGRANTE]
      ,[PAIS_NACIONALIDAD],[PAIS_ORIGEN]     

	  Ordenar los datos por entidad de residencia
	  by Anahi Salto Cruz
	  */

	select sum(Z.carry) registros_repetidos_totales
	FROM (
		 SELECT count(*) as carry
		 FROM covidHistorico.dbo.datoscovid
		 GROUP BY ENTIDAD_UM,SEXO,ENTIDAD_NAC,ENTIDAD_RES,MUNICIPIO_RES,EDAD,NACIONALIDAD,HABLA_LENGUA_INDIG, INDIGENA,DIABETES,EPOC,ASMA,
		 INMUSUPR,HIPERTENSION,OTRA_COM,CARDIOVASCULAR,OBESIDAD,RENAL_CRONICA,TABAQUISMO,OTRO_CASO,MIGRANTE,PAIS_NACIONALIDAD,PAIS_ORIGEN
		 HAVING COUNT(*)>1
		 ) as Z

/*------- CONCLUSIONES -------
Anahi Salto Cruz
Al realizar esta práctica, he notado de una manera más profunda la importancia de las Bases de Datos. Antes de esto, 
sabía de su importancia, pero no al grado de saber todo lo que se puede llegar a hacer. En el caso especial, de la 
base de datos del COVID-19, se tiene una BD muy grande, ya que como sabemos, fue y sigue siendo un suceso muy desafortunado 
para todo el mundo, sin embargo, el poder tener todos los datos concentrados, y mejor aún, conocer estadísticas reales, hace 
que tomemos más conciencia sobre este suceso. 
Hay que recordar que para poder manipular todos estos datos, se debe tener un gran conocimiento sobre las Bases de Datos, 
desde que se comienza a trabajar con ellas, para poder organizar de una manera eficiente la información, hasta el final que 
es hacer diversas consultas; cabe recalcar que esto último es de suma importancia, ya que de no ser por las consultas, no 
tendría mucho sentido hacer la BD, ya que lo importante es conocer la información, y sobre todo, que al hacer cualquier tipo 
de consulta sea correcta. 
Nosotros como telemáticos no podemos dar una respuesta falsa (por ejemplo, el resultado equivocado de una consulta solicitada). 
Por último, las consultas solicitadas en la práctica las sentí con un grado de dificultad un poco alta, sin embargo, son 
enriquecedoras y las veo cercanas a la realidad.

Jose Antonio Rodriguez Marquez 
Al trabajar con una base de datos muy grande, como lo es esta de "covidHistorico", las consultas suelen ocupar muchos recursos
de nuestros equipos, es por esta razon que se deben de realizar de manera eficiente y tomando en cuento esta desverntas, sin embargo
en lo que llevamos del curso se han aprendido algunas herramientas que se pueden implementar y solucionar estos problemas. 
Un ejemplo de esto es el algebra relacional que le permite al usuario ver a lastablas que componen a las bases de datos como conjuntos
con lo que se pueden operaciones como uniones, intersecciones, producto cartesiano, restas, divisiones, etc. Sin embargo hay que tomar 
en cuenta que muchas de las sentencias SQL que se ocupan para realizar estas pueden interferir con otras un ejemplo es al usar UNION,
que no permite integrar order by dentro de las consultas con las que trabajara. Ese fue el ejemplo mas claro que se pudo observar 
en la practica aunque la sentencia order by suele causar mas problemas, por ejemplo en la creacion y manejo de vistas, esto en
practica ya que, cuando se creo la vista de la consulta 1, se tuvo que ocupar el order by en el select de la vista y no como parte de ella.
*/