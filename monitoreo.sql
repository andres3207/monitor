-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 01-08-2017 a las 09:26:47
-- Versión del servidor: 5.5.52-0+deb8u1
-- Versión de PHP: 5.6.27-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `monitoreo`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`%` PROCEDURE `actualizar_limites`(tmin text,tmax text,hmin text,hmax text)
begin
update configuracion set t_min=tmin, t_max=tmax, h_min=hmin, h_max=hmax where 1;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `actualizar_sensor`(id_sensor int, nombre_sensor text, estado_sensor text)
begin
update sensores set nombre=nombre_sensor, habilitado=estado_sensor where id=id_sensor;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `alertas`()
begin
select * from alertas where ocultar=0 order by cuando desc;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `alertas_pendientes`()
begin
select id,mensaje,cuando from alertas where enviado=0;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `alerta_enviada`(id_alerta int)
begin
update alertas set enviado=1, cuando=cuando where id=id_alerta;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `borrar_alertas`()
begin
update alertas set ocultar=1, cuando=cuando where 1;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `borrar_registros`()
begin
update datos set ocultar=1,cuando=cuando where 1;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `cargar_limites`()
begin
declare max_id int;
select max(id) into max_id from configuracion where 1; 
select t_min,t_max,h_min,h_max from configuracion where id=max_id;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `cargar_sensores`()
begin
select * from sensores where 1;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `correos_activos`()
begin
select email from correos where habilitado=1;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `datos`()
begin
SELECT * FROM datos WHERE ocultar=0 order by cuando desc;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `datos_filtrados`(desde text, hasta text)
begin
SELECT * FROM datos WHERE date(cuando)>=date(desde) and date(cuando)<= date(hasta) and ocultar=0 order by cuando desc;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `datos_filtrados_2`(desde text, hasta text)
begin
SELECT * FROM datos WHERE (cuando between desde and hasta) order by cuando desc;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `datos_filtrados_3`(id2 int, desde text, hasta text)
begin
SELECT * FROM datos WHERE (id_sensor=id2) and (cuando between desde and hasta) order by cuando asc;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `guardar_sensor`(temp text, hum text, mac text)
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
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `usuarios_activos`()
begin
select chat_id from usuarios where habilitado=1;
end$$

--
-- Funciones
--
CREATE DEFINER=`root`@`%` FUNCTION `agregar_correo`(correo text) RETURNS int(11)
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
end$$

CREATE DEFINER=`root`@`%` FUNCTION `cant_sensores`() RETURNS int(11)
begin
declare n int;
select count(id) into n from sensores where habilitado=1;
return n;
end$$

CREATE DEFINER=`root`@`%` FUNCTION `check_correo`(correo text) RETURNS int(11)
begin
declare n int;
select count(id) into n from correos where email=correo;
return n;
end$$

CREATE DEFINER=`root`@`%` FUNCTION `existe_sensor`(mac text) RETURNS int(11)
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
end$$

CREATE DEFINER=`root`@`%` FUNCTION `nombre_codigo`(id_sensor int) RETURNS text CHARSET latin1
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
end$$

CREATE DEFINER=`root`@`%` FUNCTION `prueba`() RETURNS datetime
begin
return now();
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas`
--

CREATE TABLE IF NOT EXISTS `alertas` (
`id` int(11) NOT NULL,
  `id_sensor` int(11) NOT NULL,
  `condicion` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `ocultar` int(11) NOT NULL,
  `enviado` int(11) NOT NULL DEFAULT '0',
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `alertas`
--

INSERT INTO `alertas` (`id`, `id_sensor`, `condicion`, `mensaje`, `ocultar`, `enviado`, `cuando`) VALUES
(1, 367, 0, 'Sensor 1 : TEMPERATURA = nan por debajo del limite configurado de 5. HUMEDAD = nan por debajo del limite configurado de 20', 0, 1, '2017-06-12 18:00:19'),
(2, 367, 0, 'Sensor 1 : TEMPERATURA = nan por debajo del limite configurado de 5.7. HUMEDAD = nan por debajo del limite configurado de 20', 0, 1, '2017-06-13 18:38:06'),
(3, 367, 0, 'Sensor 1 : TEMPERATURA = nan por debajo del limite configurado de 6.7. HUMEDAD = nan por debajo del limite configurado de 21.0', 0, 1, '2017-07-15 14:02:21'),
(4, 367, 5, 'Sensor 1 : TEMPERATURA = 24.70 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 89.00 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:25'),
(5, 367, 5, 'Sensor 1 : TEMPERATURA = 24.40 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 94.20 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:28'),
(6, 367, 5, 'Sensor 1 : TEMPERATURA = 24.30 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.40 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:30'),
(7, 367, 5, 'Sensor 1 : TEMPERATURA = 24.20 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:32'),
(8, 367, 5, 'Sensor 1 : TEMPERATURA = 24.20 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:34'),
(9, 367, 5, 'Sensor 1 : TEMPERATURA = 24.10 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:37'),
(10, 367, 5, 'Sensor 1 : TEMPERATURA = 23.90 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:39'),
(11, 367, 5, 'Sensor 1 : TEMPERATURA = 23.90 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:41'),
(12, 367, 5, 'Sensor 1 : TEMPERATURA = 23.80 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:44'),
(13, 367, 5, 'Sensor 1 : TEMPERATURA = 23.80 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:46'),
(14, 367, 5, 'Sensor 1 : TEMPERATURA = 23.80 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:48'),
(15, 367, 5, 'Sensor 1 : TEMPERATURA = 23.70 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:51'),
(16, 367, 5, 'Sensor 1 : TEMPERATURA = 23.60 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:53'),
(17, 367, 5, 'Sensor 1 : TEMPERATURA = 23.60 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:55'),
(18, 367, 5, 'Sensor 1 : TEMPERATURA = 23.60 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 98.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:02:57'),
(19, 367, 5, 'Sensor 1 : TEMPERATURA = 23.70 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 96.20 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:03:00'),
(20, 367, 5, 'Sensor 1 : TEMPERATURA = 23.70 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 93.80 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:03:02'),
(21, 367, 5, 'Sensor 1 : TEMPERATURA = 23.70 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 90.80 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:03:04'),
(22, 367, 5, 'Sensor 1 : TEMPERATURA = 23.70 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 87.60 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:03:07'),
(23, 367, 5, 'Sensor 1 : TEMPERATURA = 23.80 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 84.20 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:03:09'),
(24, 367, 5, 'Sensor 1 : TEMPERATURA = 23.80 dentro del limite configurado de 6.7 y 32.0. HUMEDAD = 81.00 por encima del limite configurado de 80.0', 0, 1, '2017-07-15 14:03:11'),
(25, 367, 5, 'Sensor 1 : TEMPERATURA = 22.90 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:26'),
(26, 367, 5, 'Sensor 1 : TEMPERATURA = 22.90 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:29'),
(27, 367, 5, 'Sensor 1 : TEMPERATURA = 23.00 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:31'),
(28, 367, 5, 'Sensor 1 : TEMPERATURA = 23.00 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:33'),
(29, 367, 5, 'Sensor 1 : TEMPERATURA = 23.00 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:36'),
(30, 367, 5, 'Sensor 1 : TEMPERATURA = 22.90 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:38'),
(31, 367, 5, 'Sensor 1 : TEMPERATURA = 22.90 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:40'),
(32, 367, 5, 'Sensor 1 : TEMPERATURA = 23.00 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:42'),
(33, 367, 5, 'Sensor 1 : TEMPERATURA = 23.00 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:45'),
(34, 367, 5, 'Sensor 1 : TEMPERATURA = 23.00 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:47'),
(35, 367, 5, 'Sensor 1 : TEMPERATURA = 22.90 dentro del limite configurado de 9.7 y 32.0. HUMEDAD = 62.70 por encima del limite configurado de 60', 0, 1, '2017-07-15 15:04:49'),
(36, 367, 7, 'Sensor 1 : TEMPERATURA = 23.00 por encima del limite configurado de 9.7. HUMEDAD = 62.40 dentro del limite configurado de 21.0 y 65', 0, 1, '2017-07-15 15:26:43'),
(37, 367, 5, 'Sensor 1 : TEMPERATURA = 23.40 dentro del limite configurado de 9.7 y 32. HUMEDAD = 65.50 por encima del limite configurado de 65', 0, 1, '2017-07-15 16:39:45'),
(38, 367, 5, 'Sensor 1 : TEMPERATURA = 21.00 dentro del limite configurado de 9.7 y 32. HUMEDAD = 81.10 por encima del limite configurado de 80', 0, 1, '2017-07-17 12:33:38'),
(39, 367, 7, 'Sensor 1 : TEMPERATURA = 21.10 por encima del limite configurado de 9.7. HUMEDAD = 64.70 dentro del limite configurado de 21.0 y 80', 0, 1, '2017-07-17 13:33:10'),
(40, 367, 7, 'Sensor 1 : TEMPERATURA = 20.60 por encima del limite configurado de 20. HUMEDAD = 60.80 dentro del limite configurado de 21.0 y 80', 0, 1, '2017-07-18 04:00:28'),
(41, 367, 7, 'Sensor 1 : TEMPERATURA = 20.90 por encima del limite configurado de 20. HUMEDAD = 58.00 dentro del limite configurado de 21.0 y 80', 0, 1, '2017-07-18 13:08:07'),
(42, 367, 7, 'Sensor 1 : TEMPERATURA = 21.00 por encima del limite configurado de 15. HUMEDAD = 58.30 dentro del limite configurado de 21.0 y 80', 0, 1, '2017-07-18 14:08:12'),
(43, 367, 7, 'Sensor 1 : TEMPERATURA = 21.10 por encima del limite configurado de 15. HUMEDAD = 57.90 dentro del limite configurado de 21.0 y 80', 0, 1, '2017-07-18 15:08:19'),
(44, 367, 8, 'Sensor 1 : TEMPERATURA = 21.10 por encima del limite configurado de 15. HUMEDAD = 57.80 por encima del limite configurado de 50', 0, 1, '2017-07-18 15:10:42'),
(45, 367, 7, 'Sensor 1 : TEMPERATURA = 21.10 por encima del limite configurado de 15. HUMEDAD = 57.80 dentro del limite configurado de 21.0 y 80', 0, 1, '2017-07-18 15:16:21'),
(46, 367, 6, 'Sensor 1 : TEMPERATURA = 21.10 por encima del limite configurado de 15. HUMEDAD = 57.90 por debajo del limite configurado de 60', 0, 1, '2017-07-18 15:17:23'),
(47, 367, 7, 'Sensor 1 : TEMPERATURA = 21.10 por encima del limite configurado de 15. HUMEDAD = 57.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 15:19:42'),
(48, 367, 7, 'Sensor 1 : TEMPERATURA = 21.30 por encima del limite configurado de 15. HUMEDAD = 57.90 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 16:19:47'),
(49, 367, 7, 'Sensor 1 : TEMPERATURA = 21.30 por encima del limite configurado de 15. HUMEDAD = 57.90 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 17:19:54'),
(50, 367, 7, 'Sensor 1 : TEMPERATURA = 21.40 por encima del limite configurado de 15. HUMEDAD = 57.50 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 18:19:58'),
(51, 367, 7, 'Sensor 1 : TEMPERATURA = 21.70 por encima del limite configurado de 15. HUMEDAD = 60.80 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 19:20:06'),
(52, 367, 7, 'Sensor 1 : TEMPERATURA = 21.70 por encima del limite configurado de 15. HUMEDAD = 61.00 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 20:20:10'),
(53, 367, 7, 'Sensor 1 : TEMPERATURA = 21.80 por encima del limite configurado de 15. HUMEDAD = 61.20 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 21:20:32'),
(54, 367, 7, 'Sensor 1 : TEMPERATURA = 21.70 por encima del limite configurado de 15. HUMEDAD = 63.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-18 22:20:37'),
(55, 367, 7, 'Sensor 1 : TEMPERATURA = 21.90 por encima del limite configurado de 16. HUMEDAD = 58.60 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 12:25:56'),
(56, 367, 7, 'Sensor 1 : TEMPERATURA = 21.20 por encima del limite configurado de 16. HUMEDAD = 55.80 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 13:26:01'),
(57, 367, 7, 'Sensor 1 : TEMPERATURA = 21.30 por encima del limite configurado de 16. HUMEDAD = 51.50 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 14:26:11'),
(58, 367, 7, 'Sensor 1 : TEMPERATURA = 21.40 por encima del limite configurado de 16. HUMEDAD = 52.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 15:26:15'),
(59, 367, 7, 'Sensor 1 : TEMPERATURA = 21.80 por encima del limite configurado de 16. HUMEDAD = 54.00 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 16:26:25'),
(60, 367, 7, 'Sensor 1 : TEMPERATURA = 21.90 por encima del limite configurado de 16. HUMEDAD = 54.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 17:26:32'),
(61, 367, 7, 'Sensor 1 : TEMPERATURA = 22.00 por encima del limite configurado de 16. HUMEDAD = 54.50 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 18:26:45'),
(62, 367, 8, 'Sensor 1 : TEMPERATURA = 22.00 por encima del limite configurado de 16. HUMEDAD = 54.50 por encima del limite configurado de 40', 0, 1, '2017-07-19 18:35:50'),
(63, 367, 7, 'Sensor 1 : TEMPERATURA = 22.00 por encima del limite configurado de 16. HUMEDAD = 54.50 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 18:36:30'),
(64, 367, 7, 'Sensor 1 : TEMPERATURA = 22.20 por encima del limite configurado de 16. HUMEDAD = 58.10 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 19:36:40'),
(65, 367, 7, 'Sensor 1 : TEMPERATURA = 22.30 por encima del limite configurado de 16. HUMEDAD = 59.20 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 20:36:47'),
(66, 367, 7, 'Sensor 1 : TEMPERATURA = 22.30 por encima del limite configurado de 16. HUMEDAD = 58.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 21:37:06'),
(67, 367, 7, 'Sensor 1 : TEMPERATURA = 22.40 por encima del limite configurado de 16. HUMEDAD = 58.60 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-19 22:37:09'),
(68, 367, 7, 'Sensor 1 : TEMPERATURA = 22.90 por encima del limite configurado de 16. HUMEDAD = 58.80 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:03:25'),
(69, 367, 7, 'Sensor 1 : TEMPERATURA = 22.80 por encima del limite configurado de 16. HUMEDAD = 58.60 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:04:29'),
(70, 367, 7, 'Sensor 1 : TEMPERATURA = 22.80 por encima del limite configurado de 16. HUMEDAD = 58.90 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:05:43'),
(71, 367, 7, 'Sensor 1 : TEMPERATURA = 22.80 por encima del limite configurado de 16. HUMEDAD = 59.00 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:06:47'),
(72, 367, 7, 'Sensor 1 : TEMPERATURA = 22.90 por encima del limite configurado de 16. HUMEDAD = 58.90 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:07:51'),
(73, 367, 7, 'Sensor 1 : TEMPERATURA = 22.90 por encima del limite configurado de 16. HUMEDAD = 58.90 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:09:02'),
(74, 367, 7, 'Sensor 1 : TEMPERATURA = 22.90 por encima del limite configurado de 16. HUMEDAD = 59.10 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 12:10:08'),
(75, 367, 7, 'Sensor 1 : TEMPERATURA = 22.80 por encima del limite configurado de 16. HUMEDAD = 59.40 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 13:10:14'),
(76, 367, 7, 'Sensor 1 : TEMPERATURA = 22.90 por encima del limite configurado de 16. HUMEDAD = 59.50 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 14:10:32'),
(77, 367, 7, 'Sensor 1 : TEMPERATURA = 23.00 por encima del limite configurado de 16. HUMEDAD = 59.00 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 15:10:42'),
(78, 367, 8, 'Sensor 1 : TEMPERATURA = 23.00 por encima del limite configurado de 16. HUMEDAD = 58.80 por encima del limite configurado de 50', 0, 1, '2017-07-20 15:30:48'),
(79, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.40 por encima del limite configurado de 50', 0, 1, '2017-07-20 16:30:53'),
(80, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.70 por encima del limite configurado de 50', 0, 1, '2017-07-20 16:41:05'),
(81, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.50 por encima del limite configurado de 50', 0, 1, '2017-07-20 16:51:18'),
(82, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.10 por encima del limite configurado de 50', 0, 1, '2017-07-20 17:11:38'),
(83, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.20 por encima del limite configurado de 50', 0, 1, '2017-07-20 17:31:42'),
(84, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.50 por encima del limite configurado de 50', 0, 1, '2017-07-20 17:51:46'),
(85, 367, 8, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 60.30 por encima del limite configurado de 50', 0, 1, '2017-07-20 18:11:50'),
(86, 367, 8, 'Sensor 1 : TEMPERATURA = 23.20 por encima del limite configurado de 16. HUMEDAD = 60.50 por encima del limite configurado de 50', 0, 1, '2017-07-20 18:31:55'),
(87, 367, 7, 'Sensor 1 : TEMPERATURA = 23.20 por encima del limite configurado de 16. HUMEDAD = 60.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 18:34:08'),
(88, 367, 7, 'Sensor 1 : TEMPERATURA = 23.10 por encima del limite configurado de 16. HUMEDAD = 59.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 18:54:12'),
(89, 367, 7, 'Sensor 1 : TEMPERATURA = 23.20 por encima del limite configurado de 16. HUMEDAD = 60.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 19:14:19'),
(90, 367, 7, 'Sensor 1 : TEMPERATURA = 23.30 por encima del limite configurado de 16. HUMEDAD = 60.40 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 19:34:22'),
(91, 367, 7, 'Sensor 1 : TEMPERATURA = 23.30 por encima del limite configurado de 16. HUMEDAD = 60.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 19:54:26'),
(92, 367, 7, 'Sensor 1 : TEMPERATURA = 23.20 por encima del limite configurado de 16. HUMEDAD = 60.90 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 20:14:46'),
(93, 367, 7, 'Sensor 1 : TEMPERATURA = 23.30 por encima del limite configurado de 16. HUMEDAD = 61.10 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 20:34:54'),
(94, 367, 7, 'Sensor 1 : TEMPERATURA = 23.20 por encima del limite configurado de 16. HUMEDAD = 61.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 20:55:06'),
(95, 367, 7, 'Sensor 1 : TEMPERATURA = 23.40 por encima del limite configurado de 15. HUMEDAD = 61.70 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 21:56:47'),
(96, 367, 7, 'Sensor 1 : TEMPERATURA = 23.40 por encima del limite configurado de 15. HUMEDAD = 62.00 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 22:16:56'),
(97, 367, 7, 'Sensor 1 : TEMPERATURA = 23.40 por encima del limite configurado de 15. HUMEDAD = 62.10 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 22:37:00'),
(98, 367, 7, 'Sensor 1 : TEMPERATURA = 23.40 por encima del limite configurado de 15. HUMEDAD = 62.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 22:57:15'),
(99, 367, 7, 'Sensor 1 : TEMPERATURA = 23.50 por encima del limite configurado de 15. HUMEDAD = 62.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 23:17:18'),
(100, 367, 7, 'Sensor 1 : TEMPERATURA = 23.80 por encima del limite configurado de 15. HUMEDAD = 63.30 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 23:37:30'),
(101, 367, 7, 'Sensor 1 : TEMPERATURA = 23.50 por encima del limite configurado de 15. HUMEDAD = 63.20 dentro del limite configurado de 20 y 80', 0, 1, '2017-07-20 23:57:35'),
(102, 367, 8, 'Sensor 1 : TEMPERATURA = 23.50 por encima del limite configurado de 15. HUMEDAD = 64.30 por encima del limite configurado de 50', 0, 1, '2017-07-21 00:05:00'),
(103, 367, 8, 'Sensor 1 : TEMPERATURA = 23.60 por encima del limite configurado de 15. HUMEDAD = 64.90 por encima del limite configurado de 50', 0, 1, '2017-07-21 01:05:06'),
(104, 367, 8, 'Sensor 1 : TEMPERATURA = 23.50 por encima del limite configurado de 15.0. HUMEDAD = 64.50 por encima del limite configurado de 50.0', 0, 1, '2017-07-21 02:05:09'),
(105, 367, 8, 'Sensor 1 : TEMPERATURA = 23.60 por encima del limite configurado de 15.0. HUMEDAD = 63.30 por encima del limite configurado de 50.0', 0, 1, '2017-07-21 03:05:12'),
(106, 367, 5, 'Sensor 1 : TEMPERATURA = 23.20 dentro del limite configurado de 22 y 32. HUMEDAD = 61.00 por encima del limite configurado de 60', 0, 1, '2017-07-29 13:56:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE IF NOT EXISTS `configuracion` (
`id` int(11) NOT NULL,
  `t_min` text NOT NULL,
  `t_max` text NOT NULL,
  `h_min` text NOT NULL,
  `h_max` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `t_min`, `t_max`, `h_min`, `h_max`) VALUES
(1, '15', '32', '20.0', '70');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `correos`
--

CREATE TABLE IF NOT EXISTS `correos` (
`id` int(11) NOT NULL,
  `email` text NOT NULL,
  `habilitado` int(11) NOT NULL,
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `correos`
--

INSERT INTO `correos` (`id`, `email`, `habilitado`, `cuando`) VALUES
(1, 'andres3207@gmail.com', 1, '2017-01-30 12:39:42'),
(2, 'a.3207@hotmail.com', 1, '2017-01-30 12:44:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos`
--

CREATE TABLE IF NOT EXISTS `datos` (
`id` int(11) NOT NULL,
  `id_sensor` int(11) NOT NULL,
  `temperatura` text NOT NULL,
  `humedad` text NOT NULL,
  `ocultar` int(11) NOT NULL,
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=1477 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `datos`
--

INSERT INTO `datos` (`id`, `id_sensor`, `temperatura`, `humedad`, `ocultar`, `cuando`) VALUES
(1, 367, '21.10', '55.30', 0, '2017-06-12 16:21:30'),
(2, 368, '20', '62.1', 0, '2017-06-12 16:21:30'),
(3, 367, '21.10', '55.10', 0, '2017-06-12 17:21:30'),
(4, 368, '20', '62.1', 0, '2017-06-12 17:21:30'),
(5, 367, 'nan', 'nan', 0, '2017-06-12 18:00:19'),
(6, 367, '21.20', '55.40', 0, '2017-06-12 18:21:30'),
(7, 368, '20', '62.1', 0, '2017-06-12 18:21:30'),
(8, 367, '21.30', '55.40', 0, '2017-06-12 19:21:30'),
(9, 368, '20', '62.1', 0, '2017-06-12 19:21:30'),
(10, 367, '21.30', '55.50', 0, '2017-06-12 20:21:30'),
(11, 368, '20', '62.1', 0, '2017-06-12 20:21:30'),
(12, 367, '21.30', '55.80', 0, '2017-06-12 21:21:30'),
(13, 367, '21.30', '56.10', 0, '2017-06-12 22:21:30'),
(14, 367, '21.50', '59.80', 0, '2017-06-12 23:21:30'),
(15, 367, '21.60', '59.30', 0, '2017-06-13 00:21:30'),
(16, 367, '21.40', '58.50', 0, '2017-06-13 01:21:30'),
(17, 367, '21.30', '58.40', 0, '2017-06-13 02:21:30'),
(18, 367, '21.30', '58.60', 0, '2017-06-13 03:21:30'),
(19, 367, '21.20', '58.90', 0, '2017-06-13 04:21:30'),
(20, 367, '21.20', '59.50', 0, '2017-06-13 05:21:30'),
(21, 367, '21.10', '58.90', 0, '2017-06-13 06:21:30'),
(22, 367, '21.10', '58.90', 0, '2017-06-13 07:21:30'),
(23, 367, '21.10', '59.00', 0, '2017-06-13 08:21:30'),
(24, 367, '21.10', '59.00', 0, '2017-06-13 09:21:30'),
(25, 367, '21.10', '59.70', 0, '2017-06-13 10:21:30'),
(26, 367, '21.30', '61.40', 0, '2017-06-13 11:21:30'),
(27, 367, '21.20', '61.30', 0, '2017-06-13 11:59:50'),
(28, 367, '21.20', '61.00', 0, '2017-06-13 12:53:03'),
(29, 367, '21.30', '63.40', 0, '2017-06-13 13:42:53'),
(30, 367, '21.30', '60.50', 0, '2017-06-13 14:42:53'),
(31, 367, '21.50', '59.90', 0, '2017-06-13 16:00:00'),
(32, 367, '21.60', '60.20', 0, '2017-06-13 17:00:00'),
(33, 367, '22.00', '61.20', 0, '2017-06-13 18:00:00'),
(34, 367, 'nan', 'nan', 0, '2017-06-13 18:38:06'),
(35, 367, '22.30', '61.20', 0, '2017-06-13 19:00:00'),
(36, 367, '22.20', '60.30', 0, '2017-06-13 20:00:00'),
(37, 367, '22.30', '60.50', 0, '2017-06-13 21:00:00'),
(38, 367, '22.20', '59.90', 0, '2017-06-13 22:00:00'),
(39, 367, '22.20', '59.50', 0, '2017-06-13 23:00:00'),
(40, 367, '22.30', '59.00', 0, '2017-06-14 00:00:00'),
(41, 367, '22.30', '59.20', 0, '2017-06-14 01:00:00'),
(42, 367, '22.10', '58.60', 0, '2017-06-14 02:00:00'),
(43, 367, '22.00', '58.20', 0, '2017-06-14 03:00:00'),
(44, 367, '22.00', '58.40', 0, '2017-06-14 04:00:00'),
(45, 367, '21.90', '58.70', 0, '2017-06-14 05:00:00'),
(46, 367, '21.90', '58.50', 0, '2017-06-14 06:00:00'),
(47, 367, '21.90', '58.40', 0, '2017-06-14 07:00:00'),
(48, 367, '21.90', '58.00', 0, '2017-06-14 08:00:00'),
(49, 367, '21.70', '57.90', 0, '2017-06-14 09:00:00'),
(50, 367, '21.60', '58.10', 0, '2017-06-14 10:00:00'),
(51, 367, '21.80', '59.20', 0, '2017-06-14 11:00:00'),
(52, 367, '21.90', '59.30', 0, '2017-06-14 12:00:00'),
(53, 367, '21.80', '60.50', 0, '2017-06-14 13:00:00'),
(54, 367, '22.60', '59.70', 0, '2017-06-14 15:00:00'),
(55, 368, '20.50', '61.30', 0, '2017-06-14 15:00:00'),
(56, 367, '23.00', '59.50', 0, '2017-06-14 16:00:00'),
(57, 368, '20.50', '61.30', 0, '2017-06-14 16:00:00'),
(58, 367, '23.00', '60.00', 0, '2017-06-14 17:00:00'),
(59, 368, '20.50', '61.30', 0, '2017-06-14 17:00:00'),
(60, 367, '23.30', '60.30', 0, '2017-06-14 18:00:00'),
(61, 368, '20.50', '61.30', 0, '2017-06-14 18:00:00'),
(62, 367, '23.50', '61.10', 0, '2017-06-14 19:00:00'),
(63, 368, '20.50', '61.30', 0, '2017-06-14 19:00:00'),
(64, 367, '23.60', '61.50', 0, '2017-06-14 20:00:00'),
(65, 368, '20.50', '61.30', 0, '2017-06-14 20:00:00'),
(66, 367, '23.50', '62.30', 0, '2017-06-14 21:00:00'),
(67, 368, '20.50', '61.30', 0, '2017-06-14 21:00:00'),
(68, 367, '23.50', '62.30', 0, '2017-06-14 22:00:00'),
(69, 368, '20.50', '61.30', 0, '2017-06-14 22:00:00'),
(70, 367, '23.50', '62.40', 0, '2017-06-14 23:00:00'),
(71, 368, '20.50', '61.30', 0, '2017-06-14 23:00:00'),
(72, 367, '23.70', '63.90', 0, '2017-06-15 00:00:00'),
(73, 368, '20.50', '61.30', 0, '2017-06-15 00:00:00'),
(74, 367, '23.70', '64.50', 0, '2017-06-15 01:00:00'),
(75, 368, '20.50', '61.30', 0, '2017-06-15 01:00:00'),
(76, 367, '23.70', '64.20', 0, '2017-06-15 02:00:00'),
(77, 368, '20.50', '61.30', 0, '2017-06-15 02:00:00'),
(78, 367, '23.80', '64.30', 0, '2017-06-15 03:00:00'),
(79, 368, '20.50', '61.30', 0, '2017-06-15 03:00:00'),
(80, 367, '23.70', '64.30', 0, '2017-06-15 04:00:00'),
(81, 368, '20.50', '61.30', 0, '2017-06-15 04:00:00'),
(82, 367, '23.70', '64.30', 0, '2017-06-15 05:00:00'),
(83, 368, '20.50', '61.30', 0, '2017-06-15 05:00:00'),
(84, 367, '23.50', '63.90', 0, '2017-06-15 06:00:00'),
(85, 368, '20.50', '61.30', 0, '2017-06-15 06:00:00'),
(86, 367, '23.50', '63.50', 0, '2017-06-15 07:00:00'),
(87, 368, '20.50', '61.30', 0, '2017-06-15 07:00:00'),
(88, 367, '23.50', '63.40', 0, '2017-06-15 08:00:00'),
(89, 368, '20.50', '61.30', 0, '2017-06-15 08:00:00'),
(90, 367, '23.50', '63.10', 0, '2017-06-15 09:00:00'),
(91, 368, '20.50', '61.30', 0, '2017-06-15 09:00:00'),
(92, 367, '23.70', '63.30', 0, '2017-06-15 10:00:00'),
(93, 368, '20.50', '61.30', 0, '2017-06-15 10:00:00'),
(94, 367, '23.90', '63.90', 0, '2017-06-15 11:00:00'),
(95, 368, '20.50', '61.30', 0, '2017-06-15 11:00:00'),
(96, 367, '23.70', '64.50', 0, '2017-06-15 12:00:00'),
(97, 368, '20.50', '61.30', 0, '2017-06-15 12:00:00'),
(98, 367, '23.70', '64.50', 0, '2017-06-15 13:00:00'),
(99, 368, '20.50', '61.30', 0, '2017-06-15 13:00:00'),
(100, 367, '23.80', '64.30', 0, '2017-06-15 14:00:00'),
(101, 368, '20.50', '61.30', 0, '2017-06-15 14:00:00'),
(102, 367, '23.70', '66.60', 0, '2017-06-15 15:00:00'),
(103, 368, '20.50', '61.30', 0, '2017-06-15 15:00:00'),
(104, 367, '24.00', '66.10', 0, '2017-06-15 16:00:00'),
(105, 368, '20.50', '61.30', 0, '2017-06-15 16:00:00'),
(106, 367, '24.20', '66.10', 0, '2017-06-15 17:00:00'),
(107, 368, '20.50', '61.30', 0, '2017-06-15 17:00:00'),
(108, 367, '24.20', '66.10', 0, '2017-06-15 18:00:00'),
(109, 368, '20.50', '61.30', 0, '2017-06-15 18:00:00'),
(110, 367, '24.20', '66.10', 0, '2017-06-15 19:00:00'),
(111, 368, '20.50', '61.30', 0, '2017-06-15 19:00:00'),
(112, 367, '24.20', '66.10', 0, '2017-06-15 20:00:00'),
(113, 368, '20.50', '61.30', 0, '2017-06-15 20:00:00'),
(114, 367, '24.20', '66.10', 0, '2017-06-15 21:00:00'),
(115, 368, '20.50', '61.30', 0, '2017-06-15 21:00:00'),
(116, 367, '24.20', '66.10', 0, '2017-06-15 22:00:00'),
(117, 368, '20.50', '61.30', 0, '2017-06-15 22:00:00'),
(118, 367, '24.20', '66.10', 0, '2017-06-15 23:00:00'),
(119, 368, '20.50', '61.30', 0, '2017-06-15 23:00:00'),
(120, 367, '24.20', '66.10', 0, '2017-06-16 00:00:00'),
(121, 368, '20.50', '61.30', 0, '2017-06-16 00:00:00'),
(122, 367, '24.20', '66.10', 0, '2017-06-16 01:00:00'),
(123, 368, '20.50', '61.30', 0, '2017-06-16 01:00:00'),
(124, 367, '24.20', '66.10', 0, '2017-06-16 02:00:00'),
(125, 368, '20.50', '61.30', 0, '2017-06-16 02:00:00'),
(126, 367, '24.20', '66.10', 0, '2017-06-16 03:00:00'),
(127, 368, '20.50', '61.30', 0, '2017-06-16 03:00:00'),
(128, 367, '24.20', '66.10', 0, '2017-06-16 04:00:00'),
(129, 368, '20.50', '61.30', 0, '2017-06-16 04:00:00'),
(130, 367, '24.20', '66.10', 0, '2017-06-16 05:00:00'),
(131, 368, '20.50', '61.30', 0, '2017-06-16 05:00:00'),
(132, 367, '24.20', '66.10', 0, '2017-06-16 06:00:00'),
(133, 368, '20.50', '61.30', 0, '2017-06-16 06:00:00'),
(134, 367, '24.20', '66.10', 0, '2017-06-16 07:00:00'),
(135, 368, '20.50', '61.30', 0, '2017-06-16 07:00:00'),
(136, 367, '24.20', '66.10', 0, '2017-06-16 08:00:00'),
(137, 368, '20.50', '61.30', 0, '2017-06-16 08:00:00'),
(138, 367, '24.20', '66.10', 0, '2017-06-16 09:00:00'),
(139, 368, '20.50', '61.30', 0, '2017-06-16 09:00:00'),
(140, 367, '25.50', '68.90', 0, '2017-06-16 10:00:00'),
(141, 367, '25.90', '70.20', 0, '2017-06-16 11:00:00'),
(142, 367, '25.80', '71.20', 0, '2017-06-16 12:00:00'),
(143, 367, '25.90', '71.00', 0, '2017-06-16 13:00:00'),
(144, 368, '20.50', '61.30', 0, '2017-06-16 13:00:00'),
(145, 367, '25.60', '71.10', 0, '2017-06-16 14:00:00'),
(146, 368, '20.50', '61.30', 0, '2017-06-16 14:00:00'),
(147, 367, '25.90', '73.50', 0, '2017-06-16 15:00:00'),
(148, 368, '20.50', '61.30', 0, '2017-06-16 15:00:00'),
(149, 367, '25.90', '72.00', 0, '2017-06-16 16:00:00'),
(150, 368, '20.50', '61.30', 0, '2017-06-16 16:00:00'),
(151, 367, '26.00', '71.10', 0, '2017-06-16 17:00:00'),
(152, 368, '20.50', '61.30', 0, '2017-06-16 17:00:01'),
(153, 367, '26.00', '70.60', 0, '2017-06-16 18:00:00'),
(154, 368, '20.50', '61.30', 0, '2017-06-16 18:00:00'),
(155, 367, '26.00', '70.50', 0, '2017-06-16 19:00:00'),
(156, 368, '20.50', '61.30', 0, '2017-06-16 19:00:00'),
(157, 367, '26.00', '70.30', 0, '2017-06-16 20:00:00'),
(158, 368, '20.50', '61.30', 0, '2017-06-16 20:00:00'),
(159, 367, '26.00', '70.60', 0, '2017-06-16 21:00:00'),
(160, 368, '20.50', '61.30', 0, '2017-06-16 21:00:00'),
(161, 367, '25.80', '70.50', 0, '2017-06-16 22:00:00'),
(162, 368, '20.50', '61.30', 0, '2017-06-16 22:00:00'),
(163, 367, '25.60', '71.10', 0, '2017-06-16 23:00:00'),
(164, 368, '20.50', '61.30', 0, '2017-06-16 23:00:00'),
(165, 367, '25.80', '70.90', 0, '2017-06-17 00:00:00'),
(166, 368, '20.50', '61.30', 0, '2017-06-17 00:00:00'),
(167, 367, '25.80', '70.90', 0, '2017-06-17 01:00:00'),
(168, 368, '20.50', '61.30', 0, '2017-06-17 01:00:00'),
(169, 367, '25.80', '70.90', 0, '2017-06-17 02:00:00'),
(170, 368, '20.50', '61.30', 0, '2017-06-17 02:00:00'),
(171, 367, '25.80', '70.90', 0, '2017-06-17 03:00:00'),
(172, 368, '20.50', '61.30', 0, '2017-06-17 03:00:00'),
(173, 367, '25.80', '70.90', 0, '2017-06-17 04:00:00'),
(174, 368, '20.50', '61.30', 0, '2017-06-17 04:00:00'),
(175, 367, '26.00', '70.90', 0, '2017-06-17 05:00:00'),
(176, 368, '20.50', '61.30', 0, '2017-06-17 05:00:00'),
(177, 367, '25.60', '71.30', 0, '2017-06-17 06:00:00'),
(178, 368, '20.50', '61.30', 0, '2017-06-17 06:00:00'),
(179, 367, '25.70', '70.90', 0, '2017-06-17 07:00:00'),
(180, 368, '20.50', '61.30', 0, '2017-06-17 07:00:00'),
(181, 367, '25.60', '70.60', 0, '2017-06-17 08:00:00'),
(182, 368, '20.50', '61.30', 0, '2017-06-17 08:00:00'),
(183, 367, '25.70', '70.40', 0, '2017-06-17 09:00:00'),
(184, 368, '20.50', '61.30', 0, '2017-06-17 09:00:00'),
(185, 367, '25.50', '70.40', 0, '2017-06-17 10:00:00'),
(186, 368, '20.50', '61.30', 0, '2017-06-17 10:00:00'),
(187, 367, '25.60', '70.30', 0, '2017-06-17 11:00:00'),
(188, 368, '20.50', '61.30', 0, '2017-06-17 11:00:00'),
(189, 367, '25.60', '70.70', 0, '2017-06-17 12:00:00'),
(190, 368, '20.50', '61.30', 0, '2017-06-17 12:00:00'),
(191, 367, '25.60', '70.70', 0, '2017-06-17 13:00:00'),
(192, 368, '20.50', '61.30', 0, '2017-06-17 13:00:00'),
(193, 367, '20.40', '61.10', 0, '2017-06-21 12:11:52'),
(194, 368, '20.50', '61.30', 0, '2017-06-21 12:11:52'),
(195, 367, '20.60', '60.50', 0, '2017-06-21 13:00:00'),
(196, 368, '20.50', '61.30', 0, '2017-06-21 13:00:00'),
(197, 367, '20.70', '60.20', 0, '2017-06-21 14:00:00'),
(198, 368, '20.50', '61.30', 0, '2017-06-21 14:00:00'),
(199, 367, '21.10', '60.90', 0, '2017-06-21 15:00:00'),
(200, 367, '21.10', '59.60', 0, '2017-06-21 16:00:00'),
(201, 367, '21.20', '59.60', 0, '2017-06-21 17:00:00'),
(202, 367, '21.30', '59.30', 0, '2017-06-21 18:00:00'),
(203, 367, '21.50', '59.20', 0, '2017-06-21 19:00:00'),
(204, 367, '21.40', '59.50', 0, '2017-06-21 20:00:01'),
(205, 367, '21.30', '60.20', 0, '2017-06-21 21:00:00'),
(206, 367, '21.10', '59.80', 0, '2017-06-21 22:00:00'),
(207, 367, '21.10', '59.50', 0, '2017-06-21 23:00:00'),
(208, 367, '21.40', '61.40', 0, '2017-06-22 00:00:00'),
(209, 367, '21.40', '62.10', 0, '2017-06-22 01:00:00'),
(210, 367, '21.20', '62.00', 0, '2017-06-22 02:00:00'),
(211, 367, '21.10', '61.90', 0, '2017-06-22 03:00:00'),
(212, 367, '21.00', '61.50', 0, '2017-06-22 04:00:00'),
(213, 367, '21.10', '61.50', 0, '2017-06-22 05:00:00'),
(214, 367, '21.10', '61.60', 0, '2017-06-22 06:00:00'),
(215, 367, '21.20', '62.00', 0, '2017-06-22 07:00:00'),
(216, 367, '21.40', '62.60', 0, '2017-06-22 08:00:00'),
(217, 367, '21.30', '63.10', 0, '2017-06-22 09:00:00'),
(218, 367, '21.50', '63.50', 0, '2017-06-22 10:00:00'),
(219, 367, '21.80', '64.60', 0, '2017-06-22 11:00:00'),
(220, 367, '21.60', '64.80', 0, '2017-06-22 12:00:00'),
(221, 367, '21.80', '65.00', 0, '2017-06-22 13:00:00'),
(222, 367, '22.00', '64.80', 0, '2017-06-22 14:00:00'),
(223, 367, '22.10', '65.10', 0, '2017-06-22 15:00:00'),
(224, 367, '22.20', '65.20', 0, '2017-06-22 16:00:00'),
(225, 367, '22.50', '65.20', 0, '2017-06-22 17:00:00'),
(226, 367, '22.60', '65.10', 0, '2017-06-22 18:00:00'),
(227, 367, '22.80', '65.00', 0, '2017-06-22 19:00:00'),
(228, 367, '22.80', '65.00', 0, '2017-06-22 20:00:00'),
(229, 367, '22.70', '64.80', 0, '2017-06-22 21:00:00'),
(230, 367, '22.60', '64.60', 0, '2017-06-22 22:00:00'),
(231, 367, '22.70', '64.40', 0, '2017-06-22 23:00:00'),
(232, 367, '22.80', '66.10', 0, '2017-06-23 00:00:00'),
(233, 367, '22.80', '66.20', 0, '2017-06-23 01:00:00'),
(234, 367, '22.70', '66.70', 0, '2017-06-23 02:00:00'),
(235, 367, '22.70', '66.70', 0, '2017-06-23 03:00:00'),
(236, 367, '22.60', '65.70', 0, '2017-06-23 04:00:00'),
(237, 367, '22.60', '65.20', 0, '2017-06-23 05:00:00'),
(238, 367, '22.70', '65.40', 0, '2017-06-23 06:00:00'),
(239, 367, '22.70', '65.80', 0, '2017-06-23 07:00:00'),
(240, 367, '22.70', '65.00', 0, '2017-06-23 08:00:00'),
(241, 367, '22.60', '64.80', 0, '2017-06-23 09:00:00'),
(242, 367, '22.60', '64.40', 0, '2017-06-23 10:00:00'),
(243, 367, '22.80', '65.20', 0, '2017-06-23 11:00:00'),
(244, 367, '22.60', '65.10', 0, '2017-06-23 12:00:00'),
(245, 367, '22.60', '64.00', 0, '2017-06-23 13:00:00'),
(246, 367, '22.50', '62.90', 0, '2017-06-23 14:00:00'),
(247, 367, '22.50', '60.90', 0, '2017-06-23 15:00:00'),
(248, 367, '22.40', '60.60', 0, '2017-06-23 16:00:00'),
(249, 367, '22.30', '61.20', 0, '2017-06-23 17:00:00'),
(250, 367, '22.30', '60.50', 0, '2017-06-23 18:00:00'),
(251, 367, '22.30', '59.60', 0, '2017-06-23 19:00:00'),
(252, 367, '22.30', '59.40', 0, '2017-06-23 20:00:00'),
(253, 367, '22.30', '59.70', 0, '2017-06-23 21:00:00'),
(254, 367, '22.30', '60.70', 0, '2017-06-23 22:00:00'),
(255, 367, '22.40', '60.20', 0, '2017-06-23 23:00:00'),
(256, 367, '22.50', '62.20', 0, '2017-06-24 00:00:00'),
(257, 367, '22.30', '60.50', 0, '2017-06-24 01:00:00'),
(258, 367, '22.30', '59.90', 0, '2017-06-24 02:00:00'),
(259, 367, '22.40', '59.90', 0, '2017-06-24 03:00:00'),
(260, 367, '22.20', '60.20', 0, '2017-06-24 04:00:00'),
(261, 367, '22.20', '61.10', 0, '2017-06-24 05:00:00'),
(262, 367, '22.20', '61.80', 0, '2017-06-24 06:00:00'),
(263, 367, '22.20', '61.70', 0, '2017-06-24 07:00:00'),
(264, 367, '22.20', '61.30', 0, '2017-06-24 08:00:00'),
(265, 367, '22.10', '60.90', 0, '2017-06-24 09:00:00'),
(266, 367, '22.10', '61.80', 0, '2017-06-24 10:00:00'),
(267, 367, '22.10', '61.90', 0, '2017-06-24 11:00:01'),
(268, 367, '22.20', '62.60', 0, '2017-06-24 12:00:00'),
(269, 367, '22.10', '63.00', 0, '2017-06-24 13:00:00'),
(270, 367, '22.10', '63.00', 0, '2017-06-24 14:00:00'),
(271, 367, '22.20', '61.60', 0, '2017-06-24 15:00:00'),
(272, 367, '22.00', '61.50', 0, '2017-06-24 16:00:00'),
(273, 367, '22.10', '62.20', 0, '2017-06-24 17:00:00'),
(274, 367, '22.00', '63.00', 0, '2017-06-24 18:00:00'),
(275, 367, '22.10', '64.30', 0, '2017-06-24 19:00:00'),
(276, 367, '22.10', '64.90', 0, '2017-06-24 20:00:00'),
(277, 367, '22.20', '65.40', 0, '2017-06-24 21:00:00'),
(278, 367, '22.10', '65.70', 0, '2017-06-24 22:00:00'),
(279, 367, '22.20', '65.70', 0, '2017-06-24 23:00:00'),
(280, 367, '22.20', '65.90', 0, '2017-06-25 00:00:00'),
(281, 367, '22.50', '65.90', 0, '2017-06-25 01:00:00'),
(282, 367, '22.50', '66.70', 0, '2017-06-25 02:00:00'),
(283, 367, '22.50', '67.00', 0, '2017-06-25 03:00:00'),
(284, 367, '22.60', '67.20', 0, '2017-06-25 04:00:00'),
(285, 367, '22.70', '67.70', 0, '2017-06-25 05:00:00'),
(286, 367, '22.70', '67.90', 0, '2017-06-25 06:00:00'),
(287, 367, '22.70', '68.30', 0, '2017-06-25 07:00:00'),
(288, 367, '22.90', '68.40', 0, '2017-06-25 08:00:00'),
(289, 367, '22.90', '68.30', 0, '2017-06-25 09:00:00'),
(290, 367, '23.00', '68.30', 0, '2017-06-25 10:00:00'),
(291, 367, '23.40', '70.70', 0, '2017-06-25 11:00:00'),
(292, 367, '23.20', '71.10', 0, '2017-06-25 12:00:00'),
(293, 367, '23.00', '71.20', 0, '2017-06-25 13:00:00'),
(294, 367, '22.90', '70.70', 0, '2017-06-25 14:00:01'),
(295, 367, '23.00', '70.40', 0, '2017-06-25 15:00:00'),
(296, 367, '23.00', '70.40', 0, '2017-06-25 16:00:00'),
(297, 367, '23.10', '70.30', 0, '2017-06-25 17:00:00'),
(298, 367, '23.10', '70.10', 0, '2017-06-25 18:00:00'),
(299, 367, '23.10', '69.90', 0, '2017-06-25 19:00:00'),
(300, 367, '23.10', '70.10', 0, '2017-06-25 20:00:00'),
(301, 367, '23.10', '70.50', 0, '2017-06-25 21:00:00'),
(302, 367, '23.10', '70.40', 0, '2017-06-25 22:00:00'),
(303, 367, '23.20', '70.50', 0, '2017-06-25 23:00:00'),
(304, 367, '23.10', '70.40', 0, '2017-06-26 00:00:00'),
(305, 367, '23.20', '70.40', 0, '2017-06-26 01:00:00'),
(306, 367, '23.10', '70.30', 0, '2017-06-26 02:00:00'),
(307, 367, '23.10', '70.10', 0, '2017-06-26 03:00:00'),
(308, 367, '23.10', '70.10', 0, '2017-06-26 04:00:00'),
(309, 367, '23.10', '70.30', 0, '2017-06-26 05:00:00'),
(310, 367, '23.20', '70.10', 0, '2017-06-26 06:00:00'),
(311, 367, '23.20', '70.00', 0, '2017-06-26 07:00:00'),
(312, 367, '23.20', '69.70', 0, '2017-06-26 08:00:00'),
(313, 367, '23.20', '69.80', 0, '2017-06-26 09:00:00'),
(314, 367, '23.20', '70.00', 0, '2017-06-26 10:00:00'),
(315, 367, '23.20', '69.90', 0, '2017-06-26 11:00:00'),
(316, 367, '23.30', '70.00', 0, '2017-06-26 12:00:00'),
(317, 367, '23.30', '70.00', 0, '2017-06-26 13:00:00'),
(318, 367, '23.30', '70.10', 0, '2017-06-26 14:00:00'),
(319, 367, '23.10', '73.00', 0, '2017-06-26 15:00:00'),
(320, 367, '23.30', '72.10', 0, '2017-06-26 16:00:00'),
(321, 367, '23.20', '72.20', 0, '2017-06-26 17:00:00'),
(322, 367, '23.40', '71.50', 0, '2017-06-26 18:00:00'),
(323, 367, '23.30', '72.10', 0, '2017-06-26 19:00:00'),
(324, 367, '23.30', '73.20', 0, '2017-06-26 20:00:00'),
(325, 367, '23.10', '74.00', 0, '2017-06-26 21:00:00'),
(326, 367, '23.20', '74.40', 0, '2017-06-26 22:00:00'),
(327, 367, '23.10', '74.60', 0, '2017-06-26 23:00:00'),
(328, 367, '22.70', '70.20', 0, '2017-06-27 00:00:00'),
(329, 367, '22.30', '66.90', 0, '2017-06-27 01:00:00'),
(330, 367, '22.00', '68.10', 0, '2017-06-27 02:00:00'),
(331, 367, '22.00', '68.80', 0, '2017-06-27 03:00:00'),
(332, 367, '22.00', '69.10', 0, '2017-06-27 04:00:01'),
(333, 367, '21.90', '68.90', 0, '2017-06-27 05:00:00'),
(334, 367, '21.60', '67.00', 0, '2017-06-27 06:00:00'),
(335, 367, '21.50', '66.80', 0, '2017-06-27 07:00:00'),
(336, 367, '21.30', '67.00', 0, '2017-06-27 08:00:00'),
(337, 367, '21.30', '67.60', 0, '2017-06-27 09:00:00'),
(338, 367, '20.90', '66.40', 0, '2017-06-27 10:00:00'),
(339, 367, '20.70', '64.90', 0, '2017-06-27 11:00:00'),
(340, 367, '20.30', '64.60', 0, '2017-06-27 12:00:00'),
(341, 367, '20.30', '64.40', 0, '2017-06-27 13:00:00'),
(342, 367, '20.20', '65.50', 0, '2017-06-27 14:00:00'),
(343, 367, '20.20', '65.70', 0, '2017-06-27 15:00:00'),
(344, 367, '20.10', '65.30', 0, '2017-06-27 16:00:00'),
(345, 367, '20.10', '65.30', 0, '2017-06-27 17:00:00'),
(346, 367, '20.10', '65.10', 0, '2017-06-27 18:00:00'),
(347, 367, '20.10', '65.50', 0, '2017-06-27 19:00:00'),
(348, 367, '20.00', '65.90', 0, '2017-06-27 20:00:00'),
(349, 367, '19.90', '66.20', 0, '2017-06-27 21:00:00'),
(350, 367, '19.90', '66.20', 0, '2017-06-27 22:00:00'),
(351, 367, '19.80', '66.20', 0, '2017-06-27 23:00:00'),
(352, 367, '19.70', '65.70', 0, '2017-06-28 00:00:00'),
(353, 367, '19.60', '65.30', 0, '2017-06-28 01:00:00'),
(354, 367, '19.90', '65.30', 0, '2017-06-28 02:00:00'),
(355, 367, '20.20', '66.20', 0, '2017-06-28 03:00:00'),
(356, 367, '20.30', '67.00', 0, '2017-06-28 04:00:00'),
(357, 367, '20.40', '66.50', 0, '2017-06-28 05:00:00'),
(358, 367, '20.50', '67.00', 0, '2017-06-28 06:00:00'),
(359, 367, '20.60', '66.80', 0, '2017-06-28 07:00:00'),
(360, 367, '20.50', '67.00', 0, '2017-06-28 08:00:00'),
(361, 367, '20.50', '67.00', 0, '2017-06-28 09:00:00'),
(362, 367, '20.60', '67.40', 0, '2017-06-28 10:00:00'),
(363, 367, '20.70', '67.50', 0, '2017-06-28 11:00:00'),
(364, 367, '20.80', '68.20', 0, '2017-06-28 12:00:00'),
(365, 367, '21.00', '68.90', 0, '2017-06-28 13:00:00'),
(366, 367, '20.90', '67.70', 0, '2017-06-28 14:00:00'),
(367, 367, '20.90', '65.90', 0, '2017-06-28 15:00:00'),
(368, 367, '21.10', '65.80', 0, '2017-06-28 16:00:00'),
(369, 367, '21.50', '69.60', 0, '2017-06-28 17:00:00'),
(370, 367, '21.80', '69.60', 0, '2017-06-28 18:00:00'),
(371, 367, '21.60', '67.90', 0, '2017-06-28 19:00:01'),
(372, 367, '21.50', '67.50', 0, '2017-06-28 20:00:00'),
(373, 367, '21.50', '67.40', 0, '2017-06-28 21:00:00'),
(374, 367, '21.60', '68.00', 0, '2017-06-28 22:00:00'),
(375, 367, '22.00', '70.50', 0, '2017-06-28 23:00:00'),
(376, 367, '22.30', '72.50', 0, '2017-06-29 00:00:00'),
(377, 367, '22.00', '70.70', 0, '2017-06-29 01:00:00'),
(378, 367, '22.00', '70.10', 0, '2017-06-29 02:00:00'),
(379, 367, '22.00', '69.60', 0, '2017-06-29 03:00:00'),
(380, 367, '22.00', '69.20', 0, '2017-06-29 04:00:00'),
(381, 367, '21.90', '69.00', 0, '2017-06-29 05:00:00'),
(382, 367, '21.80', '68.80', 0, '2017-06-29 06:00:00'),
(383, 367, '21.70', '68.40', 0, '2017-06-29 07:00:00'),
(384, 367, '21.60', '68.30', 0, '2017-06-29 08:00:00'),
(385, 367, '21.70', '68.00', 0, '2017-06-29 09:00:00'),
(386, 367, '21.80', '67.70', 0, '2017-06-29 10:00:00'),
(387, 367, '21.90', '68.60', 0, '2017-06-29 11:00:00'),
(388, 367, '22.40', '68.90', 0, '2017-06-29 12:00:00'),
(389, 367, '21.90', '68.70', 0, '2017-06-29 13:00:00'),
(390, 367, '21.00', '67.90', 0, '2017-06-29 14:00:00'),
(391, 367, '21.80', '66.40', 0, '2017-06-29 15:00:00'),
(392, 367, '22.20', '66.10', 0, '2017-06-29 16:00:00'),
(393, 367, '22.40', '67.70', 0, '2017-06-29 17:00:00'),
(394, 367, '22.40', '68.00', 0, '2017-06-29 18:00:00'),
(395, 367, '22.50', '68.10', 0, '2017-06-29 19:00:00'),
(396, 367, '22.40', '67.50', 0, '2017-06-29 20:00:00'),
(397, 367, '22.40', '67.50', 0, '2017-06-29 21:00:00'),
(398, 367, '22.40', '67.50', 0, '2017-06-29 22:00:00'),
(399, 367, '22.90', '72.20', 0, '2017-06-29 23:00:00'),
(400, 367, '23.40', '74.70', 0, '2017-06-30 00:00:00'),
(401, 367, '23.20', '71.40', 0, '2017-06-30 01:00:00'),
(402, 367, '23.10', '70.00', 0, '2017-06-30 02:00:00'),
(403, 367, '23.10', '69.20', 0, '2017-06-30 03:00:00'),
(404, 367, '23.00', '68.70', 0, '2017-06-30 04:00:00'),
(405, 367, '22.90', '67.80', 0, '2017-06-30 05:00:00'),
(406, 367, '22.70', '67.40', 0, '2017-06-30 06:00:00'),
(407, 367, '22.60', '66.80', 0, '2017-06-30 07:00:00'),
(408, 367, '22.40', '66.60', 0, '2017-06-30 08:00:00'),
(409, 367, '22.40', '66.10', 0, '2017-06-30 09:00:00'),
(410, 367, '22.30', '65.80', 0, '2017-06-30 10:00:00'),
(411, 367, '22.30', '65.70', 0, '2017-06-30 11:00:00'),
(412, 367, '22.50', '65.40', 0, '2017-06-30 12:00:00'),
(413, 367, '23.10', '68.00', 0, '2017-06-30 13:00:00'),
(414, 367, '23.00', '66.20', 0, '2017-06-30 14:00:00'),
(415, 367, '22.80', '63.40', 0, '2017-06-30 15:00:00'),
(416, 367, '22.80', '62.30', 0, '2017-06-30 16:00:00'),
(417, 367, '22.90', '64.00', 0, '2017-06-30 17:00:00'),
(418, 367, '23.00', '64.10', 0, '2017-06-30 18:00:00'),
(419, 367, '23.20', '64.20', 0, '2017-06-30 19:00:00'),
(420, 367, '23.10', '63.80', 0, '2017-06-30 20:00:00'),
(421, 367, '23.10', '64.40', 0, '2017-06-30 21:00:00'),
(422, 367, '23.00', '64.10', 0, '2017-06-30 22:00:00'),
(423, 367, '22.90', '63.20', 0, '2017-06-30 23:00:00'),
(424, 367, '23.60', '66.40', 0, '2017-07-01 00:00:00'),
(425, 367, '23.80', '70.30', 0, '2017-07-01 01:00:00'),
(426, 367, '23.60', '67.60', 0, '2017-07-01 02:00:00'),
(427, 367, '23.40', '66.60', 0, '2017-07-01 03:00:00'),
(428, 367, '23.10', '66.30', 0, '2017-07-01 04:00:00'),
(429, 367, '23.10', '66.30', 0, '2017-07-01 05:00:00'),
(430, 367, '23.10', '66.10', 0, '2017-07-01 06:00:00'),
(431, 367, '22.90', '65.80', 0, '2017-07-01 07:00:00'),
(432, 367, '22.90', '65.70', 0, '2017-07-01 08:00:00'),
(433, 367, '22.90', '65.80', 0, '2017-07-01 09:00:00'),
(434, 367, '22.90', '65.80', 0, '2017-07-01 10:00:00'),
(435, 367, '23.00', '65.80', 0, '2017-07-01 11:00:00'),
(436, 367, '23.00', '66.10', 0, '2017-07-01 12:00:00'),
(437, 367, '23.00', '65.80', 0, '2017-07-01 13:00:00'),
(438, 367, '23.10', '66.40', 0, '2017-07-01 14:00:00'),
(439, 367, '23.30', '66.40', 0, '2017-07-01 15:00:00'),
(440, 367, '22.10', '60.00', 0, '2017-07-01 16:00:00'),
(441, 367, '22.90', '64.60', 0, '2017-07-01 17:00:00'),
(442, 367, '23.00', '64.70', 0, '2017-07-01 18:00:00'),
(443, 367, '23.00', '63.70', 0, '2017-07-01 19:00:00'),
(444, 367, '23.00', '64.70', 0, '2017-07-01 20:00:00'),
(445, 367, '23.50', '67.60', 0, '2017-07-01 21:00:00'),
(446, 367, '23.10', '68.00', 0, '2017-07-01 22:00:00'),
(447, 367, '23.50', '69.70', 0, '2017-07-01 23:00:00'),
(448, 367, '23.10', '67.90', 0, '2017-07-02 00:00:00'),
(449, 367, '23.00', '67.40', 0, '2017-07-02 01:00:00'),
(450, 367, '22.90', '66.60', 0, '2017-07-02 02:00:00'),
(451, 367, '22.90', '66.40', 0, '2017-07-02 03:00:00'),
(452, 367, '22.80', '66.10', 0, '2017-07-02 04:00:00'),
(453, 367, '22.80', '65.80', 0, '2017-07-02 05:00:00'),
(454, 367, '22.80', '65.60', 0, '2017-07-02 06:00:00'),
(455, 367, '22.70', '65.30', 0, '2017-07-02 07:00:00'),
(456, 367, '22.80', '65.00', 0, '2017-07-02 08:00:00'),
(457, 367, '22.70', '65.70', 0, '2017-07-02 09:00:00'),
(458, 367, '22.90', '65.80', 0, '2017-07-02 10:00:00'),
(459, 367, '22.80', '66.10', 0, '2017-07-02 11:00:00'),
(460, 367, '22.70', '66.90', 0, '2017-07-02 12:00:00'),
(461, 367, '22.80', '67.00', 0, '2017-07-02 13:00:00'),
(462, 367, '23.00', '67.50', 0, '2017-07-02 14:00:00'),
(463, 367, '23.40', '67.80', 0, '2017-07-02 15:00:00'),
(464, 367, '23.40', '68.80', 0, '2017-07-02 16:00:00'),
(465, 367, '23.50', '69.00', 0, '2017-07-02 17:00:00'),
(466, 367, '23.50', '64.90', 0, '2017-07-02 18:00:00'),
(467, 367, '23.60', '65.50', 0, '2017-07-02 19:00:00'),
(468, 367, '23.60', '65.80', 0, '2017-07-02 20:00:00'),
(469, 367, '23.60', '66.40', 0, '2017-07-02 21:00:00'),
(470, 367, '23.70', '66.60', 0, '2017-07-02 22:00:00'),
(471, 367, '23.60', '66.50', 0, '2017-07-02 23:00:01'),
(472, 367, '23.60', '66.10', 0, '2017-07-03 00:00:00'),
(473, 367, '23.50', '65.90', 0, '2017-07-03 01:00:00'),
(474, 367, '23.60', '66.00', 0, '2017-07-03 02:00:00'),
(475, 367, '23.40', '65.60', 0, '2017-07-03 03:00:00'),
(476, 367, '23.40', '65.50', 0, '2017-07-03 04:00:00'),
(477, 367, '23.40', '65.70', 0, '2017-07-03 05:00:00'),
(478, 367, '23.20', '65.30', 0, '2017-07-03 06:00:00'),
(479, 367, '23.10', '64.60', 0, '2017-07-03 07:00:00'),
(480, 367, '23.00', '63.50', 0, '2017-07-03 08:00:00'),
(481, 367, '22.90', '62.80', 0, '2017-07-03 09:00:00'),
(482, 367, '22.90', '63.10', 0, '2017-07-03 10:00:00'),
(483, 367, '23.00', '64.50', 0, '2017-07-03 11:00:00'),
(484, 367, '22.90', '63.50', 0, '2017-07-03 12:00:00'),
(485, 367, '22.90', '63.90', 0, '2017-07-03 13:00:00'),
(486, 367, '22.90', '62.40', 0, '2017-07-03 14:00:00'),
(487, 367, '22.50', '60.00', 0, '2017-07-03 15:00:00'),
(488, 367, '22.90', '59.20', 0, '2017-07-03 16:00:00'),
(489, 367, '22.80', '58.50', 0, '2017-07-03 17:00:00'),
(490, 367, '22.90', '59.10', 0, '2017-07-03 18:00:00'),
(491, 367, '23.10', '60.00', 0, '2017-07-03 19:00:00'),
(492, 367, '23.30', '62.30', 0, '2017-07-03 20:00:00'),
(493, 367, '23.40', '64.30', 0, '2017-07-03 21:00:00'),
(494, 367, '23.30', '64.20', 0, '2017-07-03 22:00:00'),
(495, 367, '23.20', '63.50', 0, '2017-07-03 23:00:00'),
(496, 367, '23.80', '67.60', 0, '2017-07-04 00:00:00'),
(497, 367, '23.30', '64.10', 0, '2017-07-04 01:00:00'),
(498, 367, '23.10', '62.90', 0, '2017-07-04 02:00:01'),
(499, 367, '23.00', '62.60', 0, '2017-07-04 03:00:00'),
(500, 367, '23.00', '62.30', 0, '2017-07-04 04:00:00'),
(501, 367, '22.90', '62.60', 0, '2017-07-04 05:00:00'),
(502, 367, '22.90', '62.90', 0, '2017-07-04 06:00:00'),
(503, 367, '22.90', '62.90', 0, '2017-07-04 07:00:00'),
(504, 367, '22.90', '63.60', 0, '2017-07-04 08:00:00'),
(505, 367, '22.90', '64.20', 0, '2017-07-04 09:00:00'),
(506, 367, '23.00', '64.20', 0, '2017-07-04 10:00:00'),
(507, 367, '23.10', '64.00', 0, '2017-07-04 11:00:00'),
(508, 367, '22.90', '62.90', 0, '2017-07-04 12:00:00'),
(509, 367, '22.90', '64.20', 0, '2017-07-04 13:00:01'),
(510, 367, '23.10', '64.50', 0, '2017-07-04 14:00:00'),
(511, 367, '22.90', '63.40', 0, '2017-07-04 15:00:00'),
(512, 367, '23.00', '63.30', 0, '2017-07-04 16:00:00'),
(513, 367, '23.00', '63.60', 0, '2017-07-04 17:00:00'),
(514, 367, '23.10', '64.10', 0, '2017-07-04 18:00:00'),
(515, 367, '23.30', '64.60', 0, '2017-07-04 19:00:00'),
(516, 367, '23.30', '65.00', 0, '2017-07-04 20:00:00'),
(517, 367, '23.50', '65.10', 0, '2017-07-04 21:00:00'),
(518, 367, '23.70', '65.50', 0, '2017-07-04 22:00:00'),
(519, 367, '23.50', '65.60', 0, '2017-07-04 23:00:00'),
(520, 367, '23.70', '67.50', 0, '2017-07-05 00:00:00'),
(521, 367, '23.40', '66.30', 0, '2017-07-05 01:00:00'),
(522, 367, '23.30', '65.70', 0, '2017-07-05 02:00:00'),
(523, 367, '23.20', '65.50', 0, '2017-07-05 03:00:00'),
(524, 367, '23.20', '65.40', 0, '2017-07-05 04:00:00'),
(525, 367, '23.20', '65.50', 0, '2017-07-05 05:00:00'),
(526, 367, '23.10', '65.50', 0, '2017-07-05 06:00:00'),
(527, 367, '23.10', '65.50', 0, '2017-07-05 07:00:00'),
(528, 367, '23.00', '65.30', 0, '2017-07-05 08:00:00'),
(529, 367, '23.00', '65.10', 0, '2017-07-05 09:00:00'),
(530, 367, '23.00', '65.60', 0, '2017-07-05 10:00:00'),
(531, 367, '23.00', '66.10', 0, '2017-07-05 11:00:00'),
(532, 367, '23.00', '66.90', 0, '2017-07-05 12:00:00'),
(533, 367, '23.10', '68.10', 0, '2017-07-05 13:00:00'),
(534, 367, '23.10', '67.10', 0, '2017-07-05 14:00:00'),
(535, 367, '23.20', '67.90', 0, '2017-07-05 15:00:00'),
(536, 367, '23.30', '68.00', 0, '2017-07-05 16:00:01'),
(537, 367, '23.20', '68.20', 0, '2017-07-05 17:00:00'),
(538, 367, '23.30', '66.80', 0, '2017-07-05 18:00:00'),
(539, 367, '23.50', '65.60', 0, '2017-07-05 19:00:00'),
(540, 367, '23.30', '63.80', 0, '2017-07-05 20:00:00'),
(541, 367, '23.50', '64.50', 0, '2017-07-05 21:00:00'),
(542, 367, '23.10', '61.10', 0, '2017-07-05 22:00:00'),
(543, 367, '23.50', '62.70', 0, '2017-07-05 23:00:00'),
(544, 367, '23.60', '62.60', 0, '2017-07-06 00:00:00'),
(545, 367, '23.40', '63.00', 0, '2017-07-06 01:00:00'),
(546, 367, '23.20', '62.50', 0, '2017-07-06 02:00:00'),
(547, 367, '23.10', '62.50', 0, '2017-07-06 03:00:00'),
(548, 367, '23.00', '62.70', 0, '2017-07-06 04:00:00'),
(549, 367, '23.00', '62.50', 0, '2017-07-06 05:00:00'),
(550, 367, '23.00', '62.10', 0, '2017-07-06 06:00:00'),
(551, 367, '22.90', '61.90', 0, '2017-07-06 07:00:00'),
(552, 367, '22.80', '61.50', 0, '2017-07-06 08:00:00'),
(553, 367, '22.70', '60.80', 0, '2017-07-06 09:00:00'),
(554, 367, '22.70', '60.50', 0, '2017-07-06 10:00:00'),
(555, 367, '22.70', '60.10', 0, '2017-07-06 11:00:00'),
(556, 367, '22.70', '60.30', 0, '2017-07-06 12:00:00'),
(557, 367, '22.80', '63.10', 0, '2017-07-06 13:00:00'),
(558, 367, '22.80', '63.20', 0, '2017-07-06 14:00:00'),
(559, 367, '22.80', '62.50', 0, '2017-07-06 15:00:00'),
(560, 367, '22.90', '62.30', 0, '2017-07-06 16:00:00'),
(561, 367, '23.10', '62.30', 0, '2017-07-06 17:00:01'),
(562, 367, '23.20', '61.90', 0, '2017-07-06 18:00:00'),
(563, 367, '23.20', '61.40', 0, '2017-07-06 19:00:00'),
(564, 367, '23.40', '63.70', 0, '2017-07-06 20:00:00'),
(565, 367, '23.70', '65.00', 0, '2017-07-06 21:00:00'),
(566, 367, '23.60', '64.10', 0, '2017-07-06 22:00:00'),
(567, 367, '23.40', '63.30', 0, '2017-07-06 23:00:00'),
(568, 367, '23.50', '62.20', 0, '2017-07-07 00:00:01'),
(569, 367, '23.40', '61.70', 0, '2017-07-07 01:00:00'),
(570, 367, '23.20', '61.60', 0, '2017-07-07 02:00:01'),
(571, 367, '23.10', '61.00', 0, '2017-07-07 03:00:00'),
(572, 367, '23.10', '60.40', 0, '2017-07-07 04:00:00'),
(573, 367, '23.00', '59.80', 0, '2017-07-07 05:00:01'),
(574, 367, '23.00', '59.70', 0, '2017-07-07 06:00:01'),
(575, 367, '22.90', '59.50', 0, '2017-07-07 07:00:00'),
(576, 367, '22.80', '58.80', 0, '2017-07-07 08:00:00'),
(577, 367, '22.70', '58.80', 0, '2017-07-07 09:00:01'),
(578, 367, '22.70', '59.00', 0, '2017-07-07 10:00:00'),
(579, 367, '22.80', '59.20', 0, '2017-07-07 11:00:00'),
(580, 367, '22.70', '60.70', 0, '2017-07-07 12:00:00'),
(581, 367, '22.80', '61.60', 0, '2017-07-07 13:00:00'),
(582, 367, '22.80', '59.40', 0, '2017-07-07 14:00:00'),
(583, 367, '22.80', '57.60', 0, '2017-07-07 15:00:00'),
(584, 367, '23.00', '59.20', 0, '2017-07-07 16:00:00'),
(585, 367, '22.90', '57.90', 0, '2017-07-07 17:00:00'),
(586, 367, '22.90', '57.40', 0, '2017-07-07 18:00:00'),
(587, 367, '22.90', '56.30', 0, '2017-07-07 19:00:00'),
(588, 367, '22.90', '57.40', 0, '2017-07-07 20:00:00'),
(589, 367, '22.90', '58.00', 0, '2017-07-07 21:00:00'),
(590, 367, '23.00', '59.70', 0, '2017-07-07 22:00:00'),
(591, 367, '22.90', '59.40', 0, '2017-07-07 23:00:01'),
(592, 367, '23.00', '58.10', 0, '2017-07-08 00:00:00'),
(593, 367, '22.70', '59.20', 0, '2017-07-08 01:00:00'),
(594, 367, '22.50', '58.60', 0, '2017-07-08 02:00:00'),
(595, 367, '22.30', '57.60', 0, '2017-07-08 03:00:00'),
(596, 367, '22.30', '58.60', 0, '2017-07-08 04:00:00'),
(597, 367, '22.10', '59.50', 0, '2017-07-08 05:00:00'),
(598, 367, '22.00', '60.20', 0, '2017-07-08 06:00:00'),
(599, 367, '22.00', '61.20', 0, '2017-07-08 07:00:00'),
(600, 367, '22.10', '62.10', 0, '2017-07-08 08:00:00'),
(601, 367, '22.10', '62.50', 0, '2017-07-08 09:00:00'),
(602, 367, '22.20', '62.60', 0, '2017-07-08 10:00:00'),
(603, 367, '22.20', '63.00', 0, '2017-07-08 11:00:00'),
(604, 367, '22.20', '63.70', 0, '2017-07-08 12:00:00'),
(605, 367, '22.20', '64.00', 0, '2017-07-08 13:00:00'),
(606, 367, '22.30', '64.00', 0, '2017-07-08 14:00:00'),
(607, 367, '22.30', '63.50', 0, '2017-07-08 15:00:00'),
(608, 367, '22.30', '63.30', 0, '2017-07-08 16:00:00'),
(609, 367, '22.30', '63.20', 0, '2017-07-08 17:00:00'),
(610, 367, '22.30', '63.60', 0, '2017-07-08 18:00:00'),
(611, 367, '22.40', '63.90', 0, '2017-07-08 19:00:00'),
(612, 367, '22.50', '64.20', 0, '2017-07-08 20:00:00'),
(613, 367, '22.50', '65.20', 0, '2017-07-08 21:00:00'),
(614, 367, '22.50', '65.10', 0, '2017-07-08 22:00:00'),
(615, 367, '22.60', '65.10', 0, '2017-07-08 23:00:00'),
(616, 367, '22.70', '64.80', 0, '2017-07-09 00:00:00'),
(617, 367, '22.60', '64.70', 0, '2017-07-09 01:00:00'),
(618, 367, '22.80', '64.70', 0, '2017-07-09 02:00:01'),
(619, 367, '22.70', '64.90', 0, '2017-07-09 03:00:00'),
(620, 367, '22.70', '63.90', 0, '2017-07-09 04:00:00'),
(621, 367, '22.70', '63.60', 0, '2017-07-09 05:00:00'),
(622, 367, '22.60', '63.40', 0, '2017-07-09 06:00:00'),
(623, 367, '22.50', '63.10', 0, '2017-07-09 07:00:00'),
(624, 367, '22.60', '63.10', 0, '2017-07-09 08:00:00'),
(625, 367, '22.50', '63.00', 0, '2017-07-09 09:00:00'),
(626, 367, '22.60', '63.10', 0, '2017-07-09 10:00:00'),
(627, 367, '22.60', '62.90', 0, '2017-07-09 11:00:00'),
(628, 367, '22.60', '63.30', 0, '2017-07-09 12:00:00'),
(629, 367, '22.70', '63.90', 0, '2017-07-09 13:00:00'),
(630, 367, '22.80', '63.80', 0, '2017-07-09 14:00:00'),
(631, 367, '22.80', '65.10', 0, '2017-07-09 15:00:00'),
(632, 367, '22.80', '64.40', 0, '2017-07-09 16:00:00'),
(633, 367, '22.80', '63.60', 0, '2017-07-09 17:00:00'),
(634, 367, '22.90', '63.40', 0, '2017-07-09 18:00:00'),
(635, 367, '22.90', '63.40', 0, '2017-07-09 19:00:00'),
(636, 367, '22.90', '63.50', 0, '2017-07-09 20:00:00'),
(637, 367, '23.00', '63.70', 0, '2017-07-09 21:00:00'),
(638, 367, '23.20', '64.00', 0, '2017-07-09 22:00:01'),
(639, 367, '23.20', '64.40', 0, '2017-07-09 23:00:00'),
(640, 367, '23.00', '64.40', 0, '2017-07-10 00:00:00'),
(641, 367, '22.80', '63.40', 0, '2017-07-10 01:00:00'),
(642, 367, '22.70', '62.50', 0, '2017-07-10 02:00:00'),
(643, 367, '22.60', '62.00', 0, '2017-07-10 03:00:00'),
(644, 367, '22.50', '61.30', 0, '2017-07-10 04:00:00'),
(645, 367, '22.40', '61.00', 0, '2017-07-10 05:00:00'),
(646, 367, '22.30', '60.50', 0, '2017-07-10 06:00:00'),
(647, 367, '22.20', '60.00', 0, '2017-07-10 07:00:00'),
(648, 367, '22.10', '59.50', 0, '2017-07-10 08:00:00'),
(649, 367, '22.20', '59.50', 0, '2017-07-10 09:00:00'),
(650, 367, '22.30', '61.10', 0, '2017-07-10 10:00:00'),
(651, 367, '22.40', '62.50', 0, '2017-07-10 11:00:00'),
(652, 367, '22.20', '61.90', 0, '2017-07-10 12:00:00'),
(653, 367, '22.30', '63.00', 0, '2017-07-10 13:00:00'),
(654, 367, '15.50', '66.00', 0, '2017-07-10 14:00:00'),
(655, 367, '18.40', '63.80', 0, '2017-07-10 15:00:00'),
(656, 367, '20.10', '61.10', 0, '2017-07-10 16:00:00'),
(657, 367, '20.50', '61.00', 0, '2017-07-10 17:00:00'),
(658, 367, '20.70', '60.60', 0, '2017-07-10 18:00:00'),
(659, 367, '20.90', '60.20', 0, '2017-07-10 19:00:00'),
(660, 367, '20.80', '59.90', 0, '2017-07-10 20:00:00'),
(661, 367, '21.10', '60.10', 0, '2017-07-10 21:00:00'),
(662, 367, '21.10', '60.10', 0, '2017-07-10 22:00:00'),
(663, 367, '21.20', '60.30', 0, '2017-07-10 23:00:00'),
(664, 367, '21.80', '62.90', 0, '2017-07-11 00:00:00'),
(665, 367, '21.70', '62.90', 0, '2017-07-11 01:00:00'),
(666, 367, '21.60', '63.00', 0, '2017-07-11 02:00:00'),
(667, 367, '21.50', '63.10', 0, '2017-07-11 03:00:00'),
(668, 367, '21.50', '62.70', 0, '2017-07-11 04:00:00'),
(669, 367, '21.40', '62.30', 0, '2017-07-11 05:00:00'),
(670, 367, '21.50', '61.90', 0, '2017-07-11 06:00:00'),
(671, 367, '21.40', '61.60', 0, '2017-07-11 07:00:00'),
(672, 367, '21.40', '61.20', 0, '2017-07-11 08:00:00'),
(673, 367, '21.30', '61.00', 0, '2017-07-11 09:00:00'),
(674, 367, '21.40', '61.10', 0, '2017-07-11 10:00:00'),
(675, 367, '21.50', '61.60', 0, '2017-07-11 11:00:00'),
(676, 367, '21.40', '61.80', 0, '2017-07-11 12:00:00'),
(677, 367, '21.20', '61.30', 0, '2017-07-11 13:00:00'),
(678, 367, '21.10', '60.50', 0, '2017-07-11 14:00:00'),
(679, 367, '21.00', '60.10', 0, '2017-07-11 15:00:00'),
(680, 367, '21.10', '59.60', 0, '2017-07-11 16:00:00'),
(681, 367, '21.00', '58.70', 0, '2017-07-11 17:00:00'),
(682, 367, '21.10', '58.10', 0, '2017-07-11 18:00:00'),
(683, 367, '21.10', '57.90', 0, '2017-07-11 19:00:00'),
(684, 367, '21.20', '58.30', 0, '2017-07-11 20:00:00'),
(685, 367, '21.30', '59.60', 0, '2017-07-11 21:00:00'),
(686, 367, '21.20', '59.80', 0, '2017-07-11 22:00:00'),
(687, 367, '21.20', '60.00', 0, '2017-07-11 23:00:00'),
(688, 367, '21.30', '60.70', 0, '2017-07-12 00:00:00'),
(689, 367, '21.40', '61.90', 0, '2017-07-12 01:00:01'),
(690, 367, '21.40', '61.50', 0, '2017-07-12 02:00:00'),
(691, 367, '21.30', '62.10', 0, '2017-07-12 03:00:00'),
(692, 367, '21.30', '62.10', 0, '2017-07-12 04:00:00'),
(693, 367, '21.30', '62.20', 0, '2017-07-12 05:00:00'),
(694, 367, '21.30', '62.20', 0, '2017-07-12 06:00:00'),
(695, 367, '21.30', '62.30', 0, '2017-07-12 07:00:00'),
(696, 367, '21.20', '62.50', 0, '2017-07-12 08:00:00'),
(697, 367, '21.20', '62.70', 0, '2017-07-12 09:00:00'),
(698, 367, '21.20', '62.90', 0, '2017-07-12 10:00:00'),
(699, 367, '21.40', '63.90', 0, '2017-07-12 11:00:00'),
(700, 367, '21.40', '63.80', 0, '2017-07-12 12:00:00'),
(701, 367, '21.50', '64.60', 0, '2017-07-12 13:00:00'),
(702, 367, '20.10', '68.90', 0, '2017-07-12 14:00:00'),
(703, 367, '21.50', '65.40', 0, '2017-07-12 15:00:00'),
(704, 367, '21.70', '65.00', 0, '2017-07-12 16:00:00'),
(705, 367, '21.80', '65.20', 0, '2017-07-12 17:00:00'),
(706, 367, '21.80', '65.50', 0, '2017-07-12 18:00:00'),
(707, 367, '22.00', '65.60', 0, '2017-07-12 19:00:00'),
(708, 367, '22.00', '65.70', 0, '2017-07-12 20:00:00'),
(709, 367, '22.10', '66.20', 0, '2017-07-12 21:00:00'),
(710, 367, '22.20', '66.10', 0, '2017-07-12 22:00:00'),
(711, 367, '22.30', '66.30', 0, '2017-07-12 23:00:00'),
(712, 367, '22.50', '67.40', 0, '2017-07-13 00:00:00'),
(713, 367, '22.50', '67.30', 0, '2017-07-13 01:00:00'),
(714, 367, '22.50', '67.30', 0, '2017-07-13 02:00:00'),
(715, 367, '22.60', '67.40', 0, '2017-07-13 03:00:00'),
(716, 367, '22.70', '67.40', 0, '2017-07-13 04:00:00'),
(717, 367, '22.70', '67.70', 0, '2017-07-13 05:00:00'),
(718, 367, '22.80', '68.00', 0, '2017-07-13 06:00:00'),
(719, 367, '22.90', '68.10', 0, '2017-07-13 07:00:00'),
(720, 367, '23.00', '68.30', 0, '2017-07-13 08:00:00'),
(721, 367, '23.10', '68.50', 0, '2017-07-13 09:00:00'),
(722, 367, '23.20', '69.00', 0, '2017-07-13 10:00:00'),
(723, 367, '23.50', '70.20', 0, '2017-07-13 11:00:00'),
(724, 367, '23.40', '69.80', 0, '2017-07-13 12:00:00'),
(725, 367, '22.40', '73.30', 0, '2017-07-13 13:00:00'),
(726, 367, '23.40', '70.50', 0, '2017-07-13 14:00:00'),
(727, 367, '23.40', '70.20', 0, '2017-07-13 15:00:00'),
(728, 367, '23.40', '69.80', 0, '2017-07-13 16:00:00'),
(729, 367, '23.60', '69.90', 0, '2017-07-13 17:00:00'),
(730, 367, '23.60', '69.20', 0, '2017-07-13 18:00:00'),
(731, 367, '23.60', '68.80', 0, '2017-07-13 19:00:00'),
(732, 367, '23.80', '68.50', 0, '2017-07-13 20:00:00'),
(733, 367, '23.80', '68.10', 0, '2017-07-13 21:00:00'),
(734, 367, '23.70', '68.30', 0, '2017-07-13 22:00:00'),
(735, 367, '23.90', '68.20', 0, '2017-07-13 23:00:00'),
(736, 367, '23.70', '67.90', 0, '2017-07-14 00:00:00'),
(737, 367, '23.70', '67.30', 0, '2017-07-14 01:00:00'),
(738, 367, '23.50', '66.70', 0, '2017-07-14 02:00:00'),
(739, 367, '23.60', '67.10', 0, '2017-07-14 03:00:00'),
(740, 367, '23.60', '67.60', 0, '2017-07-14 04:00:00'),
(741, 367, '23.50', '67.50', 0, '2017-07-14 05:00:00'),
(742, 367, '23.40', '67.00', 0, '2017-07-14 06:00:00'),
(743, 367, '23.20', '66.30', 0, '2017-07-14 07:00:00'),
(744, 367, '23.10', '65.80', 0, '2017-07-14 08:00:00'),
(745, 367, '23.00', '65.10', 0, '2017-07-14 09:00:00'),
(746, 367, '23.10', '65.30', 0, '2017-07-14 10:00:00'),
(747, 367, '22.80', '64.70', 0, '2017-07-14 11:00:00'),
(748, 367, '22.80', '63.20', 0, '2017-07-14 12:00:00'),
(749, 367, '22.80', '63.40', 0, '2017-07-14 13:00:00'),
(750, 367, '22.70', '63.10', 0, '2017-07-14 14:00:00'),
(751, 367, '22.80', '61.90', 0, '2017-07-14 15:00:00'),
(752, 367, '22.80', '61.30', 0, '2017-07-14 16:00:00'),
(753, 367, '23.00', '61.10', 0, '2017-07-14 17:00:00'),
(754, 367, '22.90', '60.70', 0, '2017-07-14 18:00:00'),
(755, 367, '22.80', '59.60', 0, '2017-07-14 19:00:00'),
(756, 367, '23.10', '59.40', 0, '2017-07-14 20:00:00'),
(757, 367, '23.10', '60.10', 0, '2017-07-14 21:00:00'),
(758, 367, '23.10', '60.40', 0, '2017-07-14 22:00:00'),
(759, 367, '23.10', '60.40', 0, '2017-07-14 23:00:00'),
(760, 367, '23.10', '60.70', 0, '2017-07-15 00:00:00'),
(761, 367, '23.20', '61.50', 0, '2017-07-15 01:00:00'),
(762, 367, '23.20', '62.10', 0, '2017-07-15 02:00:00'),
(763, 367, '23.00', '62.10', 0, '2017-07-15 03:00:00'),
(764, 367, '22.90', '61.90', 0, '2017-07-15 04:00:00'),
(765, 367, '23.00', '61.90', 0, '2017-07-15 05:00:00'),
(766, 367, '22.90', '62.10', 0, '2017-07-15 06:00:00'),
(767, 367, '23.00', '62.30', 0, '2017-07-15 07:00:00'),
(768, 367, '23.10', '62.50', 0, '2017-07-15 08:00:00'),
(769, 367, '23.10', '62.70', 0, '2017-07-15 09:00:00'),
(770, 367, '23.20', '63.00', 0, '2017-07-15 10:00:00'),
(771, 367, '23.30', '63.30', 0, '2017-07-15 11:00:00'),
(772, 367, '23.30', '63.90', 0, '2017-07-15 12:00:01'),
(773, 367, '23.00', '63.60', 0, '2017-07-15 13:00:00'),
(774, 367, '23.10', '64.30', 0, '2017-07-15 14:00:00'),
(775, 367, 'nan', 'nan', 0, '2017-07-15 14:02:21'),
(776, 367, '24.70', '89.00', 0, '2017-07-15 14:02:25'),
(777, 367, '24.40', '94.20', 0, '2017-07-15 14:02:28'),
(778, 367, '24.30', '98.40', 0, '2017-07-15 14:02:30'),
(779, 367, '24.20', '98.60', 0, '2017-07-15 14:02:32'),
(780, 367, '24.20', '98.60', 0, '2017-07-15 14:02:34'),
(781, 367, '24.10', '98.60', 0, '2017-07-15 14:02:37'),
(782, 367, '23.90', '98.60', 0, '2017-07-15 14:02:39'),
(783, 367, '23.90', '98.60', 0, '2017-07-15 14:02:41'),
(784, 367, '23.80', '98.60', 0, '2017-07-15 14:02:44'),
(785, 367, '23.80', '98.60', 0, '2017-07-15 14:02:46'),
(786, 367, '23.80', '98.60', 0, '2017-07-15 14:02:48'),
(787, 367, '23.70', '98.60', 0, '2017-07-15 14:02:51'),
(788, 367, '23.60', '98.60', 0, '2017-07-15 14:02:53'),
(789, 367, '23.60', '98.60', 0, '2017-07-15 14:02:55'),
(790, 367, '23.60', '98.60', 0, '2017-07-15 14:02:57'),
(791, 367, '23.70', '96.20', 0, '2017-07-15 14:03:00'),
(792, 367, '23.70', '93.80', 0, '2017-07-15 14:03:02'),
(793, 367, '23.70', '90.80', 0, '2017-07-15 14:03:04'),
(794, 367, '23.70', '87.60', 0, '2017-07-15 14:03:07'),
(795, 367, '23.80', '84.20', 0, '2017-07-15 14:03:09'),
(796, 367, '23.80', '81.00', 0, '2017-07-15 14:03:11'),
(797, 367, '22.90', '62.70', 0, '2017-07-15 15:00:01'),
(798, 367, '22.90', '62.70', 0, '2017-07-15 15:04:26'),
(799, 367, '22.90', '62.70', 0, '2017-07-15 15:04:29'),
(800, 367, '23.00', '62.70', 0, '2017-07-15 15:04:31'),
(801, 367, '23.00', '62.70', 0, '2017-07-15 15:04:33'),
(802, 367, '23.00', '62.70', 0, '2017-07-15 15:04:36'),
(803, 367, '22.90', '62.70', 0, '2017-07-15 15:04:38'),
(804, 367, '22.90', '62.70', 0, '2017-07-15 15:04:40'),
(805, 367, '23.00', '62.70', 0, '2017-07-15 15:04:42'),
(806, 367, '23.00', '62.70', 0, '2017-07-15 15:04:45'),
(807, 367, '23.00', '62.70', 0, '2017-07-15 15:04:47'),
(808, 367, '22.90', '62.70', 0, '2017-07-15 15:04:49'),
(809, 367, '23.00', '62.40', 0, '2017-07-15 15:26:43'),
(810, 367, '23.20', '62.00', 0, '2017-07-15 16:00:00'),
(811, 367, '23.40', '65.50', 0, '2017-07-15 16:39:45'),
(812, 367, '23.40', '64.30', 0, '2017-07-15 17:00:00'),
(813, 367, '23.20', '63.00', 0, '2017-07-15 18:00:00'),
(814, 367, '23.10', '61.40', 0, '2017-07-15 19:00:00'),
(815, 367, '23.00', '60.60', 0, '2017-07-15 20:00:00'),
(816, 367, '23.10', '60.90', 0, '2017-07-15 21:00:00'),
(817, 367, '23.20', '60.30', 0, '2017-07-15 22:00:00'),
(818, 367, '23.20', '60.30', 0, '2017-07-15 23:00:00'),
(819, 367, '23.20', '60.10', 0, '2017-07-16 00:00:00'),
(820, 367, '23.00', '59.00', 0, '2017-07-16 01:00:00'),
(821, 367, '22.80', '58.10', 0, '2017-07-16 02:00:00'),
(822, 367, '22.80', '57.50', 0, '2017-07-16 03:00:00'),
(823, 367, '22.30', '56.90', 0, '2017-07-16 04:00:00'),
(824, 367, '22.00', '56.20', 0, '2017-07-16 05:00:00'),
(825, 367, '21.90', '56.00', 0, '2017-07-16 06:00:00'),
(826, 367, '21.50', '55.90', 0, '2017-07-16 07:00:00'),
(827, 367, '21.30', '55.70', 0, '2017-07-16 08:00:00'),
(828, 367, '21.20', '55.60', 0, '2017-07-16 09:00:00'),
(829, 367, '21.10', '55.40', 0, '2017-07-16 10:00:00'),
(830, 367, '20.90', '55.30', 0, '2017-07-16 11:00:00'),
(831, 367, '20.70', '55.90', 0, '2017-07-16 12:00:00'),
(832, 367, '20.60', '55.60', 0, '2017-07-16 13:00:00'),
(833, 367, '20.70', '57.00', 0, '2017-07-16 14:00:00'),
(834, 367, '20.40', '55.70', 0, '2017-07-16 15:00:00'),
(835, 367, '20.30', '55.30', 0, '2017-07-16 16:00:00'),
(836, 367, '20.10', '54.80', 0, '2017-07-16 17:00:00'),
(837, 367, '20.20', '55.40', 0, '2017-07-16 18:00:00'),
(838, 367, '20.30', '55.80', 0, '2017-07-16 19:00:00'),
(839, 367, '20.30', '55.70', 0, '2017-07-16 20:00:00'),
(840, 367, '20.30', '56.70', 0, '2017-07-16 21:00:00'),
(841, 367, '20.30', '57.00', 0, '2017-07-16 22:00:00'),
(842, 367, '20.40', '57.20', 0, '2017-07-16 23:00:00'),
(843, 367, '20.50', '57.10', 0, '2017-07-17 00:00:00'),
(844, 367, '20.30', '56.50', 0, '2017-07-17 01:00:00'),
(845, 367, '20.30', '56.50', 0, '2017-07-17 02:00:00'),
(846, 367, '20.30', '56.40', 0, '2017-07-17 03:00:00'),
(847, 367, '20.20', '56.30', 0, '2017-07-17 04:00:00'),
(848, 367, '20.20', '56.10', 0, '2017-07-17 05:00:00'),
(849, 367, '20.00', '56.00', 0, '2017-07-17 06:00:00'),
(850, 367, '20.10', '55.70', 0, '2017-07-17 07:00:00'),
(851, 367, '20.10', '54.70', 0, '2017-07-17 08:00:00'),
(852, 367, '20.00', '53.70', 0, '2017-07-17 09:00:00'),
(853, 367, '20.00', '54.30', 0, '2017-07-17 10:00:00'),
(854, 367, '20.00', '56.10', 0, '2017-07-17 11:00:01'),
(855, 367, '19.90', '56.60', 0, '2017-07-17 12:00:00'),
(856, 367, '21.00', '81.10', 0, '2017-07-17 12:33:38'),
(857, 367, '20.00', '56.20', 0, '2017-07-17 13:00:01'),
(858, 367, '21.10', '64.70', 0, '2017-07-17 13:33:10'),
(859, 367, '20.00', '56.80', 0, '2017-07-17 14:00:00'),
(860, 367, '20.00', '56.30', 0, '2017-07-17 15:00:00'),
(861, 367, '20.10', '56.00', 0, '2017-07-17 16:00:00'),
(862, 367, '20.10', '55.80', 0, '2017-07-17 17:00:00'),
(863, 367, '20.00', '55.40', 0, '2017-07-17 18:00:00'),
(864, 367, '20.10', '55.50', 0, '2017-07-17 19:00:00'),
(865, 367, '20.30', '56.30', 0, '2017-07-17 20:00:00'),
(866, 367, '20.40', '57.00', 0, '2017-07-17 21:00:00'),
(867, 367, '20.50', '58.70', 0, '2017-07-17 22:00:00'),
(868, 367, '20.60', '58.60', 0, '2017-07-17 23:00:00'),
(869, 367, '21.00', '61.00', 0, '2017-07-18 00:00:00'),
(870, 367, '21.20', '63.40', 0, '2017-07-18 01:00:00'),
(871, 367, '20.90', '62.20', 0, '2017-07-18 02:00:00'),
(872, 367, '20.70', '61.50', 0, '2017-07-18 03:00:00'),
(873, 367, '20.60', '60.80', 0, '2017-07-18 04:00:00'),
(874, 367, '20.60', '60.80', 0, '2017-07-18 04:00:28'),
(875, 367, '20.60', '60.20', 0, '2017-07-18 05:00:00'),
(876, 367, '20.60', '59.60', 0, '2017-07-18 06:00:00'),
(877, 367, '20.60', '59.10', 0, '2017-07-18 07:00:00'),
(878, 367, '20.60', '58.80', 0, '2017-07-18 08:00:00'),
(879, 367, '20.60', '58.30', 0, '2017-07-18 09:00:00'),
(880, 367, '20.60', '58.00', 0, '2017-07-18 10:00:00'),
(881, 367, '20.80', '58.80', 0, '2017-07-18 11:00:00'),
(882, 367, '20.50', '57.70', 0, '2017-07-18 12:00:00'),
(883, 367, '20.90', '58.00', 0, '2017-07-18 13:00:00'),
(884, 367, '20.90', '58.00', 0, '2017-07-18 13:08:07'),
(885, 367, '20.90', '58.20', 0, '2017-07-18 14:00:00'),
(886, 367, '21.00', '58.30', 0, '2017-07-18 14:08:12'),
(887, 367, '21.10', '58.10', 0, '2017-07-18 15:00:00'),
(888, 367, '21.10', '57.90', 0, '2017-07-18 15:08:19'),
(889, 367, '21.10', '57.80', 0, '2017-07-18 15:10:42'),
(890, 367, '21.10', '57.80', 0, '2017-07-18 15:16:21'),
(891, 367, '21.10', '57.90', 0, '2017-07-18 15:17:23'),
(892, 367, '21.10', '57.70', 0, '2017-07-18 15:19:42'),
(893, 367, '21.20', '57.70', 0, '2017-07-18 16:00:00'),
(894, 367, '21.30', '57.90', 0, '2017-07-18 16:19:47'),
(895, 367, '21.30', '58.00', 0, '2017-07-18 17:00:00'),
(896, 367, '21.30', '57.90', 0, '2017-07-18 17:19:54'),
(897, 367, '21.40', '57.80', 0, '2017-07-18 18:00:00'),
(898, 367, '21.40', '57.50', 0, '2017-07-18 18:19:58'),
(899, 367, '21.60', '58.20', 0, '2017-07-18 19:00:00'),
(900, 367, '21.70', '60.80', 0, '2017-07-18 19:20:06'),
(901, 367, '21.80', '62.00', 0, '2017-07-18 20:00:00'),
(902, 367, '21.70', '61.00', 0, '2017-07-18 20:20:10'),
(903, 367, '21.80', '61.20', 0, '2017-07-18 21:00:00'),
(904, 367, '21.80', '61.20', 0, '2017-07-18 21:20:32'),
(905, 367, '21.70', '64.50', 0, '2017-07-18 22:00:00'),
(906, 367, '21.70', '63.70', 0, '2017-07-18 22:20:37'),
(907, 367, '21.70', '62.20', 0, '2017-07-18 23:00:00'),
(908, 367, '21.70', '61.10', 0, '2017-07-19 00:00:01'),
(909, 367, '21.70', '60.40', 0, '2017-07-19 01:00:00'),
(910, 367, '21.80', '60.20', 0, '2017-07-19 02:00:00'),
(911, 367, '21.70', '60.10', 0, '2017-07-19 03:00:00'),
(912, 367, '21.70', '59.40', 0, '2017-07-19 04:00:00'),
(913, 367, '21.80', '58.90', 0, '2017-07-19 05:00:00'),
(914, 367, '21.80', '58.50', 0, '2017-07-19 06:00:00'),
(915, 367, '21.80', '58.10', 0, '2017-07-19 07:00:00'),
(916, 367, '21.90', '58.00', 0, '2017-07-19 08:00:00'),
(917, 367, '21.70', '57.50', 0, '2017-07-19 09:00:00'),
(918, 367, '21.90', '58.40', 0, '2017-07-19 10:00:00'),
(919, 367, '22.20', '59.50', 0, '2017-07-19 11:00:00'),
(920, 367, '21.80', '58.30', 0, '2017-07-19 12:00:00'),
(921, 367, '21.90', '58.60', 0, '2017-07-19 12:25:56'),
(922, 367, '21.90', '58.30', 0, '2017-07-19 13:00:00'),
(923, 367, '21.20', '55.80', 0, '2017-07-19 13:26:01'),
(924, 367, '21.30', '51.20', 0, '2017-07-19 14:00:00'),
(925, 367, '21.30', '51.50', 0, '2017-07-19 14:26:11'),
(926, 367, '21.40', '52.00', 0, '2017-07-19 15:00:00');
INSERT INTO `datos` (`id`, `id_sensor`, `temperatura`, `humedad`, `ocultar`, `cuando`) VALUES
(927, 367, '21.40', '52.70', 0, '2017-07-19 15:26:15'),
(928, 367, '21.70', '53.40', 0, '2017-07-19 16:00:00'),
(929, 367, '21.80', '54.00', 0, '2017-07-19 16:26:25'),
(930, 367, '21.90', '54.40', 0, '2017-07-19 17:00:00'),
(931, 367, '21.90', '54.30', 0, '2017-07-19 17:26:32'),
(932, 367, '21.90', '54.10', 0, '2017-07-19 18:00:00'),
(933, 367, '22.00', '54.50', 0, '2017-07-19 18:26:45'),
(934, 367, '22.00', '54.50', 0, '2017-07-19 18:35:50'),
(935, 367, '22.00', '54.50', 0, '2017-07-19 18:36:30'),
(936, 367, '22.10', '55.90', 0, '2017-07-19 19:00:00'),
(937, 367, '22.20', '58.10', 0, '2017-07-19 19:36:40'),
(938, 367, '22.20', '59.40', 0, '2017-07-19 20:00:00'),
(939, 367, '22.30', '59.20', 0, '2017-07-19 20:36:47'),
(940, 367, '22.30', '59.00', 0, '2017-07-19 21:00:00'),
(941, 367, '22.30', '58.70', 0, '2017-07-19 21:37:06'),
(942, 367, '22.40', '59.00', 0, '2017-07-19 22:00:00'),
(943, 367, '22.40', '58.60', 0, '2017-07-19 22:37:09'),
(944, 367, '22.40', '58.70', 0, '2017-07-19 23:00:00'),
(945, 367, '22.50', '59.70', 0, '2017-07-20 00:00:00'),
(946, 367, '22.60', '60.50', 0, '2017-07-20 01:00:00'),
(947, 367, '22.60', '60.00', 0, '2017-07-20 02:00:00'),
(948, 367, '22.60', '58.70', 0, '2017-07-20 03:00:00'),
(949, 367, '22.70', '57.90', 0, '2017-07-20 04:00:00'),
(950, 367, '22.60', '58.10', 0, '2017-07-20 05:00:00'),
(951, 367, '22.70', '57.20', 0, '2017-07-20 06:00:00'),
(952, 367, '22.70', '57.60', 0, '2017-07-20 07:00:00'),
(953, 367, '22.70', '56.20', 0, '2017-07-20 08:00:00'),
(954, 367, '22.70', '56.70', 0, '2017-07-20 09:00:00'),
(955, 367, '22.70', '56.40', 0, '2017-07-20 10:00:00'),
(956, 367, '22.70', '58.40', 0, '2017-07-20 11:00:00'),
(957, 367, '22.80', '58.20', 0, '2017-07-20 12:00:00'),
(958, 367, '22.90', '58.80', 0, '2017-07-20 12:03:25'),
(959, 367, '22.80', '58.60', 0, '2017-07-20 12:04:29'),
(960, 367, '22.80', '58.90', 0, '2017-07-20 12:05:43'),
(961, 367, '22.80', '59.00', 0, '2017-07-20 12:06:47'),
(962, 367, '22.90', '58.90', 0, '2017-07-20 12:07:51'),
(963, 367, '22.90', '58.90', 0, '2017-07-20 12:09:02'),
(964, 367, '22.90', '59.10', 0, '2017-07-20 12:10:08'),
(965, 367, '22.80', '59.70', 0, '2017-07-20 13:00:00'),
(966, 367, '22.80', '59.40', 0, '2017-07-20 13:10:14'),
(967, 367, '22.90', '59.20', 0, '2017-07-20 14:00:00'),
(968, 367, '22.90', '59.50', 0, '2017-07-20 14:10:32'),
(969, 367, '23.00', '58.90', 0, '2017-07-20 15:00:01'),
(970, 367, '23.00', '59.00', 0, '2017-07-20 15:10:42'),
(971, 367, '23.00', '58.80', 0, '2017-07-20 15:30:48'),
(972, 367, '23.00', '59.80', 0, '2017-07-20 16:00:00'),
(973, 367, '23.10', '60.40', 0, '2017-07-20 16:30:53'),
(974, 367, '23.10', '60.70', 0, '2017-07-20 16:41:05'),
(975, 367, '23.10', '60.50', 0, '2017-07-20 16:51:18'),
(976, 367, '23.00', '60.50', 0, '2017-07-20 17:00:00'),
(977, 367, '23.10', '60.10', 0, '2017-07-20 17:11:38'),
(978, 367, '23.10', '60.20', 0, '2017-07-20 17:31:42'),
(979, 367, '23.10', '60.50', 0, '2017-07-20 17:51:46'),
(980, 367, '23.10', '60.70', 0, '2017-07-20 18:00:00'),
(981, 367, '23.10', '60.30', 0, '2017-07-20 18:11:50'),
(982, 367, '23.20', '60.50', 0, '2017-07-20 18:31:55'),
(983, 367, '23.20', '60.30', 0, '2017-07-20 18:34:08'),
(984, 367, '23.10', '59.70', 0, '2017-07-20 18:54:12'),
(985, 367, '23.00', '59.40', 0, '2017-07-20 19:00:00'),
(986, 367, '23.20', '60.30', 0, '2017-07-20 19:14:19'),
(987, 367, '23.30', '60.40', 0, '2017-07-20 19:34:22'),
(988, 367, '23.30', '60.70', 0, '2017-07-20 19:54:26'),
(989, 367, '23.20', '60.80', 0, '2017-07-20 20:00:00'),
(990, 367, '23.20', '60.90', 0, '2017-07-20 20:14:46'),
(991, 367, '23.30', '61.10', 0, '2017-07-20 20:34:54'),
(992, 367, '23.20', '61.30', 0, '2017-07-20 20:55:06'),
(993, 367, '23.30', '61.40', 0, '2017-07-20 21:00:00'),
(994, 367, '23.40', '61.70', 0, '2017-07-20 21:56:47'),
(995, 367, '23.40', '61.70', 0, '2017-07-20 22:00:00'),
(996, 367, '23.40', '62.00', 0, '2017-07-20 22:16:56'),
(997, 367, '23.40', '62.10', 0, '2017-07-20 22:37:00'),
(998, 367, '23.40', '62.30', 0, '2017-07-20 22:57:15'),
(999, 367, '23.50', '62.40', 0, '2017-07-20 23:00:00'),
(1000, 367, '23.50', '62.30', 0, '2017-07-20 23:17:18'),
(1001, 367, '23.80', '63.30', 0, '2017-07-20 23:37:30'),
(1002, 367, '23.50', '63.20', 0, '2017-07-20 23:57:35'),
(1003, 367, '23.60', '63.30', 0, '2017-07-21 00:00:00'),
(1004, 367, '23.50', '64.30', 0, '2017-07-21 00:05:00'),
(1005, 367, '23.60', '65.00', 0, '2017-07-21 01:00:00'),
(1006, 367, '23.60', '64.90', 0, '2017-07-21 01:05:06'),
(1007, 367, '23.60', '64.60', 0, '2017-07-21 02:00:00'),
(1008, 367, '23.50', '64.50', 0, '2017-07-21 02:05:09'),
(1009, 367, '23.50', '63.20', 0, '2017-07-21 03:00:00'),
(1010, 367, '23.60', '63.30', 0, '2017-07-21 03:05:12'),
(1011, 367, '23.50', '62.30', 0, '2017-07-21 04:00:00'),
(1012, 367, '23.60', '61.70', 0, '2017-07-21 05:00:00'),
(1013, 367, '23.50', '61.10', 0, '2017-07-21 06:00:00'),
(1014, 367, '23.50', '60.80', 0, '2017-07-21 07:00:00'),
(1015, 367, '23.50', '60.80', 0, '2017-07-21 08:00:00'),
(1016, 367, '23.50', '60.70', 0, '2017-07-21 09:00:00'),
(1017, 367, '23.50', '60.60', 0, '2017-07-21 10:00:00'),
(1018, 367, '23.60', '60.90', 0, '2017-07-21 11:00:00'),
(1019, 367, '23.20', '58.20', 0, '2017-07-21 12:00:00'),
(1020, 367, '23.40', '59.40', 0, '2017-07-21 13:00:00'),
(1021, 367, '23.50', '59.10', 0, '2017-07-21 14:00:00'),
(1022, 367, '23.40', '59.70', 0, '2017-07-21 15:00:00'),
(1023, 367, '23.50', '60.80', 0, '2017-07-21 16:00:00'),
(1024, 367, '23.50', '60.80', 0, '2017-07-21 17:00:00'),
(1025, 367, '23.50', '59.90', 0, '2017-07-21 18:00:00'),
(1026, 367, '23.60', '59.60', 0, '2017-07-21 19:00:00'),
(1027, 367, '23.50', '58.10', 0, '2017-07-21 20:00:00'),
(1028, 367, '23.50', '58.60', 0, '2017-07-21 21:00:00'),
(1029, 367, '23.40', '59.00', 0, '2017-07-21 22:00:00'),
(1030, 367, '23.60', '61.10', 0, '2017-07-21 23:00:00'),
(1031, 367, '23.80', '63.30', 0, '2017-07-22 00:00:00'),
(1032, 367, '24.30', '65.50', 0, '2017-07-22 01:00:00'),
(1033, 367, '24.30', '63.60', 0, '2017-07-22 02:00:00'),
(1034, 367, '24.00', '61.90', 0, '2017-07-22 03:00:00'),
(1035, 367, '23.90', '61.30', 0, '2017-07-22 04:00:00'),
(1036, 367, '23.90', '61.10', 0, '2017-07-22 05:00:00'),
(1037, 367, '23.80', '61.10', 0, '2017-07-22 06:00:00'),
(1038, 367, '23.70', '60.80', 0, '2017-07-22 07:00:00'),
(1039, 367, '23.70', '60.40', 0, '2017-07-22 08:00:00'),
(1040, 367, '23.50', '60.60', 0, '2017-07-22 09:00:00'),
(1041, 367, '23.40', '60.40', 0, '2017-07-22 10:00:00'),
(1042, 367, '23.50', '59.70', 0, '2017-07-22 11:00:00'),
(1043, 367, '23.40', '59.10', 0, '2017-07-22 12:00:00'),
(1044, 367, '23.10', '60.70', 0, '2017-07-22 13:00:00'),
(1045, 367, '23.00', '59.30', 0, '2017-07-22 14:00:00'),
(1046, 367, '22.90', '58.00', 0, '2017-07-22 15:00:00'),
(1047, 367, '23.10', '58.10', 0, '2017-07-22 16:00:00'),
(1048, 367, '23.20', '58.50', 0, '2017-07-22 17:00:00'),
(1049, 367, '23.10', '57.80', 0, '2017-07-22 18:00:00'),
(1050, 367, '23.10', '58.60', 0, '2017-07-22 19:00:00'),
(1051, 367, '23.00', '61.50', 0, '2017-07-22 20:00:00'),
(1052, 367, '23.20', '61.50', 0, '2017-07-22 21:00:00'),
(1053, 367, '23.30', '61.40', 0, '2017-07-22 22:00:00'),
(1054, 367, '23.50', '63.80', 0, '2017-07-22 23:00:00'),
(1055, 367, '23.50', '64.90', 0, '2017-07-23 00:00:00'),
(1056, 367, '24.40', '69.60', 0, '2017-07-23 01:00:00'),
(1057, 367, '24.70', '60.20', 0, '2017-07-23 02:00:00'),
(1058, 367, '24.90', '62.10', 0, '2017-07-23 03:00:00'),
(1059, 367, '24.60', '62.70', 0, '2017-07-23 04:00:00'),
(1060, 367, '23.60', '61.50', 0, '2017-07-23 05:00:00'),
(1061, 367, '23.50', '60.40', 0, '2017-07-23 06:00:00'),
(1062, 367, '23.20', '59.80', 0, '2017-07-23 07:00:00'),
(1063, 367, '23.10', '59.00', 0, '2017-07-23 08:00:00'),
(1064, 367, '22.90', '58.70', 0, '2017-07-23 09:00:00'),
(1065, 367, '22.90', '58.90', 0, '2017-07-23 10:00:00'),
(1066, 367, '22.70', '58.90', 0, '2017-07-23 11:00:00'),
(1067, 367, '22.70', '58.50', 0, '2017-07-23 12:00:00'),
(1068, 367, '22.70', '60.40', 0, '2017-07-23 13:00:00'),
(1069, 367, '22.50', '59.30', 0, '2017-07-23 14:00:00'),
(1070, 367, '22.70', '64.90', 0, '2017-07-23 15:00:00'),
(1071, 367, '22.60', '62.50', 0, '2017-07-23 16:00:00'),
(1072, 367, '22.70', '60.20', 0, '2017-07-23 17:00:00'),
(1073, 367, '22.60', '59.10', 0, '2017-07-23 18:00:00'),
(1074, 367, '22.70', '58.70', 0, '2017-07-23 19:00:00'),
(1075, 367, '22.70', '59.10', 0, '2017-07-23 20:00:00'),
(1076, 367, '22.60', '60.00', 0, '2017-07-23 21:00:00'),
(1077, 367, '22.70', '60.20', 0, '2017-07-23 22:00:00'),
(1078, 367, '22.70', '60.50', 0, '2017-07-23 23:00:00'),
(1079, 367, '22.90', '62.70', 0, '2017-07-24 00:00:00'),
(1080, 367, '22.90', '61.60', 0, '2017-07-24 01:00:00'),
(1081, 367, '22.80', '61.10', 0, '2017-07-24 02:00:00'),
(1082, 367, '22.80', '60.90', 0, '2017-07-24 03:00:00'),
(1083, 367, '22.70', '60.40', 0, '2017-07-24 04:00:00'),
(1084, 367, '22.60', '60.40', 0, '2017-07-24 05:00:00'),
(1085, 367, '22.60', '61.10', 0, '2017-07-24 06:00:00'),
(1086, 367, '22.50', '60.50', 0, '2017-07-24 07:00:00'),
(1087, 367, '22.60', '60.50', 0, '2017-07-24 08:00:00'),
(1088, 367, '22.60', '60.70', 0, '2017-07-24 09:00:00'),
(1089, 367, '22.50', '60.30', 0, '2017-07-24 10:00:00'),
(1090, 367, '22.70', '63.00', 0, '2017-07-24 11:00:00'),
(1091, 367, '22.70', '62.30', 0, '2017-07-24 12:00:00'),
(1092, 367, '22.80', '60.60', 0, '2017-07-24 13:00:00'),
(1093, 367, '22.80', '61.50', 0, '2017-07-24 14:00:00'),
(1094, 367, '22.40', '57.70', 0, '2017-07-24 15:00:00'),
(1095, 368, '20.50', '61.30', 0, '2017-07-24 15:00:00'),
(1096, 367, '22.80', '59.20', 0, '2017-07-24 16:00:00'),
(1097, 368, '20.50', '61.30', 0, '2017-07-24 16:00:00'),
(1098, 367, '22.80', '56.90', 0, '2017-07-24 17:00:00'),
(1099, 368, '20.50', '61.30', 0, '2017-07-24 17:00:00'),
(1100, 367, '22.70', '57.10', 0, '2017-07-24 18:00:00'),
(1101, 368, '20.50', '61.30', 0, '2017-07-24 18:00:00'),
(1102, 367, '22.90', '56.70', 0, '2017-07-24 19:00:00'),
(1103, 368, '20.50', '61.30', 0, '2017-07-24 19:00:00'),
(1104, 367, '22.90', '59.10', 0, '2017-07-24 20:00:00'),
(1105, 368, '20.50', '61.30', 0, '2017-07-24 20:00:00'),
(1106, 367, '22.90', '59.60', 0, '2017-07-24 21:00:00'),
(1107, 368, '20.50', '61.30', 0, '2017-07-24 21:00:00'),
(1108, 367, '22.90', '61.70', 0, '2017-07-24 22:00:00'),
(1109, 368, '20.50', '61.30', 0, '2017-07-24 22:00:00'),
(1110, 367, '22.90', '60.60', 0, '2017-07-24 23:00:00'),
(1111, 368, '20.50', '61.30', 0, '2017-07-24 23:00:00'),
(1112, 367, '22.90', '60.10', 0, '2017-07-25 00:00:00'),
(1113, 368, '20.50', '61.30', 0, '2017-07-25 00:00:00'),
(1114, 367, '22.90', '59.50', 0, '2017-07-25 01:00:00'),
(1115, 368, '20.50', '61.30', 0, '2017-07-25 01:00:00'),
(1116, 367, '22.90', '62.80', 0, '2017-07-25 02:00:00'),
(1117, 368, '20.50', '61.30', 0, '2017-07-25 02:00:00'),
(1118, 367, '22.80', '63.10', 0, '2017-07-25 03:00:00'),
(1119, 368, '20.50', '61.30', 0, '2017-07-25 03:00:00'),
(1120, 367, '22.80', '63.00', 0, '2017-07-25 04:00:00'),
(1121, 368, '20.50', '61.30', 0, '2017-07-25 04:00:00'),
(1122, 367, '22.80', '62.50', 0, '2017-07-25 05:00:00'),
(1123, 368, '20.50', '61.30', 0, '2017-07-25 05:00:00'),
(1124, 367, '22.70', '62.10', 0, '2017-07-25 06:00:00'),
(1125, 368, '20.50', '61.30', 0, '2017-07-25 06:00:00'),
(1126, 367, '22.70', '61.60', 0, '2017-07-25 07:00:00'),
(1127, 368, '20.50', '61.30', 0, '2017-07-25 07:00:00'),
(1128, 367, '22.70', '60.50', 0, '2017-07-25 08:00:00'),
(1129, 368, '20.50', '61.30', 0, '2017-07-25 08:00:00'),
(1130, 367, '22.60', '59.90', 0, '2017-07-25 09:00:00'),
(1131, 368, '20.50', '61.30', 0, '2017-07-25 09:00:00'),
(1132, 367, '22.50', '59.90', 0, '2017-07-25 10:00:00'),
(1133, 368, '20.50', '61.30', 0, '2017-07-25 10:00:00'),
(1134, 367, '22.60', '59.80', 0, '2017-07-25 11:00:00'),
(1135, 368, '20.50', '61.30', 0, '2017-07-25 11:00:00'),
(1136, 367, '22.40', '56.60', 0, '2017-07-25 12:00:00'),
(1137, 368, '20.50', '61.30', 0, '2017-07-25 12:00:00'),
(1138, 367, '22.50', '57.20', 0, '2017-07-25 13:00:00'),
(1139, 368, '20.50', '61.30', 0, '2017-07-25 13:00:00'),
(1140, 367, '22.60', '56.40', 0, '2017-07-25 14:00:00'),
(1141, 368, '20.50', '61.30', 0, '2017-07-25 14:00:01'),
(1142, 367, '22.30', '47.00', 0, '2017-07-25 15:00:00'),
(1143, 368, '20.50', '61.30', 0, '2017-07-25 15:00:00'),
(1144, 367, '22.30', '48.40', 0, '2017-07-25 16:00:00'),
(1145, 368, '20.50', '61.30', 0, '2017-07-25 16:00:00'),
(1146, 367, '22.40', '49.10', 0, '2017-07-25 17:00:00'),
(1147, 368, '20.50', '61.30', 0, '2017-07-25 17:00:00'),
(1148, 367, '22.40', '49.00', 0, '2017-07-25 17:03:35'),
(1149, 368, '20.50', '61.30', 0, '2017-07-25 17:03:35'),
(1150, 367, '22.40', '49.00', 0, '2017-07-25 18:00:00'),
(1151, 368, '20.50', '61.30', 0, '2017-07-25 18:00:00'),
(1152, 367, '22.40', '49.00', 0, '2017-07-25 19:00:00'),
(1153, 368, '20.50', '61.30', 0, '2017-07-25 19:00:00'),
(1154, 367, '22.40', '49.00', 0, '2017-07-25 20:00:00'),
(1155, 368, '20.50', '61.30', 0, '2017-07-25 20:00:00'),
(1156, 367, '22.40', '49.00', 0, '2017-07-25 21:00:00'),
(1157, 368, '20.50', '61.30', 0, '2017-07-25 21:00:00'),
(1158, 367, '22.40', '49.00', 0, '2017-07-25 22:00:00'),
(1159, 368, '20.50', '61.30', 0, '2017-07-25 22:00:00'),
(1160, 367, '22.40', '49.00', 0, '2017-07-25 23:00:00'),
(1161, 368, '20.50', '61.30', 0, '2017-07-25 23:00:00'),
(1162, 367, '22.40', '49.00', 0, '2017-07-26 00:00:00'),
(1163, 368, '20.50', '61.30', 0, '2017-07-26 00:00:00'),
(1164, 367, '22.40', '49.00', 0, '2017-07-26 01:00:00'),
(1165, 368, '20.50', '61.30', 0, '2017-07-26 01:00:00'),
(1166, 367, '22.40', '49.00', 0, '2017-07-26 02:00:00'),
(1167, 368, '20.50', '61.30', 0, '2017-07-26 02:00:00'),
(1168, 367, '22.40', '49.00', 0, '2017-07-26 03:00:00'),
(1169, 368, '20.50', '61.30', 0, '2017-07-26 03:00:00'),
(1170, 367, '22.40', '49.00', 0, '2017-07-26 04:00:00'),
(1171, 368, '20.50', '61.30', 0, '2017-07-26 04:00:00'),
(1172, 367, '22.40', '49.00', 0, '2017-07-26 05:00:00'),
(1173, 368, '20.50', '61.30', 0, '2017-07-26 05:00:00'),
(1174, 367, '22.40', '49.00', 0, '2017-07-26 06:00:00'),
(1175, 368, '20.50', '61.30', 0, '2017-07-26 06:00:00'),
(1176, 367, '22.40', '49.00', 0, '2017-07-26 07:00:00'),
(1177, 368, '20.50', '61.30', 0, '2017-07-26 07:00:00'),
(1178, 367, '22.40', '49.00', 0, '2017-07-26 08:00:00'),
(1179, 368, '20.50', '61.30', 0, '2017-07-26 08:00:00'),
(1180, 367, '22.40', '49.00', 0, '2017-07-26 09:00:00'),
(1181, 368, '20.50', '61.30', 0, '2017-07-26 09:00:00'),
(1182, 367, '22.40', '49.00', 0, '2017-07-26 10:00:00'),
(1183, 368, '20.50', '61.30', 0, '2017-07-26 10:00:00'),
(1184, 367, '22.40', '49.00', 0, '2017-07-26 11:00:00'),
(1185, 368, '20.50', '61.30', 0, '2017-07-26 11:00:00'),
(1186, 367, '22.40', '49.00', 0, '2017-07-26 12:00:00'),
(1187, 368, '20.50', '61.30', 0, '2017-07-26 12:00:00'),
(1188, 367, '22.40', '49.00', 0, '2017-07-26 13:00:00'),
(1189, 368, '20.50', '61.30', 0, '2017-07-26 13:00:00'),
(1190, 367, '22.40', '49.00', 0, '2017-07-26 14:00:00'),
(1191, 368, '20.50', '61.30', 0, '2017-07-26 14:00:00'),
(1192, 367, '22.40', '49.00', 0, '2017-07-26 15:00:00'),
(1193, 368, '20.50', '61.30', 0, '2017-07-26 15:00:00'),
(1194, 367, '22.40', '49.00', 0, '2017-07-26 16:00:00'),
(1195, 368, '20.50', '61.30', 0, '2017-07-26 16:00:00'),
(1196, 367, '22.40', '49.00', 0, '2017-07-26 17:00:00'),
(1197, 368, '20.50', '61.30', 0, '2017-07-26 17:00:00'),
(1198, 367, '22.40', '49.00', 0, '2017-07-26 18:00:00'),
(1199, 368, '20.50', '61.30', 0, '2017-07-26 18:00:00'),
(1200, 367, '22.40', '49.00', 0, '2017-07-26 19:00:00'),
(1201, 368, '20.50', '61.30', 0, '2017-07-26 19:00:00'),
(1202, 367, '22.40', '49.00', 0, '2017-07-26 20:00:00'),
(1203, 368, '20.50', '61.30', 0, '2017-07-26 20:00:00'),
(1204, 367, '22.40', '49.00', 0, '2017-07-26 21:00:00'),
(1205, 368, '20.50', '61.30', 0, '2017-07-26 21:00:00'),
(1206, 367, '22.40', '49.00', 0, '2017-07-26 22:00:00'),
(1207, 368, '20.50', '61.30', 0, '2017-07-26 22:00:00'),
(1208, 367, '22.40', '49.00', 0, '2017-07-26 23:00:00'),
(1209, 368, '20.50', '61.30', 0, '2017-07-26 23:00:00'),
(1210, 367, '22.40', '49.00', 0, '2017-07-27 00:00:00'),
(1211, 368, '20.50', '61.30', 0, '2017-07-27 00:00:00'),
(1212, 367, '22.40', '49.00', 0, '2017-07-27 01:00:00'),
(1213, 368, '20.50', '61.30', 0, '2017-07-27 01:00:00'),
(1214, 367, '22.40', '49.00', 0, '2017-07-27 02:00:00'),
(1215, 368, '20.50', '61.30', 0, '2017-07-27 02:00:00'),
(1216, 367, '22.40', '49.00', 0, '2017-07-27 03:00:00'),
(1217, 368, '20.50', '61.30', 0, '2017-07-27 03:00:00'),
(1218, 367, '22.40', '49.00', 0, '2017-07-27 04:00:00'),
(1219, 368, '20.50', '61.30', 0, '2017-07-27 04:00:00'),
(1220, 367, '22.40', '49.00', 0, '2017-07-27 05:00:00'),
(1221, 368, '20.50', '61.30', 0, '2017-07-27 05:00:00'),
(1222, 367, '22.40', '49.00', 0, '2017-07-27 06:00:00'),
(1223, 368, '20.50', '61.30', 0, '2017-07-27 06:00:00'),
(1224, 367, '22.40', '49.00', 0, '2017-07-27 07:00:00'),
(1225, 368, '20.50', '61.30', 0, '2017-07-27 07:00:00'),
(1226, 367, '22.40', '49.00', 0, '2017-07-27 08:00:00'),
(1227, 368, '20.50', '61.30', 0, '2017-07-27 08:00:00'),
(1228, 367, '22.40', '49.00', 0, '2017-07-27 09:00:00'),
(1229, 368, '20.50', '61.30', 0, '2017-07-27 09:00:00'),
(1230, 367, '22.40', '49.00', 0, '2017-07-27 10:00:00'),
(1231, 368, '20.50', '61.30', 0, '2017-07-27 10:00:00'),
(1232, 367, '22.40', '49.00', 0, '2017-07-27 11:00:00'),
(1233, 368, '20.50', '61.30', 0, '2017-07-27 11:00:00'),
(1234, 367, '24.30', '67.50', 0, '2017-07-27 12:00:00'),
(1235, 368, '20.50', '61.30', 0, '2017-07-27 12:00:00'),
(1236, 367, '24.00', '66.70', 0, '2017-07-27 13:00:00'),
(1237, 368, '20.50', '61.30', 0, '2017-07-27 13:00:00'),
(1238, 367, '24.20', '67.10', 0, '2017-07-27 14:00:00'),
(1239, 368, '20.50', '61.30', 0, '2017-07-27 14:00:00'),
(1240, 367, '24.30', '67.20', 0, '2017-07-27 15:00:00'),
(1241, 368, '20.50', '61.30', 0, '2017-07-27 15:00:01'),
(1242, 367, '24.50', '67.20', 0, '2017-07-27 16:00:00'),
(1243, 368, '20.50', '61.30', 0, '2017-07-27 16:00:00'),
(1244, 367, '24.60', '67.40', 0, '2017-07-27 17:00:00'),
(1245, 368, '20.50', '61.30', 0, '2017-07-27 17:00:00'),
(1246, 367, '24.70', '67.90', 0, '2017-07-27 18:00:00'),
(1247, 368, '20.50', '61.30', 0, '2017-07-27 18:00:00'),
(1248, 367, '24.40', '69.30', 0, '2017-07-27 19:00:00'),
(1249, 368, '20.50', '61.30', 0, '2017-07-27 19:00:00'),
(1250, 367, '24.50', '69.50', 0, '2017-07-27 20:00:00'),
(1251, 368, '20.50', '61.30', 0, '2017-07-27 20:00:00'),
(1252, 367, '24.40', '69.50', 0, '2017-07-27 21:00:00'),
(1253, 368, '20.50', '61.30', 0, '2017-07-27 21:00:00'),
(1254, 367, '24.50', '70.00', 0, '2017-07-27 22:00:00'),
(1255, 368, '20.50', '61.30', 0, '2017-07-27 22:00:00'),
(1256, 367, '24.10', '72.10', 0, '2017-07-27 23:00:00'),
(1257, 368, '20.50', '61.30', 0, '2017-07-27 23:00:00'),
(1258, 367, '24.40', '73.20', 0, '2017-07-28 00:00:00'),
(1259, 368, '20.50', '61.30', 0, '2017-07-28 00:00:00'),
(1260, 367, '24.50', '73.40', 0, '2017-07-28 01:00:00'),
(1261, 368, '20.50', '61.30', 0, '2017-07-28 01:00:00'),
(1262, 367, '24.50', '72.90', 0, '2017-07-28 02:00:00'),
(1263, 368, '20.50', '61.30', 0, '2017-07-28 02:00:00'),
(1264, 367, '24.50', '72.70', 0, '2017-07-28 03:00:00'),
(1265, 368, '20.50', '61.30', 0, '2017-07-28 03:00:00'),
(1266, 367, '24.40', '72.30', 0, '2017-07-28 04:00:00'),
(1267, 368, '20.50', '61.30', 0, '2017-07-28 04:00:00'),
(1268, 367, '24.40', '71.90', 0, '2017-07-28 05:00:00'),
(1269, 368, '20.50', '61.30', 0, '2017-07-28 05:00:00'),
(1270, 367, '24.40', '71.40', 0, '2017-07-28 06:00:00'),
(1271, 368, '20.50', '61.30', 0, '2017-07-28 06:00:00'),
(1272, 367, '24.30', '71.10', 0, '2017-07-28 07:00:00'),
(1273, 368, '20.50', '61.30', 0, '2017-07-28 07:00:00'),
(1274, 367, '24.30', '70.80', 0, '2017-07-28 08:00:00'),
(1275, 368, '20.50', '61.30', 0, '2017-07-28 08:00:00'),
(1276, 367, '24.20', '70.40', 0, '2017-07-28 09:00:00'),
(1277, 368, '20.50', '61.30', 0, '2017-07-28 09:00:00'),
(1278, 367, '24.20', '70.50', 0, '2017-07-28 10:00:00'),
(1279, 368, '20.50', '61.30', 0, '2017-07-28 10:00:00'),
(1280, 367, '24.40', '70.90', 0, '2017-07-28 11:00:00'),
(1281, 368, '20.50', '61.30', 0, '2017-07-28 11:00:00'),
(1282, 367, '24.20', '69.60', 0, '2017-07-28 12:00:00'),
(1283, 368, '20.50', '61.30', 0, '2017-07-28 12:00:00'),
(1284, 367, '24.30', '71.10', 0, '2017-07-28 13:00:00'),
(1285, 368, '20.50', '61.30', 0, '2017-07-28 13:00:00'),
(1286, 367, '24.10', '69.30', 0, '2017-07-28 14:00:00'),
(1287, 368, '20.50', '61.30', 0, '2017-07-28 14:00:00'),
(1288, 367, '24.00', '70.00', 0, '2017-07-28 15:00:00'),
(1289, 368, '20.50', '61.30', 0, '2017-07-28 15:00:00'),
(1290, 367, '24.20', '69.80', 0, '2017-07-28 16:00:00'),
(1291, 368, '20.50', '61.30', 0, '2017-07-28 16:00:00'),
(1292, 367, '24.30', '69.90', 0, '2017-07-28 17:00:00'),
(1293, 368, '20.50', '61.30', 0, '2017-07-28 17:00:00'),
(1294, 367, '24.30', '69.90', 0, '2017-07-28 18:00:00'),
(1295, 368, '20.50', '61.30', 0, '2017-07-28 18:00:00'),
(1296, 367, '24.30', '71.80', 0, '2017-07-28 19:00:00'),
(1297, 368, '20.50', '61.30', 0, '2017-07-28 19:00:00'),
(1298, 367, '24.30', '70.90', 0, '2017-07-28 20:00:00'),
(1299, 368, '20.50', '61.30', 0, '2017-07-28 20:00:00'),
(1300, 367, '24.40', '70.40', 0, '2017-07-28 21:00:00'),
(1301, 368, '20.50', '61.30', 0, '2017-07-28 21:00:00'),
(1302, 367, '24.40', '70.90', 0, '2017-07-28 22:00:00'),
(1303, 368, '20.50', '61.30', 0, '2017-07-28 22:00:00'),
(1304, 367, '24.40', '70.70', 0, '2017-07-28 23:00:00'),
(1305, 368, '20.50', '61.30', 0, '2017-07-28 23:00:00'),
(1306, 367, '24.40', '70.70', 0, '2017-07-29 00:00:00'),
(1307, 368, '20.50', '61.30', 0, '2017-07-29 00:00:00'),
(1308, 367, '24.40', '70.20', 0, '2017-07-29 01:00:00'),
(1309, 368, '20.50', '61.30', 0, '2017-07-29 01:00:00'),
(1310, 367, '24.40', '70.10', 0, '2017-07-29 02:00:00'),
(1311, 368, '20.50', '61.30', 0, '2017-07-29 02:00:00'),
(1312, 367, '24.40', '71.10', 0, '2017-07-29 03:00:00'),
(1313, 368, '20.50', '61.30', 0, '2017-07-29 03:00:00'),
(1314, 367, '24.40', '70.60', 0, '2017-07-29 04:00:00'),
(1315, 368, '20.50', '61.30', 0, '2017-07-29 04:00:00'),
(1316, 367, '24.40', '69.80', 0, '2017-07-29 05:00:00'),
(1317, 368, '20.50', '61.30', 0, '2017-07-29 05:00:00'),
(1318, 367, '24.40', '67.90', 0, '2017-07-29 06:00:00'),
(1319, 368, '20.50', '61.30', 0, '2017-07-29 06:00:00'),
(1320, 367, '24.20', '65.90', 0, '2017-07-29 07:00:00'),
(1321, 368, '20.50', '61.30', 0, '2017-07-29 07:00:00'),
(1322, 367, '24.00', '63.30', 0, '2017-07-29 08:00:00'),
(1323, 368, '20.50', '61.30', 0, '2017-07-29 08:00:00'),
(1324, 367, '23.90', '62.60', 0, '2017-07-29 09:00:00'),
(1325, 368, '20.50', '61.30', 0, '2017-07-29 09:00:00'),
(1326, 367, '23.80', '62.70', 0, '2017-07-29 10:00:00'),
(1327, 368, '20.50', '61.30', 0, '2017-07-29 10:00:00'),
(1328, 367, '23.60', '61.00', 0, '2017-07-29 11:00:00'),
(1329, 368, '20.50', '61.30', 0, '2017-07-29 11:00:00'),
(1330, 367, '23.50', '60.80', 0, '2017-07-29 12:00:00'),
(1331, 368, '20.50', '61.30', 0, '2017-07-29 12:00:00'),
(1332, 367, '23.50', '60.60', 0, '2017-07-29 13:00:00'),
(1333, 368, '20.50', '61.30', 0, '2017-07-29 13:00:00'),
(1334, 367, '23.20', '61.00', 0, '2017-07-29 13:56:33'),
(1335, 367, '23.30', '61.00', 0, '2017-07-29 14:00:00'),
(1336, 368, '20.50', '61.30', 0, '2017-07-29 14:00:00'),
(1337, 367, '23.20', '59.80', 0, '2017-07-29 15:00:00'),
(1338, 368, '20.50', '61.30', 0, '2017-07-29 15:00:00'),
(1339, 367, '23.10', '57.70', 0, '2017-07-29 16:00:00'),
(1340, 368, '20.50', '61.30', 0, '2017-07-29 16:00:00'),
(1341, 367, '23.40', '60.60', 0, '2017-07-29 17:00:00'),
(1342, 368, '20.50', '61.30', 0, '2017-07-29 17:00:00'),
(1343, 367, '23.30', '59.70', 0, '2017-07-29 18:00:00'),
(1344, 368, '20.50', '61.30', 0, '2017-07-29 18:00:00'),
(1345, 367, '23.10', '59.00', 0, '2017-07-29 19:00:00'),
(1346, 368, '20.50', '61.30', 0, '2017-07-29 19:00:00'),
(1347, 367, '23.10', '60.10', 0, '2017-07-29 20:00:00'),
(1348, 368, '20.50', '61.30', 0, '2017-07-29 20:00:00'),
(1349, 367, '23.40', '62.10', 0, '2017-07-29 21:00:00'),
(1350, 368, '20.50', '61.30', 0, '2017-07-29 21:00:00'),
(1351, 367, '23.30', '59.60', 0, '2017-07-29 22:00:00'),
(1352, 368, '20.50', '61.30', 0, '2017-07-29 22:00:00'),
(1353, 367, '23.00', '58.60', 0, '2017-07-29 23:00:00'),
(1354, 368, '20.50', '61.30', 0, '2017-07-29 23:00:00'),
(1355, 367, '22.90', '57.40', 0, '2017-07-30 00:00:00'),
(1356, 368, '20.50', '61.30', 0, '2017-07-30 00:00:00'),
(1357, 367, '22.80', '57.90', 0, '2017-07-30 01:00:00'),
(1358, 368, '20.50', '61.30', 0, '2017-07-30 01:00:00'),
(1359, 367, '22.60', '57.70', 0, '2017-07-30 02:00:00'),
(1360, 368, '20.50', '61.30', 0, '2017-07-30 02:00:00'),
(1361, 367, '22.60', '57.90', 0, '2017-07-30 03:00:00'),
(1362, 368, '20.50', '61.30', 0, '2017-07-30 03:00:00'),
(1363, 367, '22.50', '57.50', 0, '2017-07-30 04:00:00'),
(1364, 368, '20.50', '61.30', 0, '2017-07-30 04:00:00'),
(1365, 367, '22.70', '57.20', 0, '2017-07-30 05:00:00'),
(1366, 368, '20.50', '61.30', 0, '2017-07-30 05:00:00'),
(1367, 367, '22.50', '56.80', 0, '2017-07-30 06:00:00'),
(1368, 368, '20.50', '61.30', 0, '2017-07-30 06:00:00'),
(1369, 367, '22.50', '56.60', 0, '2017-07-30 07:00:00'),
(1370, 368, '20.50', '61.30', 0, '2017-07-30 07:00:00'),
(1371, 367, '22.50', '56.40', 0, '2017-07-30 08:00:00'),
(1372, 368, '20.50', '61.30', 0, '2017-07-30 08:00:00'),
(1373, 367, '22.40', '55.70', 0, '2017-07-30 09:00:00'),
(1374, 368, '20.50', '61.30', 0, '2017-07-30 09:00:00'),
(1375, 367, '22.30', '57.20', 0, '2017-07-30 10:00:00'),
(1376, 368, '20.50', '61.30', 0, '2017-07-30 10:00:00'),
(1377, 367, '22.40', '59.30', 0, '2017-07-30 11:00:00'),
(1378, 368, '20.50', '61.30', 0, '2017-07-30 11:00:00'),
(1379, 367, '22.40', '60.40', 0, '2017-07-30 12:00:01'),
(1380, 368, '20.50', '61.30', 0, '2017-07-30 12:00:01'),
(1381, 367, '22.40', '60.50', 0, '2017-07-30 13:00:00'),
(1382, 368, '20.50', '61.30', 0, '2017-07-30 13:00:00'),
(1383, 367, '22.30', '59.40', 0, '2017-07-30 14:00:00'),
(1384, 368, '20.50', '61.30', 0, '2017-07-30 14:00:00'),
(1385, 367, '22.20', '59.00', 0, '2017-07-30 15:00:00'),
(1386, 368, '20.50', '61.30', 0, '2017-07-30 15:00:00'),
(1387, 367, '22.30', '60.90', 0, '2017-07-30 16:00:00'),
(1388, 368, '20.50', '61.30', 0, '2017-07-30 16:00:00'),
(1389, 367, '22.20', '60.80', 0, '2017-07-30 17:00:00'),
(1390, 368, '20.50', '61.30', 0, '2017-07-30 17:00:00'),
(1391, 367, '22.20', '60.00', 0, '2017-07-30 18:00:00'),
(1392, 368, '20.50', '61.30', 0, '2017-07-30 18:00:00'),
(1393, 367, '22.20', '59.40', 0, '2017-07-30 19:00:00'),
(1394, 368, '20.50', '61.30', 0, '2017-07-30 19:00:00'),
(1395, 367, '22.10', '59.10', 0, '2017-07-30 20:00:00'),
(1396, 368, '20.50', '61.30', 0, '2017-07-30 20:00:00'),
(1397, 367, '22.00', '58.60', 0, '2017-07-30 21:00:00'),
(1398, 368, '20.50', '61.30', 0, '2017-07-30 21:00:00'),
(1399, 367, '22.00', '58.50', 0, '2017-07-30 22:00:00'),
(1400, 368, '20.50', '61.30', 0, '2017-07-30 22:00:00'),
(1401, 367, '22.10', '58.10', 0, '2017-07-30 23:00:00'),
(1402, 368, '20.50', '61.30', 0, '2017-07-30 23:00:00'),
(1403, 367, '22.00', '57.30', 0, '2017-07-31 00:00:00'),
(1404, 368, '20.50', '61.30', 0, '2017-07-31 00:00:00'),
(1405, 367, '21.90', '57.80', 0, '2017-07-31 01:00:00'),
(1406, 368, '20.50', '61.30', 0, '2017-07-31 01:00:00'),
(1407, 367, '21.80', '56.90', 0, '2017-07-31 02:00:00'),
(1408, 368, '20.50', '61.30', 0, '2017-07-31 02:00:00'),
(1409, 367, '21.70', '56.40', 0, '2017-07-31 03:00:00'),
(1410, 368, '20.50', '61.30', 0, '2017-07-31 03:00:00'),
(1411, 367, '21.60', '56.20', 0, '2017-07-31 04:00:00'),
(1412, 368, '20.50', '61.30', 0, '2017-07-31 04:00:00'),
(1413, 367, '21.60', '56.00', 0, '2017-07-31 05:00:00'),
(1414, 368, '20.50', '61.30', 0, '2017-07-31 05:00:00'),
(1415, 367, '21.40', '55.20', 0, '2017-07-31 06:00:00'),
(1416, 368, '20.50', '61.30', 0, '2017-07-31 06:00:00'),
(1417, 367, '21.30', '54.90', 0, '2017-07-31 07:00:00'),
(1418, 368, '20.50', '61.30', 0, '2017-07-31 07:00:00'),
(1419, 367, '21.20', '54.60', 0, '2017-07-31 08:00:00'),
(1420, 368, '20.50', '61.30', 0, '2017-07-31 08:00:00'),
(1421, 367, '21.10', '54.50', 0, '2017-07-31 09:00:00'),
(1422, 368, '20.50', '61.30', 0, '2017-07-31 09:00:00'),
(1423, 367, '21.00', '55.00', 0, '2017-07-31 10:00:00'),
(1424, 368, '20.50', '61.30', 0, '2017-07-31 10:00:00'),
(1425, 367, '21.20', '56.80', 0, '2017-07-31 11:00:00'),
(1426, 368, '20.50', '61.30', 0, '2017-07-31 11:00:00'),
(1427, 367, '21.10', '55.50', 0, '2017-07-31 12:00:00'),
(1428, 368, '20.50', '61.30', 0, '2017-07-31 12:00:00'),
(1429, 367, '21.30', '57.40', 0, '2017-07-31 13:00:00'),
(1430, 368, '20.50', '61.30', 0, '2017-07-31 13:00:00'),
(1431, 367, '21.20', '58.70', 0, '2017-07-31 14:00:00'),
(1432, 368, '20.50', '61.30', 0, '2017-07-31 14:00:00'),
(1433, 367, '21.10', '58.90', 0, '2017-07-31 15:00:00'),
(1434, 368, '20.50', '61.30', 0, '2017-07-31 15:00:00'),
(1435, 367, '21.20', '60.00', 0, '2017-07-31 16:00:00'),
(1436, 368, '20.50', '61.30', 0, '2017-07-31 16:00:00'),
(1437, 367, '21.40', '60.60', 0, '2017-07-31 17:00:00'),
(1438, 368, '20.50', '61.30', 0, '2017-07-31 17:00:00'),
(1439, 367, '21.50', '60.80', 0, '2017-07-31 18:00:00'),
(1440, 368, '20.50', '61.30', 0, '2017-07-31 18:00:00'),
(1441, 367, '21.60', '60.90', 0, '2017-07-31 19:00:00'),
(1442, 368, '20.50', '61.30', 0, '2017-07-31 19:00:00'),
(1443, 367, '21.60', '61.20', 0, '2017-07-31 20:00:00'),
(1444, 368, '20.50', '61.30', 0, '2017-07-31 20:00:00'),
(1445, 367, '21.70', '61.50', 0, '2017-07-31 21:00:00'),
(1446, 368, '20.50', '61.30', 0, '2017-07-31 21:00:00'),
(1447, 367, '21.80', '61.70', 0, '2017-07-31 22:00:00'),
(1448, 368, '20.50', '61.30', 0, '2017-07-31 22:00:00'),
(1449, 367, '21.80', '61.80', 0, '2017-07-31 23:00:00'),
(1450, 368, '20.50', '61.30', 0, '2017-07-31 23:00:00'),
(1451, 367, '22.00', '62.10', 0, '2017-08-01 00:00:00'),
(1452, 368, '20.50', '61.30', 0, '2017-08-01 00:00:00'),
(1453, 367, '22.00', '63.00', 0, '2017-08-01 01:00:00'),
(1454, 368, '20.50', '61.30', 0, '2017-08-01 01:00:00'),
(1455, 367, '21.90', '62.90', 0, '2017-08-01 02:00:00'),
(1456, 368, '20.50', '61.30', 0, '2017-08-01 02:00:00'),
(1457, 367, '21.90', '62.90', 0, '2017-08-01 03:00:00'),
(1458, 368, '20.50', '61.30', 0, '2017-08-01 03:00:00'),
(1459, 367, '21.90', '63.60', 0, '2017-08-01 04:00:00'),
(1460, 368, '20.50', '61.30', 0, '2017-08-01 04:00:00'),
(1461, 367, '22.00', '64.00', 0, '2017-08-01 05:00:00'),
(1462, 368, '20.50', '61.30', 0, '2017-08-01 05:00:00'),
(1463, 367, '22.00', '64.30', 0, '2017-08-01 06:00:00'),
(1464, 368, '20.50', '61.30', 0, '2017-08-01 06:00:00'),
(1465, 367, '22.10', '64.40', 0, '2017-08-01 07:00:00'),
(1466, 368, '20.50', '61.30', 0, '2017-08-01 07:00:00'),
(1467, 367, '22.10', '64.40', 0, '2017-08-01 08:00:00'),
(1468, 368, '20.50', '61.30', 0, '2017-08-01 08:00:00'),
(1469, 367, '22.20', '64.40', 0, '2017-08-01 09:00:00'),
(1470, 368, '20.50', '61.30', 0, '2017-08-01 09:00:00'),
(1471, 367, '22.20', '64.50', 0, '2017-08-01 10:00:00'),
(1472, 368, '20.50', '61.30', 0, '2017-08-01 10:00:00'),
(1473, 367, '22.50', '66.10', 0, '2017-08-01 11:00:00'),
(1474, 368, '20.50', '61.30', 0, '2017-08-01 11:00:00'),
(1475, 367, '22.50', '65.10', 0, '2017-08-01 12:00:00'),
(1476, 368, '20.50', '61.30', 0, '2017-08-01 12:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sensores`
--

CREATE TABLE IF NOT EXISTS `sensores` (
`id` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `mac_sensor` text NOT NULL,
  `temperatura` text NOT NULL,
  `humedad` text NOT NULL,
  `habilitado` int(11) NOT NULL DEFAULT '1',
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=369 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sensores`
--

INSERT INTO `sensores` (`id`, `nombre`, `mac_sensor`, `temperatura`, `humedad`, `habilitado`, `cuando`) VALUES
(367, 'Sensor 1', '5C:CF:7F:03:97:58', '22.50', '66.70', 1, '2017-08-01 12:26:35'),
(368, 'Sensor 2', '5C:CF:7F:0A:03:22', '20.50', '61.30', 1, '2017-07-25 13:21:37');

--
-- Disparadores `sensores`
--
DELIMITER //
CREATE TRIGGER `gen_alarma` BEFORE UPDATE ON `sensores`
 FOR EACH ROW begin
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
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por debajo del limite configurado de ",utmin,". HUMEDAD = ",NEW.humedad," por debajo del limite configurado de ",uhmin);
	elseif cast(NEW.humedad as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=2;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por debajo del limite configurado de ",utmin,". HUMEDAD = ",NEW.humedad," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=1;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por debajo del limite configurado de ",utmin,". HUMEDAD = ",NEW.humedad," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;
elseif cast(NEW.temperatura as decimal) > cast(utmax as decimal) then
	if cast(NEW.humedad as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=6;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por encima del limite configurado de ",utmax,". HUMEDAD = ",NEW.humedad," por debajo del limite configurado de ",uhmin);
	elseif cast(NEW.humedad as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=8;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por encima del limite configurado de ",utmax,". HUMEDAD = ",NEW.humedad," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=7;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," por encima del limite configurado de ",utmax,". HUMEDAD = ",NEW.humedad," dentro del limite configurado de ",uhmin," y ",uhmax);
	end if;
else
	if cast(NEW.humedad as decimal) < cast(uhmin as decimal) then
		set nueva_condicion=3;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",NEW.humedad," por debajo del limite configurado de ",uhmin);
	elseif cast(NEW.humedad as decimal) > cast(uhmax as decimal) then
		set nueva_condicion=5;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",NEW.humedad," por encima del limite configurado de ",uhmax);
	else
		set nueva_condicion=4;
        set reporte=concat(nombre_codigo(OLD.id)," : TEMPERATURA = ",NEW.temperatura," dentro del limite configurado de ",utmin," y ",utmax,". HUMEDAD = ",NEW.humedad," dentro del limite configurado de ",uhmin," y ",uhmax);
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
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telegram`
--

CREATE TABLE IF NOT EXISTS `telegram` (
`id` int(11) NOT NULL,
  `numero_serie` text NOT NULL,
  `bot_telegram` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `telegram`
--

INSERT INTO `telegram` (`id`, `numero_serie`, `bot_telegram`) VALUES
(1, '0258768680', 'Ras0Bot');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
`id` int(11) NOT NULL,
  `chat_id` text NOT NULL,
  `habilitado` tinyint(1) NOT NULL,
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `chat_id`, `habilitado`, `cuando`) VALUES
(1, '146095365', 1, '2017-07-18 13:12:40'),
(2, '204915119', 1, '2017-07-15 15:27:36');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas`
--
ALTER TABLE `alertas`
 ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
 ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indices de la tabla `correos`
--
ALTER TABLE `correos`
 ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `datos`
--
ALTER TABLE `datos`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `id_2` (`id`), ADD KEY `id` (`id`), ADD KEY `id_3` (`id`);

--
-- Indices de la tabla `sensores`
--
ALTER TABLE `sensores`
 ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `telegram`
--
ALTER TABLE `telegram`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `id` (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
 ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas`
--
ALTER TABLE `alertas`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=107;
--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `correos`
--
ALTER TABLE `correos`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `datos`
--
ALTER TABLE `datos`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1477;
--
-- AUTO_INCREMENT de la tabla `sensores`
--
ALTER TABLE `sensores`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=369;
--
-- AUTO_INCREMENT de la tabla `telegram`
--
ALTER TABLE `telegram`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`%` EVENT `registrar_datos` ON SCHEDULE EVERY 1 HOUR STARTS '2017-06-13 13:00:00' ON COMPLETION NOT PRESERVE ENABLE DO begin
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
end$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
