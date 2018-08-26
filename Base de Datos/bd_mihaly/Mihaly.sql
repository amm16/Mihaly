-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u3
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 25-08-2018 a las 22:15:01
-- Versión del servidor: 5.5.59-0+deb8u1
-- Versión de PHP: 5.6.36-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `mihaly`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_accesos`(

	in p_codigo_usuario int
)
begin

    -- Se agrega nuevo acceso
		INSERT INTO tbl_accesos( 
            codigo_usuario,
            fecha_acceso
            )
		VALUES (
			p_codigo_usuario,
            sysdate()
            );
  
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_archivos`(
	in p_accion int,
    in p_codigo_archivo int,
	in p_codigo_carpeta_padre int,
    in p_codigo_usuario int,
    in p_nombre_archivo varchar(150),
    in p_tipo_archivo varchar(60),
    in p_fecha_creacion date,
    in p_contenido blob,
    in p_estado int
)
begin
	if p_accion=1 then
    -- Se agrega nuevo archivo
		INSERT INTO tbl_archivo (
			codigo_usuario,
            nombre_archivo,
            fecha_creacion,
            codigo_carpeta_padre,
            tipo_archivo,
            estado,
            contenido
            )
		VALUES (
			p_codigo_usuario,
            p_nombre_archivo, 
            sysdate(),
            p_codigo_carpeta_padre,
            p_tipo_archivo,
            1,'//'
            );
            
    ELSEIF p_accion=2 and p_codigo_archivo  IS NOT NULL THEN
		-- Modificar Nombre Archivo
		IF p_nombre_archivo IS NOT NULL THEN
			UPDATE tbl_archivo
			SET nombre_archivo= p_nombre_archivo
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
        -- Modificar Estado
		IF p_estado IS NOT NULL THEN
			UPDATE tbl_archivo
			SET estado= p_estado
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
        -- Modificar Contenido
		IF p_contenido IS NOT NULL THEN
			UPDATE tbl_archivo
			SET contenido= p_contenido
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
        -- Modificar Codigo Usuario
		IF p_codigo_usuario IS NOT NULL THEN
			UPDATE tbl_archivo
			SET codigo_usuario= p_codigo_usuario
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
	
	  -- Modificar Tipo Archivo
		IF p_tipo_archivo IS NOT NULL THEN
			UPDATE tbl_archivo
			SET tipo_archivo = p_tipo_archivo
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
      

      -- Modificar Fecha Creacion
       IF p_fecha_creacion IS NOT NULL THEN
			UPDATE tbl_archivo
			SET fecha_creacion = p_fecha_creacion
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
		
    ELSEIF p_accion=3 AND p_codigo_archivo  IS NOT NULL THEN
    -- Se elimina archivo
        DELETE FROM tbl_archivo
		WHERE(codigo_archivo=p_codigo_archivo);
    ELSE 
		SELECT 'Error,No es una accion definida';
	END IF;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_archivos_compartidos`(
	in p_accion int,
    in p_codigo_archivo int,
	in p_correo varchar(60)
)
begin
	set @codigo := (select codigo_usuario
    from tbl_usuarios
    where correo = p_correo);
    if @codigo is not null then
	if p_accion=1 then
    
    -- Se agrega nuevo relacion de archivo
		INSERT IGNORE INTO tbl_archivos_compartidos (
            codigo_archivo,
            codigo_usuario
            )
		VALUES (
            p_codigo_archivo,
			@codigo

            );
		
    ELSEIF p_accion=2 
		AND p_codigo_archivo IS NOT NULL
        AND p_codigo_usuario IS NOT NULL THEN
    -- Se elimina relacion de archivo compartido
        DELETE FROM tbl_archivos_compartidos
		WHERE(codigo_archivo=p_codigo_archivo
        AND codigo_usuario=p_codigo_usuario);
    ELSE 
		SELECT 'Error,No es una accion definida';
	END IF;
    end if;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_archivos`(

	in p_codigo_usuario int,
    in p_codigo_padre int
    
)
begin
	if(p_codigo_padre is null) then
		SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
		FROM tbl_archivo
		WHERE (codigo_usuario = p_codigo_usuario AND
			codigo_carpeta_padre is null AND
            estado='1');
	ELSE
		SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
		FROM tbl_archivo
		WHERE (codigo_usuario = p_codigo_usuario AND
			codigo_carpeta_padre =p_codigo_padre AND
            estado='1');
	END IF;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_compartidos`(

	in p_codigo_usuario int
    
)
begin
	SELECT A.codigo_archivo as codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
	FROM tbl_archivos_compartidos A
	Left join tbl_archivo B
	on (A.codigo_archivo = B.codigo_archivo)
	WHERE (A.codigo_usuario = p_codigo_usuario AND
            estado='1');
            
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_favoritos`(

	in p_codigo_usuario int
    
)
begin
	SELECT A.codigo_archivo as codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
	FROM tbl_favoritos A
	Left join tbl_archivo B
	on (A.codigo_archivo = B.codigo_archivo)
	WHERE (A.codigo_usuario = p_codigo_usuario AND
            estado='1');
            
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_papelera`(

	in p_codigo_usuario int
    
)
begin
	SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
	FROM tbl_archivo
	WHERE (codigo_usuario = p_codigo_usuario AND
            estado='2');
            
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_perfil`(

	in p_codigo_usuario int
    
)
begin
	SELECT codigo_usuario, codigo_tipo_usuario, A.codigo_plan as codigo_plan, usuario,correo,nombre_plan
    FROM tbl_usuarios A
    LEFT JOIN tbl_planes B
    ON (A.codigo_plan=B.codigo_plan)
    WHERE (codigo_usuario=p_codigo_usuario );
            
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_usuarios_registrados`()
begin
	SELECT A.codigo_usuario, C.codigo_tipo_usuario, A.codigo_plan as codigo_plan, usuario,correo,nombre_plan,fecha_registro,nombre_tipo_usuario
    FROM tbl_usuarios A
    LEFT JOIN tbl_planes B
    ON (A.codigo_plan=B.codigo_plan)
    Left JOIN tbl_tipos_usuarios C
    ON (A.codigo_tipo_usuario=C.codigo_tipo_usuario);
            
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contenido_archivo`(
    in p_codigo_archivo int
    
)
begin

    SELECT nombre_archivo,contenido,codigo_archivo
    FROM tbl_archivo
    WHERE (codigo_archivo = p_codigo_archivo);
  
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_correo`(

	in p_correo varchar(60)
)
begin

    SELECT correo
    FROM tbl_usuarios
    WHERE (correo = p_correo);
  
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_favoritos`(
    in p_codigo_archivo int,
	in p_codigo_usuario int
)
begin
	SET SQL_SAFE_UPDATES = 0;

    -- Se agrega nuevo relacion de archivo
		INSERT INTO tbl_favoritos (
            codigo_archivo,
            codigo_usuario
            )
		VALUES (
            p_codigo_archivo,
            p_codigo_usuario

            )On Duplicate Key Update eliminar = 1;

        DELETE FROM tbl_favoritos
		WHERE eliminar = 1;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login`(

	in p_correo varchar(60),
    in p_clave varchar(60)
)
begin

    SELECT codigo_usuario, codigo_tipo_usuario, codigo_plan, usuario,correo
    FROM tbl_usuarios
    WHERE (correo = p_correo AND clave = sha1(p_clave));
  
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nombre_archivos`(
    in p_codigo_archivo int
    
)
begin

    SELECT nombre_archivo
    FROM tbl_archivo
    WHERE (codigo_archivo = p_codigo_archivo);
  
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuarios`(
	in p_accion int,
	in p_tipo_usuario int,
    in p_codigo_usuario int,
	in p_plan int,
    in p_usuario varchar(60),
    in p_clave varchar(60),
    in p_correo varchar(60),
    in p_imagen varchar(60)
)
begin
	if p_accion=1 then
    -- Se agrega nuevo usuario
		INSERT INTO tbl_usuarios (
			codigo_tipo_usuario,
            codigo_plan,
			usuario,
			correo,
			clave,
			fecha_registro
            )
		VALUES (
			p_tipo_usuario,
			p_plan,
			p_usuario,
			p_correo,
			sha1(p_clave),
			sysdate()
            );
    ELSEIF p_accion=2 AND p_codigo_usuario IS NOT NULL THEN
		-- Modificar Tipo Usuario
		IF p_tipo_usuario IS NOT NULL THEN
			UPDATE tbl_usuarios
			SET codigo_tipo_usuario = p_tipo_usuario
			WHERE (codigo_usuario=p_codigo_usuario); 
        END IF;
	  -- Modificar Plan
        IF p_plan IS NOT NULL THEN
			UPDATE tbl_usuarios
			SET codigo_plan = p_plan
			WHERE (codigo_usuario=p_codigo_usuario); 
        END IF;
	  -- Modificar Usuario
		IF p_usuario IS NOT NULL THEN
			UPDATE tbl_usuarios
			SET usuario = p_usuario
			WHERE (codigo_usuario=p_codigo_usuario); 
        END IF;
      -- Modificar Correo
		IF p_correo IS NOT NULL THEN
			UPDATE tbl_usuarios
			SET correo = p_correo
			WHERE (codigo_usuario=p_codigo_usuario);
		END IF;
      -- Modificar Clave
		IF p_clave IS NOT NULL THEN
			UPDATE tbl_usuarios
			SET clave = sha1(p_clave)
			WHERE (codigo_usuario=p_codigo_usuario); 
        END IF;
      -- Modificar Imagen
      IF p_imagen IS NOT NULL THEN
			UPDATE tbl_usuarios
			SET imagen_perfil_url = p_imagen
			WHERE (codigo_usuario=p_codigo_usuario); 
        END IF;

		
    ELSEIF p_accion=3 AND p_codigo_usuario IS NOT NULL THEN
    -- Se elimina usuario
        DELETE FROM tbl_usuarios
		WHERE(codigo_usuario=p_codigo_usuario);
    ELSE 
		SELECT 'Error,No es una accion definida';
	END IF;
	 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl-usuarios`
--

CREATE TABLE IF NOT EXISTS `tbl-usuarios` (
  `codigo-usuario` int(11) NOT NULL,
  `tbl-usuarioscol` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_accesos`
--

CREATE TABLE IF NOT EXISTS `tbl_accesos` (
`codigo_acceso` int(11) NOT NULL,
  `codigo_usuario` int(11) NOT NULL,
  `fecha_acceso` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=430 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_accesos`
--

INSERT INTO `tbl_accesos` (`codigo_acceso`, `codigo_usuario`, `fecha_acceso`) VALUES
(1, 1, '2018-08-16 00:00:00'),
(2, 1, '2018-08-16 00:00:00'),
(3, 1, '2018-08-16 00:00:00'),
(4, 1, '2018-08-16 00:00:00'),
(5, 1, '2018-08-16 00:00:00'),
(8, 2, '2018-08-17 00:00:00'),
(9, 2, '2018-08-17 00:00:00'),
(10, 2, '2018-08-17 00:00:00'),
(11, 2, '2018-08-17 00:00:00'),
(12, 7, '2018-08-17 02:56:06'),
(13, 9, '2018-08-17 02:58:05'),
(14, 11, '2018-08-17 03:45:34'),
(15, 2, '2018-08-17 16:53:43'),
(16, 1, '2018-08-17 16:58:27'),
(17, 2, '2018-08-17 17:07:24'),
(18, 2, '2018-08-17 17:08:37'),
(19, 2, '2018-08-17 17:08:40'),
(20, 2, '2018-08-17 17:08:40'),
(21, 2, '2018-08-17 17:08:41'),
(22, 2, '2018-08-17 17:14:07'),
(23, 2, '2018-08-17 17:14:19'),
(24, 2, '2018-08-17 17:16:28'),
(25, 2, '2018-08-17 17:16:50'),
(26, 2, '2018-08-17 17:46:31'),
(27, 2, '2018-08-17 17:56:00'),
(28, 2, '2018-08-17 18:08:04'),
(29, 2, '2018-08-17 18:08:32'),
(30, 2, '2018-08-17 18:10:11'),
(31, 2, '2018-08-17 18:17:14'),
(32, 2, '2018-08-17 20:55:48'),
(33, 2, '2018-08-17 21:00:04'),
(34, 2, '2018-08-17 21:12:18'),
(35, 2, '2018-08-17 21:18:01'),
(36, 2, '2018-08-17 21:19:12'),
(37, 2, '2018-08-17 21:20:20'),
(38, 2, '2018-08-17 21:22:22'),
(39, 2, '2018-08-17 21:30:05'),
(40, 2, '2018-08-17 21:31:33'),
(41, 2, '2018-08-17 21:32:55'),
(42, 2, '2018-08-17 21:33:44'),
(43, 2, '2018-08-17 21:45:05'),
(44, 2, '2018-08-17 22:09:13'),
(45, 2, '2018-08-18 01:43:44'),
(46, 2, '2018-08-18 12:33:50'),
(47, 2, '2018-08-18 12:50:46'),
(48, 2, '2018-08-18 12:58:03'),
(49, 2, '2018-08-18 13:56:25'),
(50, 2, '2018-08-18 14:04:25'),
(51, 2, '2018-08-18 14:05:59'),
(52, 2, '2018-08-18 14:12:31'),
(53, 2, '2018-08-18 14:17:13'),
(54, 2, '2018-08-18 14:26:57'),
(55, 2, '2018-08-18 14:32:57'),
(56, 2, '2018-08-18 14:36:07'),
(57, 2, '2018-08-18 14:47:22'),
(58, 2, '2018-08-18 14:51:33'),
(59, 2, '2018-08-18 14:55:20'),
(60, 2, '2018-08-18 14:57:25'),
(61, 2, '2018-08-18 15:06:56'),
(62, 2, '2018-08-18 15:49:00'),
(63, 2, '2018-08-18 16:55:27'),
(64, 2, '2018-08-18 16:56:01'),
(65, 2, '2018-08-18 16:56:41'),
(66, 2, '2018-08-18 16:59:20'),
(67, 2, '2018-08-18 17:03:49'),
(68, 2, '2018-08-18 17:07:21'),
(69, 2, '2018-08-18 17:18:46'),
(70, 2, '2018-08-18 17:22:30'),
(71, 2, '2018-08-18 17:23:52'),
(72, 2, '2018-08-18 17:25:02'),
(73, 2, '2018-08-18 17:26:13'),
(74, 2, '2018-08-18 17:28:01'),
(75, 2, '2018-08-18 17:30:43'),
(76, 2, '2018-08-18 17:32:30'),
(77, 2, '2018-08-18 17:33:45'),
(78, 2, '2018-08-18 17:36:45'),
(79, 2, '2018-08-18 17:38:14'),
(80, 2, '2018-08-18 17:40:43'),
(81, 2, '2018-08-18 17:44:46'),
(82, 2, '2018-08-18 17:46:27'),
(83, 2, '2018-08-18 17:47:36'),
(84, 2, '2018-08-18 17:48:50'),
(85, 2, '2018-08-18 17:50:06'),
(86, 2, '2018-08-18 17:51:05'),
(87, 2, '2018-08-18 17:51:56'),
(88, 2, '2018-08-18 17:54:19'),
(89, 2, '2018-08-18 17:55:42'),
(90, 2, '2018-08-18 17:58:24'),
(91, 2, '2018-08-18 18:00:39'),
(92, 2, '2018-08-18 18:02:38'),
(93, 2, '2018-08-18 18:07:07'),
(94, 2, '2018-08-18 18:17:28'),
(95, 2, '2018-08-18 18:18:59'),
(96, 2, '2018-08-18 18:20:33'),
(97, 2, '2018-08-18 18:21:11'),
(98, 2, '2018-08-18 18:32:36'),
(99, 2, '2018-08-18 19:11:35'),
(100, 2, '2018-08-18 19:13:46'),
(101, 2, '2018-08-18 19:15:58'),
(102, 2, '2018-08-18 19:18:03'),
(103, 2, '2018-08-18 19:26:10'),
(104, 2, '2018-08-18 19:30:09'),
(105, 2, '2018-08-18 19:34:31'),
(106, 2, '2018-08-18 19:45:08'),
(107, 2, '2018-08-18 19:47:52'),
(108, 2, '2018-08-18 20:02:35'),
(109, 2, '2018-08-18 20:03:01'),
(110, 2, '2018-08-18 20:04:06'),
(111, 2, '2018-08-19 10:42:35'),
(112, 2, '2018-08-19 10:46:03'),
(113, 2, '2018-08-19 10:51:59'),
(114, 2, '2018-08-19 10:53:50'),
(115, 2, '2018-08-19 10:59:05'),
(116, 2, '2018-08-19 12:54:09'),
(117, 2, '2018-08-20 00:20:14'),
(118, 2, '2018-08-20 01:01:30'),
(119, 2, '2018-08-20 03:06:25'),
(120, 2, '2018-08-20 19:09:33'),
(121, 2, '2018-08-20 19:21:00'),
(122, 2, '2018-08-20 19:22:13'),
(123, 2, '2018-08-20 19:22:26'),
(124, 2, '2018-08-20 19:46:17'),
(125, 2, '2018-08-20 20:08:40'),
(126, 2, '2018-08-20 20:11:09'),
(127, 2, '2018-08-20 20:13:32'),
(128, 2, '2018-08-20 20:15:35'),
(129, 2, '2018-08-20 21:22:39'),
(130, 2, '2018-08-21 17:11:39'),
(131, 2, '2018-08-21 18:02:56'),
(132, 2, '2018-08-21 18:05:01'),
(133, 2, '2018-08-21 18:10:45'),
(134, 2, '2018-08-21 18:12:10'),
(135, 2, '2018-08-21 18:14:02'),
(136, 2, '2018-08-21 18:24:37'),
(137, 2, '2018-08-21 18:28:20'),
(138, 2, '2018-08-21 18:30:02'),
(139, 2, '2018-08-23 21:06:45'),
(140, 2, '2018-08-23 21:09:35'),
(141, 2, '2018-08-23 21:10:01'),
(142, 2, '2018-08-23 21:24:31'),
(143, 2, '2018-08-23 21:25:29'),
(144, 2, '2018-08-23 21:25:50'),
(145, 2, '2018-08-23 21:27:29'),
(146, 2, '2018-08-23 21:28:58'),
(147, 2, '2018-08-23 21:29:57'),
(148, 2, '2018-08-23 21:30:18'),
(149, 2, '2018-08-23 21:34:15'),
(150, 2, '2018-08-23 21:38:20'),
(151, 2, '2018-08-23 21:39:26'),
(152, 2, '2018-08-23 21:39:45'),
(153, 2, '2018-08-23 21:43:21'),
(154, 2, '2018-08-23 21:52:11'),
(155, 2, '2018-08-23 22:08:25'),
(156, 2, '2018-08-23 22:08:40'),
(157, 2, '2018-08-23 22:09:36'),
(158, 2, '2018-08-23 22:14:46'),
(159, 2, '2018-08-23 22:17:58'),
(160, 2, '2018-08-24 00:00:10'),
(161, 2, '2018-08-24 00:24:45'),
(162, 2, '2018-08-24 00:27:25'),
(163, 2, '2018-08-24 00:27:38'),
(164, 2, '2018-08-24 00:28:08'),
(165, 2, '2018-08-24 00:29:45'),
(166, 2, '2018-08-24 00:31:58'),
(167, 2, '2018-08-24 00:32:36'),
(168, 2, '2018-08-24 00:32:55'),
(169, 2, '2018-08-24 00:35:05'),
(170, 2, '2018-08-24 00:37:26'),
(171, 2, '2018-08-24 00:39:25'),
(172, 2, '2018-08-24 01:16:42'),
(173, 2, '2018-08-24 01:22:19'),
(174, 2, '2018-08-24 01:27:19'),
(175, 2, '2018-08-24 01:35:23'),
(176, 2, '2018-08-24 01:43:24'),
(177, 2, '2018-08-24 01:49:39'),
(178, 2, '2018-08-24 01:50:28'),
(179, 2, '2018-08-24 01:50:56'),
(180, 2, '2018-08-24 01:54:44'),
(181, 2, '2018-08-24 02:04:40'),
(182, 2, '2018-08-24 02:09:09'),
(183, 2, '2018-08-24 02:10:04'),
(184, 2, '2018-08-24 02:11:00'),
(185, 2, '2018-08-24 02:13:06'),
(186, 2, '2018-08-24 02:16:27'),
(187, 2, '2018-08-24 02:17:08'),
(188, 2, '2018-08-24 02:23:18'),
(189, 2, '2018-08-24 02:24:18'),
(190, 2, '2018-08-24 02:29:12'),
(191, 2, '2018-08-24 02:31:31'),
(192, 2, '2018-08-24 02:35:14'),
(193, 2, '2018-08-24 02:36:43'),
(194, 2, '2018-08-24 02:56:33'),
(195, 2, '2018-08-24 03:24:23'),
(196, 2, '2018-08-24 03:24:56'),
(197, 2, '2018-08-24 09:53:25'),
(198, 2, '2018-08-24 10:07:41'),
(199, 2, '2018-08-24 10:08:04'),
(200, 2, '2018-08-24 10:08:32'),
(201, 2, '2018-08-24 10:08:32'),
(202, 2, '2018-08-24 10:08:32'),
(203, 2, '2018-08-24 10:10:43'),
(204, 2, '2018-08-24 10:13:46'),
(205, 2, '2018-08-24 10:14:41'),
(206, 2, '2018-08-24 10:16:31'),
(207, 2, '2018-08-24 10:18:21'),
(208, 2, '2018-08-24 10:20:40'),
(209, 2, '2018-08-24 10:25:35'),
(210, 2, '2018-08-24 10:38:34'),
(211, 2, '2018-08-24 10:39:05'),
(212, 2, '2018-08-24 10:58:12'),
(213, 2, '2018-08-24 10:58:52'),
(214, 2, '2018-08-24 10:59:53'),
(215, 2, '2018-08-24 11:02:40'),
(216, 2, '2018-08-24 11:03:09'),
(217, 2, '2018-08-24 11:04:37'),
(218, 2, '2018-08-24 11:07:34'),
(219, 2, '2018-08-24 11:09:57'),
(220, 2, '2018-08-24 11:10:58'),
(221, 2, '2018-08-24 11:11:56'),
(222, 2, '2018-08-24 11:14:11'),
(223, 2, '2018-08-24 11:16:51'),
(224, 2, '2018-08-24 11:17:41'),
(225, 2, '2018-08-24 11:19:11'),
(226, 2, '2018-08-24 11:21:38'),
(227, 2, '2018-08-24 11:29:45'),
(228, 2, '2018-08-24 11:38:06'),
(229, 2, '2018-08-24 11:40:42'),
(230, 2, '2018-08-24 11:42:41'),
(231, 2, '2018-08-24 11:44:12'),
(232, 2, '2018-08-24 11:51:02'),
(233, 2, '2018-08-24 11:54:02'),
(234, 2, '2018-08-24 11:56:53'),
(235, 2, '2018-08-24 11:57:40'),
(236, 2, '2018-08-24 12:22:06'),
(237, 2, '2018-08-24 12:29:04'),
(238, 2, '2018-08-24 12:33:38'),
(239, 2, '2018-08-24 12:33:38'),
(240, 2, '2018-08-24 12:36:28'),
(241, 2, '2018-08-24 12:37:39'),
(242, 2, '2018-08-24 12:38:46'),
(243, 2, '2018-08-24 12:40:09'),
(244, 2, '2018-08-24 12:47:09'),
(245, 2, '2018-08-24 12:47:42'),
(246, 2, '2018-08-24 12:50:15'),
(247, 2, '2018-08-24 13:02:31'),
(248, 2, '2018-08-24 13:22:40'),
(249, 2, '2018-08-24 14:07:48'),
(250, 1, '2018-08-24 14:08:01'),
(251, 2, '2018-08-24 14:08:48'),
(252, 2, '2018-08-24 14:09:13'),
(253, 4, '2018-08-24 14:09:51'),
(254, 4, '2018-08-24 14:10:56'),
(255, 2, '2018-08-24 14:13:41'),
(256, 2, '2018-08-24 14:21:15'),
(257, 2, '2018-08-24 14:33:58'),
(258, 2, '2018-08-24 14:34:45'),
(259, 2, '2018-08-24 15:11:58'),
(260, 2, '2018-08-24 15:20:42'),
(261, 2, '2018-08-24 15:22:10'),
(262, 2, '2018-08-24 15:24:32'),
(263, 2, '2018-08-24 15:25:55'),
(264, 2, '2018-08-24 15:28:26'),
(265, 2, '2018-08-24 15:29:09'),
(266, 2, '2018-08-24 15:29:56'),
(267, 2, '2018-08-24 15:31:10'),
(268, 2, '2018-08-24 15:42:40'),
(269, 2, '2018-08-24 15:57:28'),
(270, 2, '2018-08-24 15:58:04'),
(271, 2, '2018-08-24 16:04:39'),
(272, 2, '2018-08-24 16:06:08'),
(273, 2, '2018-08-24 16:15:17'),
(274, 2, '2018-08-24 16:23:31'),
(275, 2, '2018-08-24 16:23:39'),
(276, 2, '2018-08-24 16:35:15'),
(277, 2, '2018-08-24 16:39:41'),
(278, 2, '2018-08-24 16:44:02'),
(279, 2, '2018-08-24 16:47:25'),
(280, 2, '2018-08-24 16:49:59'),
(281, 2, '2018-08-24 16:56:04'),
(282, 2, '2018-08-24 16:58:56'),
(283, 2, '2018-08-24 16:59:49'),
(284, 2, '2018-08-24 17:55:38'),
(285, 2, '2018-08-24 17:56:38'),
(286, 2, '2018-08-24 17:59:11'),
(287, 2, '2018-08-24 18:01:44'),
(288, 2, '2018-08-24 18:05:56'),
(289, 2, '2018-08-24 18:10:46'),
(290, 2, '2018-08-24 18:23:27'),
(291, 2, '2018-08-24 18:30:52'),
(292, 2, '2018-08-24 18:33:00'),
(293, 12, '2018-08-24 18:33:43'),
(294, 2, '2018-08-24 18:35:07'),
(295, 2, '2018-08-24 19:02:34'),
(296, 2, '2018-08-24 19:03:21'),
(297, 2, '2018-08-24 19:05:20'),
(298, 2, '2018-08-24 19:07:05'),
(299, 2, '2018-08-24 19:08:02'),
(300, 2, '2018-08-24 19:09:38'),
(301, 2, '2018-08-24 19:10:39'),
(302, 2, '2018-08-24 19:23:42'),
(303, 2, '2018-08-24 19:25:31'),
(304, 2, '2018-08-24 19:26:37'),
(305, 2, '2018-08-24 19:35:38'),
(306, 2, '2018-08-24 21:20:47'),
(307, 2, '2018-08-24 21:43:56'),
(308, 2, '2018-08-24 21:58:21'),
(309, 2, '2018-08-24 21:59:44'),
(310, 2, '2018-08-24 22:01:42'),
(311, 2, '2018-08-24 22:04:27'),
(312, 2, '2018-08-24 22:07:11'),
(313, 2, '2018-08-24 22:14:07'),
(314, 2, '2018-08-24 22:14:45'),
(315, 2, '2018-08-24 22:17:26'),
(316, 2, '2018-08-24 22:19:06'),
(317, 2, '2018-08-24 22:25:27'),
(318, 2, '2018-08-24 22:33:08'),
(319, 2, '2018-08-24 22:54:00'),
(320, 2, '2018-08-24 22:55:10'),
(321, 2, '2018-08-24 22:56:16'),
(322, 2, '2018-08-24 22:56:55'),
(323, 2, '2018-08-24 23:14:14'),
(324, 2, '2018-08-24 23:21:17'),
(325, 2, '2018-08-24 23:23:34'),
(326, 2, '2018-08-24 23:32:39'),
(327, 2, '2018-08-24 23:34:09'),
(328, 2, '2018-08-24 23:34:15'),
(329, 1, '2018-08-24 23:40:41'),
(330, 1, '2018-08-24 23:57:17'),
(331, 1, '2018-08-24 23:57:50'),
(332, 1, '2018-08-24 23:59:43'),
(333, 1, '2018-08-25 00:01:16'),
(334, 1, '2018-08-25 00:02:22'),
(335, 2, '2018-08-25 00:03:59'),
(336, 1, '2018-08-25 00:05:39'),
(337, 1, '2018-08-25 00:07:14'),
(338, 1, '2018-08-25 00:07:37'),
(339, 1, '2018-08-25 00:09:43'),
(340, 1, '2018-08-25 00:16:51'),
(341, 1, '2018-08-25 00:25:42'),
(342, 1, '2018-08-25 00:26:43'),
(343, 1, '2018-08-25 00:27:27'),
(344, 1, '2018-08-25 00:28:18'),
(345, 1, '2018-08-25 00:29:48'),
(346, 1, '2018-08-25 00:30:34'),
(347, 1, '2018-08-25 00:31:34'),
(348, 1, '2018-08-25 00:34:41'),
(349, 1, '2018-08-25 00:38:02'),
(350, 1, '2018-08-25 00:43:06'),
(351, 1, '2018-08-25 00:50:10'),
(352, 1, '2018-08-25 00:59:17'),
(353, 2, '2018-08-25 00:59:22'),
(354, 1, '2018-08-25 01:00:07'),
(355, 1, '2018-08-25 01:00:51'),
(356, 2, '2018-08-25 01:03:16'),
(357, 2, '2018-08-25 01:06:32'),
(358, 2, '2018-08-25 02:23:19'),
(359, 2, '2018-08-25 02:33:27'),
(360, 2, '2018-08-25 02:34:02'),
(361, 2, '2018-08-25 02:35:38'),
(362, 2, '2018-08-25 10:52:01'),
(363, 2, '2018-08-25 10:53:34'),
(364, 1, '2018-08-25 11:06:21'),
(365, 1, '2018-08-25 11:07:43'),
(366, 2, '2018-08-25 11:11:35'),
(367, 2, '2018-08-25 11:14:17'),
(368, 2, '2018-08-25 11:26:32'),
(369, 1, '2018-08-25 11:40:02'),
(370, 1, '2018-08-25 11:40:44'),
(371, 2, '2018-08-25 11:42:03'),
(372, 2, '2018-08-25 11:42:32'),
(373, 1, '2018-08-25 11:43:14'),
(374, 2, '2018-08-25 11:49:21'),
(375, 2, '2018-08-25 11:55:45'),
(376, 2, '2018-08-25 12:02:35'),
(377, 2, '2018-08-25 12:05:28'),
(378, 2, '2018-08-25 12:06:28'),
(379, 2, '2018-08-25 12:07:45'),
(380, 2, '2018-08-25 12:10:51'),
(381, 2, '2018-08-25 12:14:44'),
(382, 2, '2018-08-25 12:15:05'),
(383, 2, '2018-08-25 12:20:28'),
(384, 2, '2018-08-25 12:30:45'),
(385, 2, '2018-08-25 12:32:11'),
(386, 2, '2018-08-25 12:32:32'),
(387, 2, '2018-08-25 12:33:45'),
(388, 2, '2018-08-25 12:37:57'),
(389, 2, '2018-08-25 12:44:32'),
(390, 2, '2018-08-25 13:20:16'),
(391, 2, '2018-08-25 14:01:32'),
(392, 2, '2018-08-25 14:24:32'),
(393, 2, '2018-08-25 14:34:06'),
(394, 2, '2018-08-25 15:04:28'),
(395, 2, '2018-08-25 15:06:58'),
(396, 2, '2018-08-25 15:09:56'),
(397, 2, '2018-08-25 15:14:22'),
(398, 2, '2018-08-25 15:15:57'),
(399, 2, '2018-08-25 15:20:25'),
(400, 2, '2018-08-25 15:23:29'),
(401, 2, '2018-08-25 15:24:04'),
(402, 2, '2018-08-25 15:25:12'),
(403, 2, '2018-08-25 15:31:09'),
(404, 2, '2018-08-25 15:37:30'),
(405, 2, '2018-08-25 15:51:20'),
(406, 2, '2018-08-25 15:53:49'),
(407, 2, '2018-08-25 15:55:06'),
(408, 2, '2018-08-25 16:02:04'),
(409, 2, '2018-08-25 16:02:34'),
(410, 2, '2018-08-25 16:04:09'),
(411, 4, '2018-08-25 16:05:15'),
(412, 4, '2018-08-25 16:08:59'),
(413, 2, '2018-08-25 16:09:54'),
(414, 3, '2018-08-25 16:10:59'),
(415, 3, '2018-08-25 16:12:08'),
(416, 13, '2018-08-25 16:19:04'),
(417, 2, '2018-08-25 16:30:45'),
(418, 2, '2018-08-25 16:50:08'),
(419, 3, '2018-08-25 16:50:47'),
(420, 3, '2018-08-25 16:58:36'),
(421, 3, '2018-08-25 18:05:56'),
(422, 13, '2018-08-25 18:10:10'),
(423, 2, '2018-08-25 18:17:37'),
(424, 15, '2018-08-25 20:35:19'),
(425, 16, '2018-08-25 20:39:39'),
(426, 18, '2018-08-25 20:50:52'),
(427, 19, '2018-08-25 20:55:04'),
(428, 20, '2018-08-25 21:00:01'),
(429, 17, '2018-08-25 21:07:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_archivo`
--

CREATE TABLE IF NOT EXISTS `tbl_archivo` (
`codigo_archivo` int(11) NOT NULL,
  `codigo_usuario` int(11) NOT NULL,
  `nombre_archivo` varchar(100) NOT NULL,
  `fecha_creacion` datetime NOT NULL,
  `codigo_carpeta_padre` int(11) DEFAULT NULL,
  `tipo_archivo` varchar(10) DEFAULT NULL,
  `url_archivo` varchar(200) NOT NULL,
  `contenido` mediumtext,
  `estado` int(11) DEFAULT NULL,
  `extension` varchar(45) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_archivo`
--

INSERT INTO `tbl_archivo` (`codigo_archivo`, `codigo_usuario`, `nombre_archivo`, `fecha_creacion`, `codigo_carpeta_padre`, `tipo_archivo`, `url_archivo`, `contenido`, `estado`, `extension`) VALUES
(41, 2, 'Gato', '2018-08-18 18:14:33', NULL, 'carpeta', '', NULL, 1, NULL),
(42, 2, 'Gatosss', '2018-08-18 18:18:00', NULL, 'carpeta', '', NULL, 2, NULL),
(43, 2, 'Gatitos', '0000-00-00 00:00:00', NULL, 'null', '', 'null', 2, NULL),
(44, 2, 'Gatos', '2018-08-18 18:19:26', NULL, 'carpeta', '', NULL, 1, NULL),
(45, 2, 'Cerebro', '2018-08-18 18:20:40', NULL, 'carpeta', '', NULL, 1, NULL),
(46, 2, 'Nueva Carpeta 1', '2018-08-18 18:21:23', NULL, 'carpeta', '', NULL, 1, NULL),
(47, 2, 'Toshimi', '2018-08-18 18:21:32', NULL, 'carpeta', '', NULL, 1, NULL),
(48, 2, 'Kyoukiko', '2018-08-18 19:35:24', NULL, 'carpeta', '', NULL, 1, NULL),
(49, 2, 'Nuevzxczccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccca Carpeta', '2018-08-20 19:22:57', NULL, 'carpeta', '', NULL, NULL, NULL),
(50, 2, 'null', '0000-00-00 00:00:00', NULL, 'null', '', 'null', 2, NULL),
(51, 2, 'Gatos 2', '2018-08-23 21:38:55', 46, 'carpeta', '', NULL, 1, NULL),
(52, 2, 'Loca', '2018-08-23 21:39:39', 48, 'carpeta', '', NULL, 2, NULL),
(53, 2, 'Kyokiko', '2018-08-23 22:44:34', 52, 'carpeta', '', NULL, 1, NULL),
(54, 2, 'Codigo 1', '2018-08-24 01:29:51', NULL, 'documento', '', NULL, 2, NULL),
(55, 2, 'Shizuko', '2018-08-24 11:29:56', NULL, 'carpeta', '', NULL, 1, NULL),
(56, 2, 'null', '0000-00-00 00:00:00', NULL, 'null', '', 'null', 2, NULL),
(57, 2, 'Mihaly', '2018-08-24 11:54:44', NULL, 'carpeta', '', NULL, 1, NULL),
(58, 2, 'Hola', '2018-08-24 11:55:32', 57, 'documento', '', NULL, 1, NULL),
(59, 2, 'main.css', '2018-08-24 11:57:02', NULL, 'documento', '', '\n\n/*///////////////Etiquetas/////////////*/\n\nbody{\n	color:#FFF;\n	background-color: #272A2F;\n	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;\n	font-size: 100%;\n}\n\ninput[type="password"],input[type="email"],input[type="text"]{\n	border: none;\n	border-bottom: solid;\n	border-color: #a8518a;\n	background-color: transparent!important;\n	color: #b9b4bb;\n	border-radius: 2px;\n	font-size: 1.2em;\n	width:100%;\n	margin-top: 5px;\n	padding: 1px 15px;\n}\n#home-planes ul,li {\n    list-style-type: circle;\n    margin: auto;\n    padding: 5px;\n    display: inline-block; \n    text-align: left; \n}\na{\n	text-decoration: none!important;\n	color:#b9b4bb;\n}\na:hover{\n	color: #8e4b77;\n\n}\nhtml, body {\n  height: 100%;\n  width:100%;\n}\nimg {\n    max-width: 100%;\n    height: auto;\n}\nhr{\n  border-width: 3px;\n  border-color: #b9b4bb;\n}\nli a{\n	text-decoration: none;\n}\n\n/*//////////////////////////////////////*/\n\n/*/////////////Clases///////////////////*/\n.grey-background{\n	background-color:#888587;\n}\n.input-search{\n	background-color: #84848470!important;\n	border:none !important;\n	width: 164px !important;\n\n}\n.modal-black{\n	background-color: #121213!important;\n\n}\n\n.text-body{\n	color:#FFF;\n}\n.center {\n    display: block;\n    margin-left: auto;\n    margin-right: auto;\n    width: 100%;\n}\n\n.background-body{\n    background-image: url(../img/code-background.jpg);\n    background-repeat: no-repeat;\n    background-position: center center;\n    background-attachment: fixed;\n    background-size: cover;\n\n}\n.flex-container{\n  display: flex;\n}\n.cotainer-center{\n    display: flex;\n  	align-items: center;\n  	justify-content: center;\n}\n\n.container-space-between{\n	display: flex;\n	justify-content: space-between;\n	padding-bottom:10px;\n}\n.div-titulos {\n	background-color:#242424fc;\n	font-weight: 600;\n	font-size:2.7em;\n	width: 100%;\n	height:70px;\n	font-family: ''Lato'', sans-serif;\n\n\n}\n.archivo{\n	border-radius: 6px;\n	background-color: #121213;\n    margin: 5px;\n    height: 150px;\n    width: 148px;\n    justify-content:center;\n\n\n}\n\n.ellipsis { \n	text-overflow: ellipsis; \n}\n.archivo i{\n	margin: 10px;\n	font-size: 6em;\n}\n\n.archivo div{\n	display: block;\n    background-color: #393b3e;\n    padding: 5px;\n    border-radius: 0px 0px 6px 6px;\n    max-height: 34px;\n    overflow: hidden;\n    white-space: nowrap;\n    text-overflow: ellipsis;\n    text-align: center;\n}\n\n.flex-wrap{\n	display: flex;\n	flex-wrap: wrap;\n	flex-flow: row wrap;\n}\n.flex-row{\n	 flex-flow: row wrap;\n}\n.flex-container-r{\n	display: flex;\n}\n.brand{\n	color: #FFF;\n	position: fixed; \n    z-index: 1; \n  	top: 0px;\n    left: 0;\n}\n.brand a{\n	color: #FFF !important;\n}\n.brand a:hover{\n	color: #FFF;\n}\n\n.flex-col{\n  flex: 1;\n}\n@media (max-width: 768px) {\n  .flex-container {\n    display: block;\n  }\n  .grey-squares{\n	margin: 40px;\n}\n}\n.grey-squares{\n	background-color: #3f403feb;\n	box-sizing: border-box;\n	min-height: 80px;\n	margin: 20px;\n	flex-wrap: wrap;\n  	min-height: 500px;\n  	font-size: 1em;\n  	font-family: ''Lato'', sans-serif;\n  	padding: 15px;\n  	align-items: center;\n    justify-content: center;\n    display: -ms-flexbox;\n	display: -webkit-flex;\n	display: flex;\n\n	-ms-flex-align: center;\n	-webkit-align-items: center;\n	-webkit-box-align: center;\n	-moz-box-align:center;\n	-ms-box-align:center;\n\n}\n\n.sidenav {\n    height: 90%; \n  	top: 64px;\n    left: 0;\n    background-color: #111;\n    width:90px;\n    \n}\n\n\n.sidenav a {\n    padding: 6px 8px 6px 16px;\n    text-decoration: none;\n    font-size: 25px;\n    color: rgba(226, 117, 189, .6);\n    display: block;\n\n}\n\n.sidenav a:hover {\n    color: #FFF;\n}\n\n.archivos{\n	width:20%;\n	width:108px;\n	font-size: .7em;\n}\n\n.archivos i{\n	margin-bottom: 5px;\n	font-size: 6em;\n}\n/*@media (max-width: @screen-xs-max) { \n	// < 768px (xsmall phone) \n	@media (max-width: @screen-sm-max) { \n		// < 992px (small tablet) \n		@media (max-width: @screen-md-max) \n		{ // < 1200px (medium laptop)*/\n@media screen and (max-width: 768px) {\n    \n	.main {\n    	margin: 5px; \n    	font-size: 28px; \n    	padding: 10px;\n    	display:block;\n	}\n	.archivos{\n	min-width:100%\n	font-size: 1em;\n	display:block;\n	margin: auto;\n	}\n	.archivos i{\n	margin-bottom: 5px;\n	font-size: 10em;\n	}\n\n}\n.profile-box{\n	background-color: #94808d;\n	box-sizing: border-box;\n	padding: 8px;\n	margin: auto;\n	flex: 1; \n	align-items: center;\n  justify-content: center;\n\n}\n.shadow-textarea textarea.form-control::placeholder {\n    font-weight: 300;\n}\n.shadow-textarea textarea.form-control {\n    padding-left: 0.8rem;\n}\n#input-modal-perfil{\n	padding: 15px;\n}\n#input-modal-perfil input[type="password"], input[type="email"], input[type="text"]{\n	padding: 5px;\n	background-color: #2d282b!important;\n	margin-bottom: 4px;\n}\n.profile-box i{\n	font-size: 10em;\n	margin: auto;\n}\n.custom-menu {\n    display: none;\n    z-index: 1000;\n    position: absolute;\n    overflow: hidden;\n    border: 1px solid #CCC;\n    white-space: nowrap;\n    font-family: sans-serif;\n    background: #FFF;\n    color: #333;\n    border-radius: 5px;\n    padding: 0;\n}\n.close{\n	color: #da038e;\n}\n.close :hover{\n	color: #da038e;\n}\n.modal-content {\n    background-color: #121213!important;\n}\n/*Context Menu*/\n.custom-menu li {\n    padding: 8px 12px;\n    cursor: pointer;\n    list-style-type: none;\n    transition: all .3s ease;\n    user-select: none;\n    background: #ded7d7;\n    display: block;\n}\n.custom-menu{\n	background: #ded7d7;\n}\n\n.custom-menu li:hover {\n    background-color: #e4c2d9;\n}\n\n\n/*//////////////////////////////////////*/\n\n/*//////Redifinicion clases Bootstrap/////*/\n.table .thead-dark th {\n    background-color: #401e35;\n}\n.bg-dark{\n	background-color: #121213!important;\n}\n.modal-header {\n    background-color:#121213!important;\n }\n .modal-content{\n 	background-color:#121213!important;\n }\n.form-control:focus {\n    border-color: #e6b6d5;\n}\n.navbar-dark .navbar-nav .nav-link {\n    color: rgba(226, 117, 189, .6);\n}\n.dropdown-menu{\n	background-color: #121213de;\n	\n}\n.navbar {\n    width: 100;\n}\n.dropright .dropdown-menu {\n\n    right: auto;\n    left: 0; \n    background-color: #020202;\n    margin-top: 0;\n    margin-left: .125rem;\n    min-width: 17rem;\n}\n/*//////////////////////////////////////*/\n#fondo-contenedor{\n	height: 90%; \n    position: fixed; \n    z-index: 1; \n  	top: 64px;\n    left: 92px;\n    padding: 15px;\n    background-color: #888587;\n     overflow-y:auto;\n}\n#pantalla{\n	width: 100%;\n	height:90%;\n    position: fixed; \n    z-index: 1; \n  	top: 64px;\n    padding: 15px;\n    background-color: #888587;\n    overflow-y:auto;\n    overflow-x:auto;\n}\n\n#contenedor-archivos{\n}\n/*//////////////Registro///////////*/\n\n#registro-formulario{\n	height:100%;\n	min-width: 320px;\n	background-color:#121213;\n	box-sizing: border-box;\n	padding: 40px;\n	padding-top: 35px;\n	align-self: center;\n}\n#registro-info {\n  flex-grow:1;\n   background-image: url(../img/code-background.jpg);\n   background-repeat: no-repeat;\n   background-position: center center;\n   background-attachment: fixed;\n   background-size: cover;\n}\n#registro-info img{\n	width: 70%;\n	height: auto;\n}\n/*///////////////////////////////*/\n#editor{\n	height:500px;\n	color: #FFF;\n    background-color:  #393c31;\n}\n#tbl-usuarios{\n    position: fixed; \n    z-index: 1; \n  	top: 64px;\n    padding: 15px;\n    height: 90%;\n    width:100%;\n}\n/*///////////////Home///////////*/\n\n#home-portada{\n    min-height:700px\n    width:100%;\n}\n#home-portada a{\n	color:#FFF;\n}\n\n#home-portada a:hover{\n	color:#FFF;\n	text-decoration: none;\n}\n#home-portada img{\n	width: 30%;\n	min-width: 250px;\n\n}\n#home-servicios{\n	min-height:700px;\n	background: #48173b80;\n	height:100%;\n	padding: 15px;\n\n}\n\n#home-planes{\n	min-height:700px;\n	background: #a8508961;;\n	/*background: rgba(6,182,115,0.5);*/\n	height:100%;\n	padding: 15px;\n}\n#home-aspectos{\n	min-height:700px;\n	background: #48173b80;\n	height:100%;\n	padding: 15px;\n}\n\n\n/*///////////////////////////////*/\n/*//////////////Login///////////*/\n\n#login{\n	background-color:#121213;\n	width: 400px;\n	padding: 40px;\n	max-height: 800px;\n	box-sizing: border-box;\n	margin: auto;\n	height:100%;\n}\n\n/*//////////////Checkbox///////////*/\n\n /*Personalizando el checkbox*/\n.check-label{\n  	color:#b9b4bb;\n  	position: relative;\n  	padding-left: 35px;\n  	margin-top: 15px;\n  	cursor: pointer;\n }\n /*Oculta el checkbox por default*/\n.check-label input {\n  position: absolute;\n  opacity: 0;\n}\n/*Personalizando la caja del check box*/\n.checkmark {\n  position: absolute;\n  top: 0;\n  left: 0;\n  height: 25px;\n  width: 25px;\n  background-color: #545557;\n  border-radius: 2px;\n}\n\n/* Hover del checkbox */\n.check-label:hover input ~ .checkmark {\n  background-color: #b9b4bb;\n}\n\n/* Cuando el checkbox es seleccionado */\n.check-label input:checked ~ .checkmark {\n  background-color: #b9b4bb;\n}\n\n/* Marca del Cheque*/\n.checkmark:after {\n  content: "";\n  position: absolute;\n  display: none;\n}\n\n/* Marca del cheque cuando es seleccionado*/\n.check-label input:checked ~ .checkmark:after {\n  display: block;\n}\n\n/* Personalizando la marca del cheque*/\n.check-label .checkmark:after {\n  left: 9px;\n  top: 5px;\n  width: 5px;\n  height: 10px;\n  border: solid #a8518a;\n  border-width: 0 3px 3px 0;\n  -webkit-transform: rotate(45deg);\n  -ms-transform: rotate(45deg);\n  transform: rotate(45deg);\n}\n/*//////////////////////////////////////*/\n\n/*//////////////Botones///////////////*/\n\n\n.btn-redes{\n	border-radius: 2px;\n	border: none;\n	width: 30%;\n	cursor: pointer;\n}\n\n.btn-form {\n	border:none;\n	background-color: #a8518a;\n	color:#FFF;\n	border-radius: 2px;\n    width:100%;\n    margin-top:25px;\n    width:100%;\n    cursor: pointer;\n    padding: 10px 6px;\n    font-size: 1.2em;\n}\n.btn-form:hover{\n	background-color: #8e4b77;\n}\n.btn-form a{\n	color: #FFF;\n}\n.btn-form a:hover{\n	color: #FFF;\n}\n.btn-large {\n	border:none;\n	background-color: #a8518a;\n	color:#FFF;\n	border-radius: 20px;\n    margin-top:25px;\n    width:25%;\n    cursor: pointer;\n    padding: 10px 6px;\n    font-size: 1.2em;\n    font-weight: 600;\n    min-width: 250px;\n\n\n}\n.btn-large:hover{\n	background-color: #8e4b77;\n}\n.btn-transparent{\n	background-color: transparent;\n	border: none;\n\n}\n.btn-round{\n	border-radius: 50%;\n	\n}\n/*//////////////////////////////////////*/\n\n/*///////////////Tablas///////////*/\n.table-borderless td,\n.table-borderless th {\n    border: 0;\n}\n/*//////////////////////////////////////*/', 1, NULL),
(60, 4, 'Registros', '2018-08-24 14:12:16', NULL, 'carpeta', '', NULL, 1, NULL),
(61, 2, 'Hikari', '2018-08-24 14:34:09', NULL, 'carpeta', '', NULL, 1, NULL),
(62, 2, 'Shinobu', '2018-08-24 14:34:55', NULL, 'carpeta', '', NULL, 1, NULL),
(63, 2, 'Nueva Carpeta', '2018-08-24 16:42:34', NULL, 'carpeta', '', NULL, 1, NULL),
(64, 2, 'Nuevo Documento', '2018-08-24 16:42:46', NULL, 'documento', '', NULL, 1, NULL),
(65, 2, 'Nuevo Documento', '2018-08-24 16:42:46', NULL, 'documento', '', NULL, 1, NULL),
(66, 2, 'Chagall', '2018-08-24 18:19:05', NULL, 'carpeta', '', NULL, 1, NULL),
(67, 2, 'controlador-editor.js', '2018-08-24 19:25:39', 41, 'documento', '', '$(document).ready(function(){\n	 cargarCodigo();\n});\n\nfunction cargarCodigo(){\n	$.ajax({\n            url:"/obtener-archivo",\n            method:"POST",\n            dataType:"json",\n            success:function(respuesta){\n            	$("#lb-nombre-archivo").html(respuesta.nombre_archivo);\n            	var editor= ace.edit("editor");\n            	var filename= respuesta.nombre_archivo;\n            	var modelist = ace.require("ace/ext/modelist")\n				var mode = modelist.getModeForPath(filename).mode;\n				editor.session.setMode(mode) ;// mode now contains "ace/mode/javascript".\n            	editor.setTheme("ace/theme/monokai");\n				editor.setValue(respuesta.contenido);\n\n            }\n        });\n}\n\n$("#btn-guardar").click(function(){\n    var editor = ace.edit("editor");\n\n	$.ajax({\n		url:"/guardar-archivo",\n		method:"POST",\n		data:parametros,\n		dataType:"json",\n		success:function(respuesta){\n			if (respuesta.affectedRows==1){\n				console.log(''Se guardo'');\n			}\n			console.log(respuesta);\n			\n		}\n	});\n});\n', 1, NULL),
(68, 2, 'hola_mundo.php', '2018-08-24 21:21:02', NULL, 'documento', '', NULL, 1, NULL),
(69, 2, 'eliminar_usuario.php', '2018-08-24 22:07:25', NULL, 'documento', '', NULL, 1, NULL),
(70, 2, 'eliminar.php', '2018-08-24 22:08:35', NULL, 'documento', '', NULL, 1, NULL),
(71, 2, 'null', '0000-00-00 00:00:00', NULL, 'null', '', '?jkjkjkj', 2, NULL),
(72, 2, 'null', '0000-00-00 00:00:00', NULL, 'null', '', '?jkjkjkj', 2, NULL),
(73, 2, 'editor.html', '2018-08-24 23:22:39', NULL, 'documento', '', '<!DOCTYPE html>\n<html lang="en">\n<head>\n  <title>Mihaly</title>\n  <meta charset="utf-8">\n  <link rel="stylesheet" href="css/bootstrap.min.css">\n  <link rel="stylesheet" href="css/main.css">\n  <link href="https://fonts.googleapis.com/css?family=Sriracha" rel="stylesheet">\n  <meta name="viewport" content="width=device-width, initial-scale=1">\n  <link rel="shorcut icon" href="img/LogoCatCode2.png">\n  <link rel="stylesheet" href="css/font-awesome/all.css" integrity="sha384-lKuwvrZot6UHsBSfcMvOkWwlCMgc0TaWr 30HWe3a4ltaBwTZhyTEggF5tJv8tbt" crossorigin="anonymous">\n</head>\n<body class="grey-background">\n<nav class="navbar fixed-top navbar-dark bg-dark">\n        <div class="float-left">\n        <a href="archivos.html" style= "font-family: ''Sriracha'', cursive;font-size:2em; color: white">Mihaly</a>\n        \n        <button class="btn btn-round btn-transparent" type="button" id="btn-guardar"title="Guardar">\n                <i style="color: rgba(226, 117, 189, .6); font-size: 1.6em;" class="fas fa-save"></i>\n        </button>\n        <button class="btn btn-round btn-transparent" type="button" title="Adelante">\n                <i style="color: rgba(226, 117, 189, .6);font-size: 1.6em;" class="fas fa-angle-right"></i>\n        </button>\n        <label id="lb-nombre-archivo" text=""><label>\n        <select class="form-control" id="lenguaje">\n            <option value="">C</option>\n            <option value="">C#</option>\n            <option value="">JavaScript</option>\n            <option value="">Java</option>\n            <option value="">PHP</option>\n            <option value="">HTML</option>\n            <option value="">CSS</option>\n            <option value="">Python</option>\n            <option value="">Ruby</option>\n        </select>\n    	</div>\n        <div class="float-right" id="" >\n         	<div class="dropdown dropdown dropleft">\n            	<button class="btn btn-round btn-transparent" type="button" data-toggle="dropdown">\n                <i style="color: rgba(226, 117, 189, .6);" class="fas fa-user"></i>\n            </button>\n            <ul class="dropdown-menu">\n                <li><a href="#modal-perfil" data-target="#modal-perfil" data-toggle="modal"><i class="fas fa-user"></i>  Perfil</a></li>\n                <div class="dropdown-divider"></div>\n                <li ><a id=''cerrar-sesion'' href=""><i class="fas fa-sign-out-alt"></i>  Cerrar Sesion</a></li> \n             </ul>\n            </div>   \n        </div>   \n    </nav>\n    <div id="pantalla">\n        <div class="form-group shadow-textarea">\n            <label id="tituloDocumento"></label>\n            <div class="form-control z-depth-1" id="editor" rows="25" placeholder="Empieza tu codigo...">\n                \n            </div>\n        </div>\n    </div>\n    <script src="js/jquery.min.js"></script>\n    <script src="js/bootstrap.min.js"></script>\n    <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.1/ace.js" type="text/javascript" charset="utf-8"></script>\n    <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.1/ext-modelist.js"></script>\n    <script src="js/controlador-editor.js" ></script>\n  </body>', 1, NULL),
(74, 2, 'SAG', '2018-08-25 11:32:01', NULL, 'carpeta', '', '//', 1, NULL),
(75, 3, 'Mihaly', '2018-08-25 16:51:00', NULL, 'carpeta', '', '//', 1, NULL),
(76, 3, 'Sprint 1', '2018-08-25 16:51:19', NULL, 'carpeta', '', '//', 1, NULL),
(77, 3, 'hola_mundo.php', '2018-08-25 16:51:32', NULL, 'documento', '', '//', 1, NULL),
(78, 3, 'img', '2018-08-25 16:51:46', 75, 'carpeta', '', '//', 1, NULL),
(79, 3, 'js', '2018-08-25 16:51:55', 75, 'carpeta', '', '//', 1, NULL),
(80, 3, 'editor.html', '2018-08-25 16:52:17', 75, 'carpeta', '', '//', 2, NULL),
(81, 3, 'editor.html', '2018-08-25 16:52:49', 75, 'documento', '', '//', 1, NULL),
(82, 3, 'main.css', '2018-08-25 16:53:06', 75, 'carpeta', '', '//', 1, NULL),
(83, 3, 'index.html', '2018-08-25 16:54:19', 75, 'documento', '', '//', 1, NULL),
(84, 3, 'hola_mundo.php', '2018-08-25 18:06:50', NULL, 'documento', '', '//', 1, NULL),
(85, 3, 'index.html', '2018-08-25 18:07:35', NULL, 'documento', '', '//', 1, NULL),
(86, 3, 'ejemplo.java', '2018-08-25 18:07:44', NULL, 'carpeta', '', '//', 2, NULL),
(87, 3, 'ejemplo.java', '2018-08-25 18:08:05', NULL, 'documento', '', '//', 1, NULL),
(88, 2, 'Nuevo Documento', '2018-08-25 18:18:30', 63, 'documento', '', '//', 1, NULL),
(89, 2, 'index.js', '2018-08-25 18:18:42', 63, 'documento', '', '//', 1, NULL),
(90, 16, 'Mihaly', '2018-08-25 20:39:48', NULL, 'carpeta', '', '//', 1, NULL),
(91, 16, 'r.php', '2018-08-25 20:45:18', NULL, 'documento', '', '//', 1, NULL),
(92, 18, 'Mihaly', '2018-08-25 20:50:59', NULL, 'carpeta', '', '//', 1, NULL),
(93, 18, 'main.css', '2018-08-25 20:51:08', 92, 'documento', '', '//', 1, NULL),
(94, 18, 'prueba.html', '2018-08-25 20:51:23', 92, 'documento', '', '//', 1, NULL),
(95, 20, 'Mihaly', '2018-08-25 21:00:12', NULL, 'carpeta', '', '//', 1, NULL),
(96, 20, 'main.css', '2018-08-25 21:00:22', 95, 'documento', '', '//', 1, NULL),
(97, 20, 'prueba.html', '2018-08-25 21:00:50', NULL, 'documento', '', '//', 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_archivos_compartidos`
--

CREATE TABLE IF NOT EXISTS `tbl_archivos_compartidos` (
  `codigo_archivo` int(11) NOT NULL,
  `codigo_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_archivos_compartidos`
--

INSERT INTO `tbl_archivos_compartidos` (`codigo_archivo`, `codigo_usuario`) VALUES
(41, 4),
(42, 1),
(45, 1),
(48, 1),
(49, 1),
(50, 1),
(52, 1),
(57, 1),
(60, 2),
(60, 4),
(97, 17);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_favoritos`
--

CREATE TABLE IF NOT EXISTS `tbl_favoritos` (
  `codigo_archivo` int(11) NOT NULL,
  `codigo_usuario` int(11) NOT NULL,
  `eliminar` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_favoritos`
--

INSERT INTO `tbl_favoritos` (`codigo_archivo`, `codigo_usuario`, `eliminar`) VALUES
(46, 2, NULL),
(48, 1, NULL),
(53, 2, NULL),
(75, 3, NULL),
(95, 20, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_planes`
--

CREATE TABLE IF NOT EXISTS `tbl_planes` (
`codigo_plan` int(11) NOT NULL,
  `nombre_plan` varchar(45) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `meses_vigencia` int(11) DEFAULT NULL,
  `precio` float NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_planes`
--

INSERT INTO `tbl_planes` (`codigo_plan`, `nombre_plan`, `capacidad`, `descripcion`, `meses_vigencia`, `precio`) VALUES
(1, 'Gratis', 15, '', 0, 0),
(2, 'Principiante', 25, NULL, NULL, 0),
(3, 'Experto', 0, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_registro_planes`
--

CREATE TABLE IF NOT EXISTS `tbl_registro_planes` (
  `codigo_registro` int(11) NOT NULL,
  `codigo_usuario` int(11) NOT NULL,
  `codigo_plan` int(11) NOT NULL,
  `fecha_adquisicion` date NOT NULL,
  `estado` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipos_usuarios`
--

CREATE TABLE IF NOT EXISTS `tbl_tipos_usuarios` (
`codigo_tipo_usuario` int(11) NOT NULL,
  `nombre_tipo_usuario` varchar(45) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_tipos_usuarios`
--

INSERT INTO `tbl_tipos_usuarios` (`codigo_tipo_usuario`, `nombre_tipo_usuario`) VALUES
(1, 'Administrador'),
(2, 'Normal');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_usuarios`
--

CREATE TABLE IF NOT EXISTS `tbl_usuarios` (
`codigo_usuario` int(11) NOT NULL,
  `codigo_tipo_usuario` int(11) NOT NULL,
  `codigo_plan` int(11) NOT NULL,
  `usuario` varchar(45) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `clave` varchar(45) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `imagen_perfil_url` varchar(100) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_usuarios`
--

INSERT INTO `tbl_usuarios` (`codigo_usuario`, `codigo_tipo_usuario`, `codigo_plan`, `usuario`, `correo`, `clave`, `fecha_registro`, `imagen_perfil_url`) VALUES
(1, 1, 3, 'alanocturna', 'ricardo_tapia@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-16 00:00:00', 'null'),
(2, 2, 3, 'cat', 'selenadiaz@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-16 01:56:14', 'null'),
(3, 2, 3, 'spm', 'pedro_marquez@gmail.com', 'f10e2821bbbea527ea02200352313bc059445190', '2018-08-16 02:20:15', 'null'),
(4, 2, 2, 'tornado_rojo', 'juan_perez@gmail.com', 'f10e2821bbbea527ea02200352313bc059445190', '2018-08-16 02:24:43', 'null'),
(6, 2, 1, 'antorcha', 'juan_sanchez@gmail.com', 'f10e2821bbbea527ea02200352313bc059445190', '2018-08-16 02:38:57', NULL),
(7, 2, 1, 'canario_negro', 'diana_rios@gmail.com', 'f10e2821bbbea527ea02200352313bc059445190', '2018-08-17 02:49:48', NULL),
(9, 2, 1, 'canario_negro', 'diana_rios1@gmail.com', 'f10e2821bbbea527ea02200352313bc059445190', '2018-08-17 02:53:57', NULL),
(10, 2, 1, 'canario_negro', 'diana_rios@gmail.com', 'f10e2821bbbea527ea02200352313bc059445190', '2018-08-17 02:54:42', NULL),
(11, 2, 1, 'invisible', 'susana_sanchez@gmail.com', 'f64e51176bcbbe11500bfa2495daee3386ba9996', '2018-08-17 03:45:06', NULL),
(12, 2, 1, 'Cat', 'selenadiaz@gmail.com', '293662475dbe4235a50a011325b9e878194dfcca', '2018-08-24 18:33:30', NULL),
(13, 2, 1, 'px_', 'carlos_xavier@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 16:18:46', NULL),
(14, 2, 1, 'batw', 'barbarafierro@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:32:14', NULL),
(15, 2, 1, 'batw', 'barbara_fierro@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:35:03', NULL),
(16, 2, 1, 'cat', 'selena_diaz@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:39:24', NULL),
(17, 2, 1, 'andrea', 'am16@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:49:45', NULL),
(18, 2, 1, 'am16', 'amm16@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:50:32', NULL),
(19, 2, 1, 'am16', 'am@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:54:52', NULL),
(20, 2, 1, 'am16', 'amm@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 20:59:36', NULL),
(21, 2, 1, 'am16', 'ammg@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 21:10:29', NULL),
(22, 2, 1, 'am16', 'ammg16@gmail.com', '7648ce31553ba4190124ef4a0ddac5bcd538ff52', '2018-08-25 21:12:58', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbl-usuarios`
--
ALTER TABLE `tbl-usuarios`
 ADD PRIMARY KEY (`codigo-usuario`);

--
-- Indices de la tabla `tbl_accesos`
--
ALTER TABLE `tbl_accesos`
 ADD PRIMARY KEY (`codigo_acceso`), ADD KEY `fk_tbl_accesos_tbl_usuarios1` (`codigo_usuario`);

--
-- Indices de la tabla `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
 ADD PRIMARY KEY (`codigo_archivo`), ADD KEY `fk_tbl_archivo_tbl_archivo1_idx` (`codigo_carpeta_padre`), ADD KEY `fk_tbl_archivo_tbl_usuarios1_idx` (`codigo_usuario`);

--
-- Indices de la tabla `tbl_archivos_compartidos`
--
ALTER TABLE `tbl_archivos_compartidos`
 ADD PRIMARY KEY (`codigo_archivo`,`codigo_usuario`), ADD KEY `fk_tbl_compartir_tbl_archivo1_idx` (`codigo_archivo`), ADD KEY `fk_tbl_compartir_tbl_usuarios1_idx` (`codigo_usuario`);

--
-- Indices de la tabla `tbl_favoritos`
--
ALTER TABLE `tbl_favoritos`
 ADD PRIMARY KEY (`codigo_archivo`,`codigo_usuario`), ADD KEY `fk_tbl_favoritos_tbl_usuarios1_idx` (`codigo_usuario`);

--
-- Indices de la tabla `tbl_planes`
--
ALTER TABLE `tbl_planes`
 ADD PRIMARY KEY (`codigo_plan`);

--
-- Indices de la tabla `tbl_registro_planes`
--
ALTER TABLE `tbl_registro_planes`
 ADD PRIMARY KEY (`codigo_registro`), ADD KEY `fk_tbl_registro_planes_tbl_usuarios1_idx` (`codigo_usuario`), ADD KEY `fk_tbl_registro_planes_tbl_planes1_idx` (`codigo_plan`);

--
-- Indices de la tabla `tbl_tipos_usuarios`
--
ALTER TABLE `tbl_tipos_usuarios`
 ADD PRIMARY KEY (`codigo_tipo_usuario`);

--
-- Indices de la tabla `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
 ADD PRIMARY KEY (`codigo_usuario`), ADD KEY `fk_tbl_usuarios_tbl_planes1_idx` (`codigo_plan`), ADD KEY `fk_tbl_usuarios_tbl_tipos_usuarios1_idx` (`codigo_tipo_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tbl_accesos`
--
ALTER TABLE `tbl_accesos`
MODIFY `codigo_acceso` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=430;
--
-- AUTO_INCREMENT de la tabla `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
MODIFY `codigo_archivo` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=98;
--
-- AUTO_INCREMENT de la tabla `tbl_planes`
--
ALTER TABLE `tbl_planes`
MODIFY `codigo_plan` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `tbl_tipos_usuarios`
--
ALTER TABLE `tbl_tipos_usuarios`
MODIFY `codigo_tipo_usuario` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
MODIFY `codigo_usuario` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=23;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_accesos`
--
ALTER TABLE `tbl_accesos`
ADD CONSTRAINT `fk_tbl_accesos_tbl_usuarios1` FOREIGN KEY (`codigo_usuario`) REFERENCES `tbl_usuarios` (`codigo_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
ADD CONSTRAINT `fk_tbl_archivo_tbl_archivo1` FOREIGN KEY (`codigo_carpeta_padre`) REFERENCES `tbl_archivo` (`codigo_archivo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_tbl_archivo_tbl_usuarios1` FOREIGN KEY (`codigo_usuario`) REFERENCES `tbl_usuarios` (`codigo_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_archivos_compartidos`
--
ALTER TABLE `tbl_archivos_compartidos`
ADD CONSTRAINT `fk_tbl_compartir_tbl_archivo1` FOREIGN KEY (`codigo_archivo`) REFERENCES `tbl_archivo` (`codigo_archivo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_tbl_compartir_tbl_usuarios1` FOREIGN KEY (`codigo_usuario`) REFERENCES `tbl_usuarios` (`codigo_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_favoritos`
--
ALTER TABLE `tbl_favoritos`
ADD CONSTRAINT `fk_tbl_favoritos_tbl_archivo1` FOREIGN KEY (`codigo_archivo`) REFERENCES `tbl_archivo` (`codigo_archivo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_tbl_favoritos_tbl_usuarios1` FOREIGN KEY (`codigo_usuario`) REFERENCES `tbl_usuarios` (`codigo_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_registro_planes`
--
ALTER TABLE `tbl_registro_planes`
ADD CONSTRAINT `fk_tbl_registro_planes_tbl_planes1` FOREIGN KEY (`codigo_plan`) REFERENCES `tbl_planes` (`codigo_plan`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_tbl_registro_planes_tbl_usuarios1` FOREIGN KEY (`codigo_usuario`) REFERENCES `tbl_usuarios` (`codigo_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
ADD CONSTRAINT `fk_tbl_usuarios_tbl_planes1` FOREIGN KEY (`codigo_plan`) REFERENCES `tbl_planes` (`codigo_plan`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_tbl_usuarios_tbl_tipos_usuarios1` FOREIGN KEY (`codigo_tipo_usuario`) REFERENCES `tbl_tipos_usuarios` (`codigo_tipo_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
