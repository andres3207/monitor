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
SELECT * FROM datos WHERE (cuando between desde and hasta) order by cuando desc;
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
update sensores set nombre=nombre_sensor, habilitado=estado_sensor where id=id_sensor;
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
if ( (cast(temp as decimal) >=-40) and (cast(temp as decimal) <=100) and (cast(hum as decimal) >=0) and (cast(hum as decimal) <=100)) then
select existe_sensor(mac) into tmp;
if tmp=0 then
	insert into sensores (mac_sensor,temperatura,humedad) values (mac,temp,hum);
elseif tmp=1 then
	update sensores set temperatura=temp, humedad=hum where mac_sensor=mac;
end if;
end if;
end //

delimiter //
use monitoreo//


drop trigger if exists gen_alarma//
create trigger gen_alarma 
before update 
on sensores for each row
begin
declare utmax text;
declare utmin text;
declare uhmax text;
declare uhmin text;
declare nueva_condicion int;
declare vieja_condicion int;
declare max_id_alerta int;
declare reporte text;
declare n int;
declare ultima_alerta datetime;




select t_max,t_min,h_max,h_min into utmax,utmin,uhmax,uhmin from configuracion where id=1;

if ( (cast(NEW.temperatura as decimal)>=-40) and (cast(NEW.temperatura as decimal)<=100)  and (cast(NEW.humedad as decimal)>=0) and (cast(NEW.humedad as decimal)<=100) ) then 

if cast(NEW.temperatura as decimal) < cast(utmin as decimal) then
	if cast(NEW.humedad as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=0;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por debajo del limite configurado de ",utmin,". HUMEDAD = ",NEW.humedad," por debajo del limite configurado de ",uhmin);
	elseif cast(NEW.humedad as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=2;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por debajo del limite configurado de ",utmin,". HUMEDAD = ",NEW.humedad," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=1;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por debajo del limite configurado de ",utmin,". HUMEDAD = ",NEW.humedad," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;
elseif cast(NEW.temperatura as decimal) > cast(utmax as decimal) then
	if cast(NEW.humedad as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=6;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por encima del limite configurado de ",utmax,". HUMEDAD = ",NEW.humedad," por debajo del limite configurado de ",uhmin);
	elseif cast(NEW.humedad as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=8;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por encima del limite configurado de ",utmax,". HUMEDAD = ",NEW.humedad," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=7;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por encima del limite configurado de ",utmax,". HUMEDAD = ",NEW.humedad," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;
else
	if cast(NEW.humedad as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=3;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",NEW.humedad," por debajo del limite configurado de ",uhmin);
	elseif cast(NEW.humedad as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=5;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",NEW.humedad," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=4;
        set reporte=concat(nombre_codigo_camara(NEW.id_camara),": ",nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",NEW.humedad," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;	
end if;

if nueva_condicion!=4 then
	select count(id) into n from alertas where ocultar=0 and id_sensor=OLD.id;
    if n=0 then
		insert into alertas (id_sensor,condicion,mensaje,ocultar) values(OLD.id,nueva_condicion,reporte,0);
        insert into datos (id_sensor,temperatura,humedad) values (OLD.id,NEW.temperatura,NEW.humedad);
	else
		select max(id) into max_id_alerta from alertas where (ocultar=0 and id_sensor=OLD.id);
        select cuando,condicion into ultima_alerta,vieja_condicion from alertas where id=max_id_alerta ;
        if ((ultima_alerta<DATE_SUB(NEW.cuando, INTERVAL 1 HOUR)) or (vieja_condicion!=nueva_condicion) ) then
			insert into alertas (id_sensor,condicion,mensaje,ocultar) values(OLD.id,nueva_condicion,reporte,0);
            insert into datos (id_sensor,temperatura,humedad) values (OLD.id,NEW.temperatura,NEW.humedad);
		end if;
	end if;
end if;
        
end if;
end//


#update sensores set temperatura="35" where id=368 

drop event if exists registrar_datos//
create event registrar_datos on schedule EVERY 1 hour starts concat(date(now())," 13:00:00")
do begin
declare max_id int;
declare i int;
declare id2 int;
declare temp2 text;
declare hum2 text;
drop table if exists sensores_tmp;
CREATE TEMPORARY TABLE IF NOT EXISTS sensores_tmp  (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, ids int, temp text, hum text);
insert into sensores_tmp (ids,temp,hum) select sensores.id, sensores.temperatura, sensores.humedad from sensores where habilitado=1;
select max(id) into max_id from sensores_tmp where 1;
set i=1;
while i<=max_id do
	select ids,temp,hum into id2,temp2,hum2 from sensores_tmp where id=i;
    insert into datos (id_sensor,temperatura,humedad) values (id2,temp2,hum2);
    set i=i+1;
end while;
end//

#call cargar_sensores()


drop procedure if exists datos_filtrados_3//
create procedure datos_filtrados_3(id2 int, desde text, hasta text)
begin
SELECT * FROM datos WHERE (id_sensor=id2) and (cuando between desde and hasta) order by cuando asc;
end//



drop procedure if exists alertas_pendientes//
create procedure alertas_pendientes()
begin
select id,mensaje,cuando from alertas where enviado=0;
end//

drop procedure if exists alerta_enviada//
create procedure alerta_enviada(id_alerta int)
begin
update alertas set enviado=1, cuando=cuando where id=id_alerta;
end//

drop procedure if exists usuarios_activos//
create procedure usuarios_activos()
begin
select chat_id from usuarios where habilitado=1;
end//

drop procedure if exists correos_activos//
create procedure correos_activos()
begin
select email from correos where habilitado=1;
end//


#delimiter //
#use monitoreo//


drop function if exists cant_sensores//
create function cant_sensores()  ## BORRAR
returns int
begin
declare n int;
select count(id) into n from sensores where habilitado=1;
return n;
end//

delimiter //
use monitoreo//
drop function if exists simulador_alerta//
create function simulador_alerta()
returns text
begin
declare utmax text;
declare utmin text;
declare uhmax text;
declare uhmin text;
declare nueva_condicion int;
declare vieja_condicion int;
declare max_id_alerta int;
declare reporte text;
declare n int;
declare ultima_alerta datetime;

declare tempe text;
declare hume text;
declare f_sens datetime;

declare salida text;



select t_max,t_min,h_max,h_min into utmax,utmin,uhmax,uhmin from configuracion where id=1;
select temperatura,humedad,cuando into tempe,hume,f_sens from sensores where id=367;

if ( (cast(tempe as decimal)>=-40) and (cast(tempe as decimal)<=100)  and (cast(hume as decimal)>=0) and (cast(hume as decimal)<=100) ) then
	if cast(tempe as decimal) < cast(utmin as decimal) then
	if cast(hume as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=0;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," por debajo del limite configurado de ",utmin,". HUMEDAD = ",hume," por debajo del limite configurado de ",uhmin);
	elseif cast(hume as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=2;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," por debajo del limite configurado de ",utmin,". HUMEDAD = ",hume," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=1;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," por debajo del limite configurado de ",utmin,". HUMEDAD = ",hume," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;
elseif cast(tempe as decimal) > cast(utmax as decimal) then
	if cast(hume as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=6;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," por encima del limite configurado de ",utmax,". HUMEDAD = ",hume," por debajo del limite configurado de ",uhmin);
	elseif cast(hume as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=8;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," por encima del limite configurado de ",utmax,". HUMEDAD = ",hume," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=7;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," por encima del limite configurado de ",utmax,". HUMEDAD = ",hume," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;
else
	if cast(hume as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=3;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",hume," por debajo del limite configurado de ",uhmin);
	elseif cast(hume as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=5;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",hume," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=4;
        set reporte=concat(nombre_codigo(367)," : TEMPERATURA = ",tempe," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",hume," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;	
end if;
	set salida=concat(nueva_condicion);
    if nueva_condicion!=4 then
	select count(id) into n from alertas where ocultar=0 and id_sensor=367;
    if n=0 then
		set salida="Era la primer alerta del sensor entonces se emite";
	else
		select max(id) into max_id_alerta from alertas where (ocultar=0 and id_sensor=367);
        select cuando,condicion into ultima_alerta,vieja_condicion from alertas where id=max_id_alerta ;
        if ((ultima_alerta<DATE_SUB(f_sens, INTERVAL 1 hour)) or (vieja_condicion!=nueva_condicion) ) then
			set salida="Paso mas de una hora o era otra condicion entonces se emite el alerta";
		else
			set salida="No paso ni una hora ni cambio la condicion";
            set salida=concat("ultima alerta: ",ultima_alerta,". ahora: ",f_sens);
		end if;
        #set salida=concat(DATE_SUB(f_sens, INTERVAL 1 hour));
	end if;
end if;
else
	set salida="NO";

end if;

return salida;
end//

#select simulador_alerta()

delimiter //
use monitoreo//

drop function if exists guardar_sensor_camara//
create function guardar_sensor_camara(camara text, sensor text, temp text, hum text)
returns int
begin
declare n int;
declare id_cam int;
declare id_sen int;
declare salida int;

select count(id) into n from camaras where mac_camara=camara;
if n=0 then
	insert into camaras (mac_camara) value (camara);
    set salida=1;
end if;
select id into id_cam from camaras where mac_camara=camara;

select count(id) into n from sensores where mac_sensor=sensor;
if n=0 then
	insert into sensores (mac_sensor,temperatura,humedad,habilitado,id_camara) values(sensor,temp,hum,1,id_cam);
    set salida=1;
elseif n=1 then
	select id into id_sen from sensores where mac_sensor=sensor;
	update sensores set temperatura=temp,humedad=hum,cuando=now() where id=id_sen;
    set salida=2;
end if;

return salida;
end//

drop function if exists nombre_codigo_camara//
create function nombre_codigo_camara(id_cam int)
returns text
begin
declare tmp text;
declare salida text;
select nombre into tmp from camaras where id=id_cam;
if tmp="" then
	select mac_camara into salida from camaras where id=id_cam;
else
	set salida=tmp;
end if;
return salida;
end //

drop procedure if exists actualizar_camara//
create procedure actualizar_camara(id_camara int, nombre_camara text)
begin
update camaras set nombre=nombre_camara where id=id_camara;
end//

drop procedure if exists cargar_camaras//
create procedure cargar_camaras()
begin
select * from camaras where 1;
end//

drop procedure if exists cargar_sensores_camara//
create procedure cargar_sensores_camara(id_cam int)
begin 
select * from sensores where id_camara=id_cam;
end//

