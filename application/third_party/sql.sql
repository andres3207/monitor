delimiter //
use monitoreo//

drop procedure if exists datos//
create procedure datos()
begin
SELECT * FROM datos WHERE ocultar=0 order by cuando desc;
end//

##call datos

drop procedure if exists datos_filtrados//
create procedure datos_filtrados(desde text, hasta text)
begin
SELECT * FROM datos WHERE date(cuando)>=date(desde) and date(cuando)<= date(hasta) and ocultar=0 order by cuando desc;
end//

#call datos_filtrados("2017-05-29","2017-06-01")

drop procedure if exists datos_filtrados_2//
create procedure datos_filtrados_2(desde text, hasta text)
begin
SELECT * FROM datos WHERE date(cuando)>=date(desde) and date(cuando)<= date(hasta) order by cuando desc;
end//

drop procedure if exists alertas//
create procedure alertas()
begin
select * from alertas where ocultar=0 order by cuando desc;
end//

drop procedure if exists actualizar_limites//
create procedure actualizar_limites(tmin text,tmax text,hmin text,hmax text)
begin
update configuracion set t_min=tmin, t_max=tmax, h_min=hmin, h_max=hmax where 1;
end//

drop procedure if exists cargar_limites//
create procedure cargar_limites()
begin
declare max_id int;
select max(id) into max_id from configuracion where 1; 
select t_min,t_max,h_min,h_max from configuracion where id=max_id;
end//

drop procedure if exists borrar_registros//
create procedure borrar_registros()
begin
update datos set ocultar=1,cuando=cuando where 1;
end//

drop procedure if exists borrar_alertas//
create procedure borrar_alertas()
begin
update alertas set ocultar=1, cuando=cuando where 1;
end//

drop function if exists check_correo//
create function check_correo(correo text)
returns int
begin
declare n int;
select count(id) into n from correos where email=correo;
return n;
end//

drop function if exists agregar_correo//
create function agregar_correo(correo text)
returns int
begin
declare n int;
declare salida int;
select check_correo(correo) into n;
if n=0 then
	insert into correos (email,habilitado) values(correo,1);
    set salida=0;
elseif n=1 then
	set salida =1;
else
	set salida=2;
end if;
return salida;
##Salida=0 OK; salida=1 Ya estaba; salida=2 ERROR multiple veces
end//

#select agregar_correo("andres.tecnocada@gmail.com")//

drop procedure if exists cargar_sensores//
create procedure cargar_sensores()
begin
select * from sensores where 1;
end//

drop procedure if exists actualizar_sensor//
create procedure actualizar_sensor(id_sensor int, nombre_sensor text, estado_sensor text)
begin
update sensores set nombre=nombre_sensor, estado=estado_sensor where id=id_sensor;
end//

drop function if exists nombre_codigo//
create function nombre_codigo(id_sensor int)
returns text
begin
declare tmp1 text;
declare tmp2 text;
declare salida text;
select nombre,mac_sensor into tmp1,tmp2 from sensores where id=id_sensor;
if tmp1="" then
	set salida=tmp2;
else
	set salida=tmp1;
end if;
return salida;
end//

#select nombre_codigo(367)

drop function if exists existe_sensor//
create function existe_sensor(mac text)
returns int
begin
declare n int;
declare salida int;
select count(id) into n from sensores where mac_sensor=mac;
if n=0 then
	set salida=0;
elseif n=1 then
	set salida=1;
else
	set salida=2;
end if;
return salida;
# 0: no existe; 1: ya existe; 2: ERROR multiples veces
end//

drop procedure if exists guardar_sensor//
create procedure guardar_sensor(temp text, hum text, mac text)
begin
declare tmp int;
select existe_sensor(mac) into tmp;
if tmp=0 then
	insert into sensores (mac_sensor,temperatura,humedad) values (mac,temp,hum);
elseif tmp=1 then
	update sensores set temperatura=temp, humedad=hum where mac_sensor=mac;
end if;
end //
