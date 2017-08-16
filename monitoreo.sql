-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 16-08-2017 a las 10:02:06
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
CREATE DEFINER=`root`@`%` PROCEDURE `actualizar_camara`(id_camara int, nombre_camara text)
begin
update camaras set nombre=nombre_camara, cuando=cuando where id=id_camara;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `actualizar_limites`(tmin text,tmax text,hmin text,hmax text)
begin
update configuracion set t_min=tmin, t_max=tmax, h_min=hmin, h_max=hmax where 1;
end$$

CREATE DEFINER=`root`@`%` PROCEDURE `actualizar_sensor`(id_sensor int, nombre_sensor text, estado_sensor text)
begin
update sensores set nombre=nombre_sensor, habilitado=estado_sensor, cuando=cuando where id=id_sensor;
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

CREATE DEFINER=`root`@`%` PROCEDURE `cargar_camaras`()
begin
select * from camaras where 1;
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

CREATE DEFINER=`root`@`%` PROCEDURE `cargar_sensores_camara`(id_cam int)
begin 
select * from sensores where id_camara=id_cam;
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

CREATE DEFINER=`root`@`%` FUNCTION `camara_sensor`(id_sensor int) RETURNS int(11)
begin
declare salida int;
select id_camara into salida from sensores where id=id_sensor;
return salida;
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

CREATE DEFINER=`root`@`%` FUNCTION `guardar_sensor_camara`(camara text, sensor text, temp text, hum text) RETURNS int(11)
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

CREATE DEFINER=`root`@`%` FUNCTION `nombre_codigo_camara`(id_cam int) RETURNS text CHARSET latin1
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `alertas`
--

INSERT INTO `alertas` (`id`, `id_sensor`, `condicion`, `mensaje`, `ocultar`, `enviado`, `cuando`) VALUES
(1, 1, 0, 'mac_sensor : TEMPERATURA = temp1 por debajo del limite configurado de 15. HUMEDAD = hum1 por debajo del limite configurado de 20.0', 0, 1, '2017-08-09 14:05:36'),
(2, 1, 5, 'Camara Real: Sensor Real de Camara Real : TEMPERATURA = 23.7 dentro del limite configurado de 15 y 32. HUMEDAD = 75.9 por encima del limite configurado de 70', 0, 1, '2017-08-10 14:00:28'),
(3, 1, 5, 'Camara Real: Sensor Real de Camara Real : TEMPERATURA = 22.6 dentro del limite configurado de 15 y 32. HUMEDAD = 70.5 por encima del limite configurado de 70', 0, 1, '2017-08-10 15:19:27'),
(4, 1, 5, 'Camara Real: Sensor Real de Camara Real : TEMPERATURA = 24.3 dentro del limite configurado de 15 y 32. HUMEDAD = 70.5 por encima del limite configurado de 70', 0, 1, '2017-08-11 23:56:34'),
(5, 1, 5, 'Camara Real: Sensor Real de Camara Real : TEMPERATURA = 24.4 dentro del limite configurado de 15 y 32. HUMEDAD = 71.5 por encima del limite configurado de 70', 0, 1, '2017-08-12 00:56:35'),
(6, 1, 5, 'Camara Real: Sensor Real de Camara Real : TEMPERATURA = 24.3 dentro del limite configurado de 15 y 32. HUMEDAD = 70.7 por encima del limite configurado de 70', 0, 1, '2017-08-12 01:56:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camaras`
--

CREATE TABLE IF NOT EXISTS `camaras` (
`id` int(11) NOT NULL,
  `mac_camara` text NOT NULL,
  `nombre` text NOT NULL,
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `camaras`
--

INSERT INTO `camaras` (`id`, `mac_camara`, `nombre`, `cuando`) VALUES
(1, '5CCF7F039758', 'Camara Real', '2017-08-10 13:18:27'),
(2, 'MAC22', 'Camara Falsa ', '2017-08-10 13:20:13');

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
) ENGINE=InnoDB AUTO_INCREMENT=462 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `datos`
--

INSERT INTO `datos` (`id`, `id_sensor`, `temperatura`, `humedad`, `ocultar`, `cuando`) VALUES
(1, 1, '22.2', '64.5', 0, '2017-08-09 15:00:00'),
(2, 1, '22.4', '64.8', 0, '2017-08-09 16:00:00'),
(3, 1, '22.6', '65.1', 0, '2017-08-09 17:00:00'),
(4, 1, '22.7', '64.8', 0, '2017-08-09 18:00:00'),
(5, 1, '22.6', '65.2', 0, '2017-08-09 19:00:00'),
(6, 1, '22.6', '65.5', 0, '2017-08-09 20:00:00'),
(7, 1, '22.7', '65.3', 0, '2017-08-09 21:00:00'),
(8, 1, '22.7', '65.5', 0, '2017-08-09 22:00:00'),
(9, 1, '22.7', '65.1', 0, '2017-08-09 23:00:00'),
(10, 1, '22.8', '65.6', 0, '2017-08-10 00:00:00'),
(11, 1, '22.9', '65.2', 0, '2017-08-10 01:00:00'),
(12, 1, '22.8', '64.8', 0, '2017-08-10 02:00:00'),
(13, 1, '22.7', '64.5', 0, '2017-08-10 03:00:00'),
(14, 1, '22.6', '64.1', 0, '2017-08-10 04:00:00'),
(15, 1, '22.6', '64.0', 0, '2017-08-10 05:00:00'),
(16, 1, '22.6', '64.0', 0, '2017-08-10 06:00:00'),
(17, 1, '22.7', '63.9', 0, '2017-08-10 07:00:00'),
(18, 1, '22.8', '63.9', 0, '2017-08-10 08:00:00'),
(19, 1, '22.8', '63.8', 0, '2017-08-10 09:00:00'),
(20, 1, '22.8', '63.9', 0, '2017-08-10 10:00:00'),
(21, 1, '23.0', '64.8', 0, '2017-08-10 11:00:00'),
(22, 1, '22.9', '64.1', 0, '2017-08-10 12:00:00'),
(23, 1, '23.0', '65.6', 0, '2017-08-10 13:00:00'),
(24, 1, '23.0', '65.2', 0, '2017-08-10 14:00:00'),
(25, 2, '25.2', '54.5', 0, '2017-08-10 14:00:00'),
(26, 3, '22', '43', 0, '2017-08-10 14:00:00'),
(27, 1, '23.7', '75.9', 0, '2017-08-10 14:00:28'),
(28, 1, '22.7', '63.0', 0, '2017-08-10 15:00:00'),
(29, 2, '25.2', '54.5', 0, '2017-08-10 15:00:01'),
(30, 3, '22', '43', 0, '2017-08-10 15:00:01'),
(31, 1, '22.6', '70.5', 0, '2017-08-10 15:19:27'),
(32, 1, '23.4', '64.2', 0, '2017-08-10 16:00:00'),
(33, 2, '25.2', '54.5', 0, '2017-08-10 16:00:01'),
(34, 3, '22', '43', 0, '2017-08-10 16:00:01'),
(35, 1, '23.5', '63.7', 0, '2017-08-10 17:00:00'),
(36, 2, '25.2', '54.5', 0, '2017-08-10 17:00:01'),
(37, 3, '22', '43', 0, '2017-08-10 17:00:01'),
(38, 1, '23.6', '63.7', 0, '2017-08-10 18:00:00'),
(39, 2, '25.2', '54.5', 0, '2017-08-10 18:00:00'),
(40, 3, '22', '43', 0, '2017-08-10 18:00:00'),
(41, 1, '23.6', '63.8', 0, '2017-08-10 19:00:00'),
(42, 2, '25.2', '54.5', 0, '2017-08-10 19:00:00'),
(43, 3, '22', '43', 0, '2017-08-10 19:00:01'),
(44, 1, '23.7', '63.9', 0, '2017-08-10 20:00:00'),
(45, 2, '25.2', '54.5', 0, '2017-08-10 20:00:00'),
(46, 3, '22', '43', 0, '2017-08-10 20:00:00'),
(47, 1, '23.7', '63.4', 0, '2017-08-10 21:00:00'),
(48, 2, '25.2', '54.5', 0, '2017-08-10 21:00:01'),
(49, 3, '22', '43', 0, '2017-08-10 21:00:01'),
(50, 1, '23.1', '65.1', 0, '2017-08-10 21:50:55'),
(51, 2, '25.2', '54.5', 0, '2017-08-10 21:50:55'),
(52, 3, '22', '43', 0, '2017-08-10 21:50:55'),
(53, 1, '23.4', '64.4', 0, '2017-08-10 22:00:00'),
(54, 2, '25.2', '54.5', 0, '2017-08-10 22:00:00'),
(55, 3, '22', '43', 0, '2017-08-10 22:00:00'),
(56, 1, '23.7', '64.2', 0, '2017-08-10 23:00:00'),
(57, 2, '25.2', '54.5', 0, '2017-08-10 23:00:00'),
(58, 3, '22', '43', 0, '2017-08-10 23:00:01'),
(59, 1, '23.7', '64.4', 0, '2017-08-11 00:00:00'),
(60, 2, '25.2', '54.5', 0, '2017-08-11 00:00:00'),
(61, 3, '22', '43', 0, '2017-08-11 00:00:00'),
(62, 1, '23.7', '64.5', 0, '2017-08-11 01:00:00'),
(63, 2, '25.2', '54.5', 0, '2017-08-11 01:00:00'),
(64, 3, '22', '43', 0, '2017-08-11 01:00:00'),
(65, 1, '23.7', '65.1', 0, '2017-08-11 02:00:00'),
(66, 2, '25.2', '54.5', 0, '2017-08-11 02:00:00'),
(67, 3, '22', '43', 0, '2017-08-11 02:00:00'),
(68, 1, '23.7', '66.0', 0, '2017-08-11 03:00:00'),
(69, 2, '25.2', '54.5', 0, '2017-08-11 03:00:00'),
(70, 3, '22', '43', 0, '2017-08-11 03:00:00'),
(71, 1, '23.8', '65.8', 0, '2017-08-11 04:00:00'),
(72, 2, '25.2', '54.5', 0, '2017-08-11 04:00:00'),
(73, 3, '22', '43', 0, '2017-08-11 04:00:00'),
(74, 1, '23.7', '65.8', 0, '2017-08-11 05:00:00'),
(75, 2, '25.2', '54.5', 0, '2017-08-11 05:00:00'),
(76, 3, '22', '43', 0, '2017-08-11 05:00:00'),
(77, 1, '23.8', '66.0', 0, '2017-08-11 06:00:00'),
(78, 2, '25.2', '54.5', 0, '2017-08-11 06:00:00'),
(79, 3, '22', '43', 0, '2017-08-11 06:00:00'),
(80, 1, '23.9', '66.0', 0, '2017-08-11 07:00:00'),
(81, 2, '25.2', '54.5', 0, '2017-08-11 07:00:00'),
(82, 3, '22', '43', 0, '2017-08-11 07:00:01'),
(83, 1, '23.8', '66.4', 0, '2017-08-11 08:00:00'),
(84, 2, '25.2', '54.5', 0, '2017-08-11 08:00:00'),
(85, 3, '22', '43', 0, '2017-08-11 08:00:00'),
(86, 1, '23.7', '66.4', 0, '2017-08-11 09:00:00'),
(87, 2, '25.2', '54.5', 0, '2017-08-11 09:00:00'),
(88, 3, '22', '43', 0, '2017-08-11 09:00:00'),
(89, 1, '23.7', '66.6', 0, '2017-08-11 10:00:00'),
(90, 2, '25.2', '54.5', 0, '2017-08-11 10:00:00'),
(91, 3, '22', '43', 0, '2017-08-11 10:00:00'),
(92, 1, '24.0', '67.0', 0, '2017-08-11 11:00:00'),
(93, 2, '25.2', '54.5', 0, '2017-08-11 11:00:00'),
(94, 3, '22', '43', 0, '2017-08-11 11:00:00'),
(95, 1, '24.2', '67.8', 0, '2017-08-11 12:00:00'),
(96, 2, '25.2', '54.5', 0, '2017-08-11 12:00:00'),
(97, 3, '22', '43', 0, '2017-08-11 12:00:00'),
(98, 1, '24.3', '69.0', 0, '2017-08-11 13:00:00'),
(99, 2, '25.2', '54.5', 0, '2017-08-11 13:00:00'),
(100, 3, '22', '43', 0, '2017-08-11 13:00:00'),
(101, 1, '24.2', '68.5', 0, '2017-08-11 14:00:00'),
(102, 2, '25.2', '54.5', 0, '2017-08-11 14:00:00'),
(103, 3, '22', '43', 0, '2017-08-11 14:00:00'),
(104, 1, '24.2', '68.0', 0, '2017-08-11 15:00:00'),
(105, 2, '25.2', '54.5', 0, '2017-08-11 15:00:00'),
(106, 3, '22', '43', 0, '2017-08-11 15:00:00'),
(107, 1, '24.1', '67.6', 0, '2017-08-11 16:00:00'),
(108, 2, '25.2', '54.5', 0, '2017-08-11 16:00:00'),
(109, 3, '22', '43', 0, '2017-08-11 16:00:00'),
(110, 1, '24.1', '66.6', 0, '2017-08-11 17:00:00'),
(111, 2, '25.2', '54.5', 0, '2017-08-11 17:00:00'),
(112, 3, '22', '43', 0, '2017-08-11 17:00:00'),
(113, 1, '24.1', '66.5', 0, '2017-08-11 18:00:00'),
(114, 2, '25.2', '54.5', 0, '2017-08-11 18:00:00'),
(115, 3, '22', '43', 0, '2017-08-11 18:00:00'),
(116, 1, '24.1', '66.7', 0, '2017-08-11 19:00:00'),
(117, 2, '25.2', '54.5', 0, '2017-08-11 19:00:00'),
(118, 3, '22', '43', 0, '2017-08-11 19:00:00'),
(119, 1, '24.0', '66.8', 0, '2017-08-11 20:00:00'),
(120, 2, '25.2', '54.5', 0, '2017-08-11 20:00:00'),
(121, 3, '22', '43', 0, '2017-08-11 20:00:01'),
(122, 1, '24.1', '67.1', 0, '2017-08-11 21:00:00'),
(123, 2, '25.2', '54.5', 0, '2017-08-11 21:00:00'),
(124, 3, '22', '43', 0, '2017-08-11 21:00:00'),
(125, 1, '24.2', '67.3', 0, '2017-08-11 22:00:00'),
(126, 2, '25.2', '54.5', 0, '2017-08-11 22:00:00'),
(127, 3, '22', '43', 0, '2017-08-11 22:00:00'),
(128, 1, '24.2', '67.7', 0, '2017-08-11 23:00:00'),
(129, 2, '25.2', '54.5', 0, '2017-08-11 23:00:00'),
(130, 3, '22', '43', 0, '2017-08-11 23:00:00'),
(131, 1, '24.3', '70.5', 0, '2017-08-11 23:56:34'),
(132, 1, '24.4', '70.6', 0, '2017-08-12 00:00:00'),
(133, 2, '25.2', '54.5', 0, '2017-08-12 00:00:00'),
(134, 3, '22', '43', 0, '2017-08-12 00:00:00'),
(135, 1, '24.4', '71.5', 0, '2017-08-12 00:56:35'),
(136, 1, '24.4', '71.6', 0, '2017-08-12 01:00:00'),
(137, 2, '25.2', '54.5', 0, '2017-08-12 01:00:00'),
(138, 3, '22', '43', 0, '2017-08-12 01:00:00'),
(139, 1, '24.3', '70.7', 0, '2017-08-12 01:56:37'),
(140, 1, '24.3', '70.6', 0, '2017-08-12 02:00:00'),
(141, 2, '25.2', '54.5', 0, '2017-08-12 02:00:00'),
(142, 3, '22', '43', 0, '2017-08-12 02:00:01'),
(143, 1, '24.2', '70.0', 0, '2017-08-12 03:00:00'),
(144, 2, '25.2', '54.5', 0, '2017-08-12 03:00:00'),
(145, 3, '22', '43', 0, '2017-08-12 03:00:00'),
(146, 1, '24.2', '69.7', 0, '2017-08-12 04:00:00'),
(147, 2, '25.2', '54.5', 0, '2017-08-12 04:00:00'),
(148, 3, '22', '43', 0, '2017-08-12 04:00:01'),
(149, 1, '24.1', '68.5', 0, '2017-08-12 05:00:00'),
(150, 2, '25.2', '54.5', 0, '2017-08-12 05:00:00'),
(151, 3, '22', '43', 0, '2017-08-12 05:00:00'),
(152, 1, '23.8', '66.0', 0, '2017-08-12 06:00:00'),
(153, 2, '25.2', '54.5', 0, '2017-08-12 06:00:00'),
(154, 3, '22', '43', 0, '2017-08-12 06:00:01'),
(155, 1, '23.7', '64.9', 0, '2017-08-12 07:00:00'),
(156, 2, '25.2', '54.5', 0, '2017-08-12 07:00:00'),
(157, 3, '22', '43', 0, '2017-08-12 07:00:00'),
(158, 1, '23.6', '64.8', 0, '2017-08-12 08:00:00'),
(159, 2, '25.2', '54.5', 0, '2017-08-12 08:00:00'),
(160, 3, '22', '43', 0, '2017-08-12 08:00:01'),
(161, 1, '23.4', '63.8', 0, '2017-08-12 09:00:00'),
(162, 2, '25.2', '54.5', 0, '2017-08-12 09:00:00'),
(163, 3, '22', '43', 0, '2017-08-12 09:00:00'),
(164, 1, '23.4', '63.1', 0, '2017-08-12 10:00:00'),
(165, 2, '25.2', '54.5', 0, '2017-08-12 10:00:00'),
(166, 3, '22', '43', 0, '2017-08-12 10:00:00'),
(167, 1, '23.4', '63.7', 0, '2017-08-12 11:00:00'),
(168, 2, '25.2', '54.5', 0, '2017-08-12 11:00:00'),
(169, 3, '22', '43', 0, '2017-08-12 11:00:00'),
(170, 1, '22.8', '62.5', 0, '2017-08-12 12:00:00'),
(171, 2, '25.2', '54.5', 0, '2017-08-12 12:00:00'),
(172, 3, '22', '43', 0, '2017-08-12 12:00:01'),
(173, 1, '23.0', '63.9', 0, '2017-08-12 13:00:00'),
(174, 2, '25.2', '54.5', 0, '2017-08-12 13:00:00'),
(175, 3, '22', '43', 0, '2017-08-12 13:00:00'),
(176, 1, '22.9', '63.2', 0, '2017-08-12 14:00:00'),
(177, 2, '25.2', '54.5', 0, '2017-08-12 14:00:00'),
(178, 3, '22', '43', 0, '2017-08-12 14:00:00'),
(179, 1, '22.8', '62.5', 0, '2017-08-12 15:00:00'),
(180, 2, '25.2', '54.5', 0, '2017-08-12 15:00:00'),
(181, 3, '22', '43', 0, '2017-08-12 15:00:00'),
(182, 1, '22.8', '61.8', 0, '2017-08-12 16:00:00'),
(183, 2, '25.2', '54.5', 0, '2017-08-12 16:00:00'),
(184, 3, '22', '43', 0, '2017-08-12 16:00:00'),
(185, 1, '22.7', '61.3', 0, '2017-08-12 17:00:00'),
(186, 2, '25.2', '54.5', 0, '2017-08-12 17:00:00'),
(187, 3, '22', '43', 0, '2017-08-12 17:00:00'),
(188, 1, '22.9', '61.3', 0, '2017-08-12 18:00:00'),
(189, 2, '25.2', '54.5', 0, '2017-08-12 18:00:00'),
(190, 3, '22', '43', 0, '2017-08-12 18:00:01'),
(191, 1, '23.3', '63.2', 0, '2017-08-12 19:00:00'),
(192, 2, '25.2', '54.5', 0, '2017-08-12 19:00:00'),
(193, 3, '22', '43', 0, '2017-08-12 19:00:00'),
(194, 1, '23.5', '63.6', 0, '2017-08-12 20:00:00'),
(195, 2, '25.2', '54.5', 0, '2017-08-12 20:00:00'),
(196, 3, '22', '43', 0, '2017-08-12 20:00:00'),
(197, 1, '22.9', '60.1', 0, '2017-08-12 21:00:00'),
(198, 2, '25.2', '54.5', 0, '2017-08-12 21:00:00'),
(199, 3, '22', '43', 0, '2017-08-12 21:00:00'),
(200, 1, '22.9', '61.2', 0, '2017-08-12 22:00:00'),
(201, 2, '25.2', '54.5', 0, '2017-08-12 22:00:00'),
(202, 3, '22', '43', 0, '2017-08-12 22:00:00'),
(203, 1, '23.3', '65.3', 0, '2017-08-12 23:00:00'),
(204, 2, '25.2', '54.5', 0, '2017-08-12 23:00:00'),
(205, 3, '22', '43', 0, '2017-08-12 23:00:00'),
(206, 1, '23.5', '66.1', 0, '2017-08-13 00:00:00'),
(207, 2, '25.2', '54.5', 0, '2017-08-13 00:00:00'),
(208, 3, '22', '43', 0, '2017-08-13 00:00:01'),
(209, 1, '23.7', '64.0', 0, '2017-08-13 01:00:00'),
(210, 2, '25.2', '54.5', 0, '2017-08-13 01:00:00'),
(211, 3, '22', '43', 0, '2017-08-13 01:00:00'),
(212, 1, '23.6', '65.3', 0, '2017-08-13 02:00:00'),
(213, 2, '25.2', '54.5', 0, '2017-08-13 02:00:00'),
(214, 3, '22', '43', 0, '2017-08-13 02:00:00'),
(215, 1, '23.5', '65.0', 0, '2017-08-13 03:00:00'),
(216, 2, '25.2', '54.5', 0, '2017-08-13 03:00:00'),
(217, 3, '22', '43', 0, '2017-08-13 03:00:00'),
(218, 1, '23.5', '64.7', 0, '2017-08-13 04:00:00'),
(219, 2, '25.2', '54.5', 0, '2017-08-13 04:00:00'),
(220, 3, '22', '43', 0, '2017-08-13 04:00:01'),
(221, 1, '23.6', '65.0', 0, '2017-08-13 05:00:00'),
(222, 2, '25.2', '54.5', 0, '2017-08-13 05:00:00'),
(223, 3, '22', '43', 0, '2017-08-13 05:00:01'),
(224, 1, '23.6', '64.3', 0, '2017-08-13 06:00:00'),
(225, 2, '25.2', '54.5', 0, '2017-08-13 06:00:00'),
(226, 3, '22', '43', 0, '2017-08-13 06:00:00'),
(227, 1, '23.6', '64.6', 0, '2017-08-13 07:00:00'),
(228, 2, '25.2', '54.5', 0, '2017-08-13 07:00:00'),
(229, 3, '22', '43', 0, '2017-08-13 07:00:00'),
(230, 1, '23.7', '63.8', 0, '2017-08-13 08:00:00'),
(231, 2, '25.2', '54.5', 0, '2017-08-13 08:00:00'),
(232, 3, '22', '43', 0, '2017-08-13 08:00:00'),
(233, 1, '23.7', '63.3', 0, '2017-08-13 09:00:00'),
(234, 2, '25.2', '54.5', 0, '2017-08-13 09:00:00'),
(235, 3, '22', '43', 0, '2017-08-13 09:00:01'),
(236, 1, '23.6', '62.7', 0, '2017-08-13 10:00:00'),
(237, 2, '25.2', '54.5', 0, '2017-08-13 10:00:00'),
(238, 3, '22', '43', 0, '2017-08-13 10:00:00'),
(239, 1, '23.6', '63.0', 0, '2017-08-13 11:00:00'),
(240, 2, '25.2', '54.5', 0, '2017-08-13 11:00:00'),
(241, 3, '22', '43', 0, '2017-08-13 11:00:00'),
(242, 1, '23.6', '62.0', 0, '2017-08-13 12:00:00'),
(243, 2, '25.2', '54.5', 0, '2017-08-13 12:00:00'),
(244, 3, '22', '43', 0, '2017-08-13 12:00:00'),
(245, 1, '23.7', '63.4', 0, '2017-08-13 13:00:00'),
(246, 2, '25.2', '54.5', 0, '2017-08-13 13:00:00'),
(247, 3, '22', '43', 0, '2017-08-13 13:00:01'),
(248, 1, '23.7', '64.0', 0, '2017-08-13 14:00:00'),
(249, 2, '25.2', '54.5', 0, '2017-08-13 14:00:00'),
(250, 3, '22', '43', 0, '2017-08-13 14:00:00'),
(251, 1, '23.7', '61.7', 0, '2017-08-13 15:00:00'),
(252, 2, '25.2', '54.5', 0, '2017-08-13 15:00:00'),
(253, 3, '22', '43', 0, '2017-08-13 15:00:00'),
(254, 1, '23.7', '60.3', 0, '2017-08-13 16:00:00'),
(255, 2, '25.2', '54.5', 0, '2017-08-13 16:00:00'),
(256, 3, '22', '43', 0, '2017-08-13 16:00:00'),
(257, 1, '23.7', '58.8', 0, '2017-08-13 17:00:00'),
(258, 2, '25.2', '54.5', 0, '2017-08-13 17:00:00'),
(259, 3, '22', '43', 0, '2017-08-13 17:00:00'),
(260, 1, '23.7', '57.9', 0, '2017-08-13 18:00:00'),
(261, 2, '25.2', '54.5', 0, '2017-08-13 18:00:00'),
(262, 3, '22', '43', 0, '2017-08-13 18:00:01'),
(263, 1, '23.8', '57.1', 0, '2017-08-13 19:00:00'),
(264, 2, '25.2', '54.5', 0, '2017-08-13 19:00:00'),
(265, 3, '22', '43', 0, '2017-08-13 19:00:00'),
(266, 1, '23.8', '56.7', 0, '2017-08-13 20:00:00'),
(267, 2, '25.2', '54.5', 0, '2017-08-13 20:00:00'),
(268, 3, '22', '43', 0, '2017-08-13 20:00:00'),
(269, 1, '23.8', '57.9', 0, '2017-08-13 21:00:00'),
(270, 2, '25.2', '54.5', 0, '2017-08-13 21:00:00'),
(271, 3, '22', '43', 0, '2017-08-13 21:00:00'),
(272, 1, '23.7', '58.8', 0, '2017-08-13 22:00:00'),
(273, 2, '25.2', '54.5', 0, '2017-08-13 22:00:00'),
(274, 3, '22', '43', 0, '2017-08-13 22:00:00'),
(275, 1, '23.7', '59.8', 0, '2017-08-13 23:00:00'),
(276, 2, '25.2', '54.5', 0, '2017-08-13 23:00:00'),
(277, 3, '22', '43', 0, '2017-08-13 23:00:00'),
(278, 1, '23.7', '59.9', 0, '2017-08-14 00:00:00'),
(279, 2, '25.2', '54.5', 0, '2017-08-14 00:00:00'),
(280, 3, '22', '43', 0, '2017-08-14 00:00:01'),
(281, 1, '23.6', '59.8', 0, '2017-08-14 01:00:00'),
(282, 2, '25.2', '54.5', 0, '2017-08-14 01:00:00'),
(283, 3, '22', '43', 0, '2017-08-14 01:00:00'),
(284, 1, '23.6', '59.9', 0, '2017-08-14 02:00:00'),
(285, 2, '25.2', '54.5', 0, '2017-08-14 02:00:00'),
(286, 3, '22', '43', 0, '2017-08-14 02:00:00'),
(287, 1, '23.5', '59.4', 0, '2017-08-14 03:00:00'),
(288, 2, '25.2', '54.5', 0, '2017-08-14 03:00:00'),
(289, 3, '22', '43', 0, '2017-08-14 03:00:00'),
(290, 1, '23.4', '59.1', 0, '2017-08-14 04:00:00'),
(291, 2, '25.2', '54.5', 0, '2017-08-14 04:00:00'),
(292, 3, '22', '43', 0, '2017-08-14 04:00:01'),
(293, 1, '23.3', '59.6', 0, '2017-08-14 05:00:00'),
(294, 2, '25.2', '54.5', 0, '2017-08-14 05:00:00'),
(295, 3, '22', '43', 0, '2017-08-14 05:00:01'),
(296, 1, '23.3', '60.0', 0, '2017-08-14 06:00:00'),
(297, 2, '25.2', '54.5', 0, '2017-08-14 06:00:00'),
(298, 3, '22', '43', 0, '2017-08-14 06:00:00'),
(299, 1, '23.2', '60.1', 0, '2017-08-14 07:00:00'),
(300, 2, '25.2', '54.5', 0, '2017-08-14 07:00:00'),
(301, 3, '22', '43', 0, '2017-08-14 07:00:00'),
(302, 1, '23.1', '59.6', 0, '2017-08-14 08:00:00'),
(303, 2, '25.2', '54.5', 0, '2017-08-14 08:00:00'),
(304, 3, '22', '43', 0, '2017-08-14 08:00:01'),
(305, 1, '23.1', '57.7', 0, '2017-08-14 09:00:00'),
(306, 2, '25.2', '54.5', 0, '2017-08-14 09:00:00'),
(307, 3, '22', '43', 0, '2017-08-14 09:00:00'),
(308, 1, '23.0', '57.7', 0, '2017-08-14 10:00:00'),
(309, 2, '25.2', '54.5', 0, '2017-08-14 10:00:00'),
(310, 3, '22', '43', 0, '2017-08-14 10:00:00'),
(311, 1, '23.1', '59.1', 0, '2017-08-14 11:00:00'),
(312, 2, '25.2', '54.5', 0, '2017-08-14 11:00:00'),
(313, 3, '22', '43', 0, '2017-08-14 11:00:01'),
(314, 1, '23.1', '55.0', 0, '2017-08-14 12:00:00'),
(315, 2, '25.2', '54.5', 0, '2017-08-14 12:00:00'),
(316, 3, '22', '43', 0, '2017-08-14 12:00:01'),
(317, 1, '23.0', '55.3', 0, '2017-08-14 13:00:00'),
(318, 2, '25.2', '54.5', 0, '2017-08-14 13:00:00'),
(319, 3, '22', '43', 0, '2017-08-14 13:00:00'),
(320, 1, '22.9', '54.6', 0, '2017-08-14 14:00:00'),
(321, 2, '25.2', '54.5', 0, '2017-08-14 14:00:00'),
(322, 3, '22', '43', 0, '2017-08-14 14:00:00'),
(323, 1, '22.9', '54.1', 0, '2017-08-14 15:00:00'),
(324, 2, '25.2', '54.5', 0, '2017-08-14 15:00:00'),
(325, 3, '22', '43', 0, '2017-08-14 15:00:01'),
(326, 1, '23.0', '53.3', 0, '2017-08-14 16:00:00'),
(327, 2, '25.2', '54.5', 0, '2017-08-14 16:00:00'),
(328, 3, '22', '43', 0, '2017-08-14 16:00:00'),
(329, 1, '23.0', '53.6', 0, '2017-08-14 17:00:00'),
(330, 2, '25.2', '54.5', 0, '2017-08-14 17:00:00'),
(331, 3, '22', '43', 0, '2017-08-14 17:00:00'),
(332, 1, '23.0', '53.5', 0, '2017-08-14 18:00:00'),
(333, 2, '25.2', '54.5', 0, '2017-08-14 18:00:00'),
(334, 3, '22', '43', 0, '2017-08-14 18:00:01'),
(335, 1, '23.1', '51.6', 0, '2017-08-14 19:00:00'),
(336, 2, '25.2', '54.5', 0, '2017-08-14 19:00:00'),
(337, 3, '22', '43', 0, '2017-08-14 19:00:00'),
(338, 1, '23.0', '52.6', 0, '2017-08-14 20:00:00'),
(339, 2, '25.2', '54.5', 0, '2017-08-14 20:00:00'),
(340, 3, '22', '43', 0, '2017-08-14 20:00:00'),
(341, 1, '23.0', '54.5', 0, '2017-08-14 21:00:00'),
(342, 2, '25.2', '54.5', 0, '2017-08-14 21:00:00'),
(343, 3, '22', '43', 0, '2017-08-14 21:00:00'),
(344, 1, '23.0', '57.4', 0, '2017-08-14 22:00:00'),
(345, 2, '25.2', '54.5', 0, '2017-08-14 22:00:00'),
(346, 3, '22', '43', 0, '2017-08-14 22:00:01'),
(347, 1, '23.0', '57.9', 0, '2017-08-14 23:00:00'),
(348, 2, '25.2', '54.5', 0, '2017-08-14 23:00:00'),
(349, 3, '22', '43', 0, '2017-08-14 23:00:00'),
(350, 1, '23.2', '59.2', 0, '2017-08-15 00:00:00'),
(351, 2, '25.2', '54.5', 0, '2017-08-15 00:00:00'),
(352, 3, '22', '43', 0, '2017-08-15 00:00:01'),
(353, 1, '23.3', '59.8', 0, '2017-08-15 01:00:00'),
(354, 2, '25.2', '54.5', 0, '2017-08-15 01:00:00'),
(355, 3, '22', '43', 0, '2017-08-15 01:00:00'),
(356, 1, '23.2', '60.2', 0, '2017-08-15 02:00:00'),
(357, 2, '25.2', '54.5', 0, '2017-08-15 02:00:00'),
(358, 3, '22', '43', 0, '2017-08-15 02:00:00'),
(359, 1, '23.3', '60.3', 0, '2017-08-15 03:00:00'),
(360, 2, '25.2', '54.5', 0, '2017-08-15 03:00:00'),
(361, 3, '22', '43', 0, '2017-08-15 03:00:01'),
(362, 1, '23.3', '60.7', 0, '2017-08-15 04:00:00'),
(363, 2, '25.2', '54.5', 0, '2017-08-15 04:00:00'),
(364, 3, '22', '43', 0, '2017-08-15 04:00:00'),
(365, 1, '23.3', '61.0', 0, '2017-08-15 05:00:00'),
(366, 2, '25.2', '54.5', 0, '2017-08-15 05:00:00'),
(367, 3, '22', '43', 0, '2017-08-15 05:00:01'),
(368, 1, '23.3', '61.1', 0, '2017-08-15 06:00:00'),
(369, 2, '25.2', '54.5', 0, '2017-08-15 06:00:00'),
(370, 3, '22', '43', 0, '2017-08-15 06:00:01'),
(371, 1, '23.3', '61.0', 0, '2017-08-15 07:00:00'),
(372, 2, '25.2', '54.5', 0, '2017-08-15 07:00:00'),
(373, 3, '22', '43', 0, '2017-08-15 07:00:00'),
(374, 1, '23.4', '61.1', 0, '2017-08-15 08:00:00'),
(375, 2, '25.2', '54.5', 0, '2017-08-15 08:00:00'),
(376, 3, '22', '43', 0, '2017-08-15 08:00:00'),
(377, 1, '23.3', '61.2', 0, '2017-08-15 09:00:00'),
(378, 2, '25.2', '54.5', 0, '2017-08-15 09:00:00'),
(379, 3, '22', '43', 0, '2017-08-15 09:00:00'),
(380, 1, '23.4', '61.5', 0, '2017-08-15 10:00:00'),
(381, 2, '25.2', '54.5', 0, '2017-08-15 10:00:00'),
(382, 3, '22', '43', 0, '2017-08-15 10:00:01'),
(383, 1, '23.6', '62.6', 0, '2017-08-15 11:00:00'),
(384, 2, '25.2', '54.5', 0, '2017-08-15 11:00:00'),
(385, 3, '22', '43', 0, '2017-08-15 11:00:01'),
(386, 1, '23.5', '61.5', 0, '2017-08-15 12:00:00'),
(387, 2, '25.2', '54.5', 0, '2017-08-15 12:00:00'),
(388, 3, '22', '43', 0, '2017-08-15 12:00:01'),
(389, 1, '23.5', '60.2', 0, '2017-08-15 13:00:00'),
(390, 2, '25.2', '54.5', 0, '2017-08-15 13:00:00'),
(391, 3, '22', '43', 0, '2017-08-15 13:00:00'),
(392, 1, '23.4', '59.9', 0, '2017-08-15 14:00:00'),
(393, 2, '25.2', '54.5', 0, '2017-08-15 14:00:00'),
(394, 3, '22', '43', 0, '2017-08-15 14:00:00'),
(395, 1, '23.4', '58.5', 0, '2017-08-15 15:00:00'),
(396, 2, '25.2', '54.5', 0, '2017-08-15 15:00:00'),
(397, 3, '22', '43', 0, '2017-08-15 15:00:00'),
(398, 1, '23.5', '58.5', 0, '2017-08-15 16:00:00'),
(399, 2, '25.2', '54.5', 0, '2017-08-15 16:00:00'),
(400, 3, '22', '43', 0, '2017-08-15 16:00:00'),
(401, 1, '23.5', '57.3', 0, '2017-08-15 17:00:00'),
(402, 2, '25.2', '54.5', 0, '2017-08-15 17:00:00'),
(403, 3, '22', '43', 0, '2017-08-15 17:00:00'),
(404, 1, '23.5', '56.9', 0, '2017-08-15 18:00:00'),
(405, 2, '25.2', '54.5', 0, '2017-08-15 18:00:00'),
(406, 3, '22', '43', 0, '2017-08-15 18:00:00'),
(407, 1, '23.6', '57.6', 0, '2017-08-15 19:00:00'),
(408, 2, '25.2', '54.5', 0, '2017-08-15 19:00:00'),
(409, 3, '22', '43', 0, '2017-08-15 19:00:00'),
(410, 1, '23.6', '58.5', 0, '2017-08-15 20:00:00'),
(411, 2, '25.2', '54.5', 0, '2017-08-15 20:00:00'),
(412, 3, '22', '43', 0, '2017-08-15 20:00:00'),
(413, 1, '23.7', '58.4', 0, '2017-08-15 21:00:00'),
(414, 2, '25.2', '54.5', 0, '2017-08-15 21:00:00'),
(415, 3, '22', '43', 0, '2017-08-15 21:00:00'),
(416, 1, '23.7', '59.4', 0, '2017-08-15 22:00:00'),
(417, 2, '25.2', '54.5', 0, '2017-08-15 22:00:00'),
(418, 3, '22', '43', 0, '2017-08-15 22:00:00'),
(419, 1, '23.8', '59.9', 0, '2017-08-15 23:00:00'),
(420, 2, '25.2', '54.5', 0, '2017-08-15 23:00:00'),
(421, 3, '22', '43', 0, '2017-08-15 23:00:00'),
(422, 1, '23.8', '60.3', 0, '2017-08-16 00:00:00'),
(423, 2, '25.2', '54.5', 0, '2017-08-16 00:00:00'),
(424, 3, '22', '43', 0, '2017-08-16 00:00:00'),
(425, 1, '23.7', '59.8', 0, '2017-08-16 01:00:00'),
(426, 2, '25.2', '54.5', 0, '2017-08-16 01:00:00'),
(427, 3, '22', '43', 0, '2017-08-16 01:00:00'),
(428, 1, '23.8', '60.3', 0, '2017-08-16 02:00:00'),
(429, 2, '25.2', '54.5', 0, '2017-08-16 02:00:00'),
(430, 3, '22', '43', 0, '2017-08-16 02:00:00'),
(431, 1, '23.8', '62.0', 0, '2017-08-16 03:00:00'),
(432, 2, '25.2', '54.5', 0, '2017-08-16 03:00:00'),
(433, 3, '22', '43', 0, '2017-08-16 03:00:00'),
(434, 1, '23.7', '62.3', 0, '2017-08-16 04:00:00'),
(435, 2, '25.2', '54.5', 0, '2017-08-16 04:00:00'),
(436, 3, '22', '43', 0, '2017-08-16 04:00:00'),
(437, 1, '23.7', '61.4', 0, '2017-08-16 05:00:00'),
(438, 2, '25.2', '54.5', 0, '2017-08-16 05:00:00'),
(439, 3, '22', '43', 0, '2017-08-16 05:00:00'),
(440, 1, '23.5', '60.6', 0, '2017-08-16 06:00:00'),
(441, 2, '25.2', '54.5', 0, '2017-08-16 06:00:00'),
(442, 3, '22', '43', 0, '2017-08-16 06:00:00'),
(443, 1, '23.4', '59.6', 0, '2017-08-16 07:00:00'),
(444, 2, '25.2', '54.5', 0, '2017-08-16 07:00:00'),
(445, 3, '22', '43', 0, '2017-08-16 07:00:00'),
(446, 1, '23.4', '59.2', 0, '2017-08-16 08:00:00'),
(447, 2, '25.2', '54.5', 0, '2017-08-16 08:00:00'),
(448, 3, '22', '43', 0, '2017-08-16 08:00:00'),
(449, 1, '23.2', '58.2', 0, '2017-08-16 09:00:00'),
(450, 2, '25.2', '54.5', 0, '2017-08-16 09:00:00'),
(451, 3, '22', '43', 0, '2017-08-16 09:00:00'),
(452, 1, '23.2', '58.6', 0, '2017-08-16 10:00:00'),
(453, 2, '25.2', '54.5', 0, '2017-08-16 10:00:00'),
(454, 3, '22', '43', 0, '2017-08-16 10:00:01'),
(455, 1, '23.3', '59.5', 0, '2017-08-16 11:00:00'),
(456, 2, '25.2', '54.5', 0, '2017-08-16 11:00:00'),
(457, 3, '22', '43', 0, '2017-08-16 11:00:00'),
(458, 1, '23.4', '60.6', 0, '2017-08-16 12:00:00'),
(459, 2, '25.2', '54.5', 0, '2017-08-16 12:00:00'),
(460, 3, '22', '43', 0, '2017-08-16 12:00:00'),
(461, 1, '23.4', '61.0', 0, '2017-08-16 13:00:00');

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
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_camara` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sensores`
--

INSERT INTO `sensores` (`id`, `nombre`, `mac_sensor`, `temperatura`, `humedad`, `habilitado`, `cuando`, `id_camara`) VALUES
(1, 'Sensor Real de Camara Real', '5CCF7F039758', '23.4', '60.8', 1, '2017-08-16 13:02:06', 1),
(2, 'Sensor Falso de Camara Real', 'MAC', '25.2', '54.5', 0, '2017-08-10 13:43:49', 1),
(3, 'Sensor Falso de Camara Falsa', 'Mac3', '22', '43', 0, '2017-08-10 13:24:11', 2);

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
-- Estructura de tabla para la tabla `temporal`
--

CREATE TABLE IF NOT EXISTS `temporal` (
`id` int(11) NOT NULL,
  `camara` text NOT NULL,
  `sensor` text NOT NULL,
  `temperatura` text NOT NULL,
  `humedad` text NOT NULL,
  `cuando` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `temporal`
--

INSERT INTO `temporal` (`id`, `camara`, `sensor`, `temperatura`, `humedad`, `cuando`) VALUES
(1, '5CCF7F039758', '5CCF7F039758', '22.1', '64.4', '2017-08-09 13:57:39');

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
-- Indices de la tabla `camaras`
--
ALTER TABLE `camaras`
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
-- Indices de la tabla `temporal`
--
ALTER TABLE `temporal`
 ADD PRIMARY KEY (`id`);

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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `camaras`
--
ALTER TABLE `camaras`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=462;
--
-- AUTO_INCREMENT de la tabla `sensores`
--
ALTER TABLE `sensores`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `telegram`
--
ALTER TABLE `telegram`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `temporal`
--
ALTER TABLE `temporal`
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
