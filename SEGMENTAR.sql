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
	  de los años 2020 y 2021.*/



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
*/
use region_noreste
select ENTIDAD_RES from datoscovid