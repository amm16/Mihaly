-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mihaly
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mihaly
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mihaly` DEFAULT CHARACTER SET utf8 ;
USE `mihaly` ;

-- -----------------------------------------------------
-- Table `mihaly`.`tbl_planes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_planes` (
  `codigo_plan` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_plan` VARCHAR(45) NOT NULL,
  `capacidad` INT(11) NOT NULL,
  `descripcion` VARCHAR(45) NULL DEFAULT NULL,
  `meses_vigencia` INT(11) NULL DEFAULT NULL,
  `precio` FLOAT NOT NULL,
  PRIMARY KEY (`codigo_plan`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_tipos_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_tipos_usuarios` (
  `codigo_tipo_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_tipo_usuario` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigo_tipo_usuario`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_usuarios` (
  `codigo_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `codigo_tipo_usuario` INT(11) NOT NULL,
  `codigo_plan` INT(11) NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(100) NOT NULL,
  `clave` VARCHAR(45) NOT NULL,
  `fecha_registro` DATETIME NOT NULL,
  `imagen_perfil_url` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_usuario`),
  INDEX `fk_tbl_usuarios_tbl_planes1_idx` (`codigo_plan` ASC),
  INDEX `fk_tbl_usuarios_tbl_tipos_usuarios1_idx` (`codigo_tipo_usuario` ASC),
  CONSTRAINT `fk_tbl_usuarios_tbl_planes1`
    FOREIGN KEY (`codigo_plan`)
    REFERENCES `mihaly`.`tbl_planes` (`codigo_plan`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_usuarios_tbl_tipos_usuarios1`
    FOREIGN KEY (`codigo_tipo_usuario`)
    REFERENCES `mihaly`.`tbl_tipos_usuarios` (`codigo_tipo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_accesos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_accesos` (
  `codigo_acceso` INT(11) NOT NULL AUTO_INCREMENT,
  `codigo_usuario` INT(11) NOT NULL,
  `fecha_acceso` DATETIME NOT NULL,
  PRIMARY KEY (`codigo_acceso`),
  INDEX `fk_tbl_accesos_tbl_usuarios1` (`codigo_usuario` ASC),
  CONSTRAINT `fk_tbl_accesos_tbl_usuarios1`
    FOREIGN KEY (`codigo_usuario`)
    REFERENCES `mihaly`.`tbl_usuarios` (`codigo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 362
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_archivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_archivo` (
  `codigo_archivo` INT(11) NOT NULL AUTO_INCREMENT,
  `codigo_usuario` INT(11) NOT NULL,
  `nombre_archivo` VARCHAR(100) NOT NULL,
  `fecha_creacion` DATETIME NOT NULL,
  `codigo_carpeta_padre` INT(11) NULL DEFAULT NULL,
  `tipo_archivo` VARCHAR(10) NULL DEFAULT NULL,
  `url_archivo` VARCHAR(200) NOT NULL,
  `contenido` MEDIUMTEXT NULL DEFAULT NULL,
  `estado` INT(11) NULL DEFAULT NULL,
  `extension` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_archivo`),
  INDEX `fk_tbl_archivo_tbl_archivo1_idx` (`codigo_carpeta_padre` ASC),
  INDEX `fk_tbl_archivo_tbl_usuarios1_idx` (`codigo_usuario` ASC),
  CONSTRAINT `fk_tbl_archivo_tbl_archivo1`
    FOREIGN KEY (`codigo_carpeta_padre`)
    REFERENCES `mihaly`.`tbl_archivo` (`codigo_archivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_archivo_tbl_usuarios1`
    FOREIGN KEY (`codigo_usuario`)
    REFERENCES `mihaly`.`tbl_usuarios` (`codigo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 74
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_archivos_compartidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_archivos_compartidos` (
  `codigo_archivo` INT(11) NOT NULL,
  `codigo_usuario` INT(11) NOT NULL,
  PRIMARY KEY (`codigo_archivo`, `codigo_usuario`),
  INDEX `fk_tbl_compartir_tbl_archivo1_idx` (`codigo_archivo` ASC),
  INDEX `fk_tbl_compartir_tbl_usuarios1_idx` (`codigo_usuario` ASC),
  CONSTRAINT `fk_tbl_compartir_tbl_archivo1`
    FOREIGN KEY (`codigo_archivo`)
    REFERENCES `mihaly`.`tbl_archivo` (`codigo_archivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_compartir_tbl_usuarios1`
    FOREIGN KEY (`codigo_usuario`)
    REFERENCES `mihaly`.`tbl_usuarios` (`codigo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_favoritos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_favoritos` (
  `codigo_archivo` INT(11) NOT NULL,
  `codigo_usuario` INT(11) NOT NULL,
  `eliminar` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_archivo`, `codigo_usuario`),
  INDEX `fk_tbl_favoritos_tbl_usuarios1_idx` (`codigo_usuario` ASC),
  CONSTRAINT `fk_tbl_favoritos_tbl_archivo1`
    FOREIGN KEY (`codigo_archivo`)
    REFERENCES `mihaly`.`tbl_archivo` (`codigo_archivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_favoritos_tbl_usuarios1`
    FOREIGN KEY (`codigo_usuario`)
    REFERENCES `mihaly`.`tbl_usuarios` (`codigo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mihaly`.`tbl_registro_planes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mihaly`.`tbl_registro_planes` (
  `codigo_registro` INT(11) NOT NULL,
  `codigo_usuario` INT(11) NOT NULL,
  `codigo_plan` INT(11) NOT NULL,
  `fecha_adquisicion` DATE NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigo_registro`),
  INDEX `fk_tbl_registro_planes_tbl_usuarios1_idx` (`codigo_usuario` ASC),
  INDEX `fk_tbl_registro_planes_tbl_planes1_idx` (`codigo_plan` ASC),
  CONSTRAINT `fk_tbl_registro_planes_tbl_planes1`
    FOREIGN KEY (`codigo_plan`)
    REFERENCES `mihaly`.`tbl_planes` (`codigo_plan`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_registro_planes_tbl_usuarios1`
    FOREIGN KEY (`codigo_usuario`)
    REFERENCES `mihaly`.`tbl_usuarios` (`codigo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `mihaly` ;

-- -----------------------------------------------------
-- procedure sp_accesos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_archivos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_archivos_compartidos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta_archivos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta_compartidos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta_favoritos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta_papelera
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_papelera`(

	in p_codigo_usuario int
    
)
begin
	SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
	FROM tbl_archivo
	WHERE (codigo_usuario = p_codigo_usuario AND
            estado='2');
            
	 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta_perfil
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta_usuarios_registrados
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consulta_usuarios_registrados`()
begin
	SELECT A.codigo_usuario, C.codigo_tipo_usuario, A.codigo_plan as codigo_plan, usuario,correo,nombre_plan,fecha_registro,nombre_tipo_usuario
    FROM tbl_usuarios A
    LEFT JOIN tbl_planes B
    ON (A.codigo_plan=B.codigo_plan)
    Left JOIN tbl_tipos_usuarios C
    ON (A.codigo_tipo_usuario=C.codigo_tipo_usuario);
            
	 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_contenido_archivo
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contenido_archivo`(
    in p_codigo_archivo int
    
)
begin

    SELECT nombre_archivo,contenido,codigo_archivo
    FROM tbl_archivo
    WHERE (codigo_archivo = p_codigo_archivo);
  
	 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_correo
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_correo`(

	in p_correo varchar(60)
)
begin

    SELECT correo
    FROM tbl_usuarios
    WHERE (correo = p_correo);
  
	 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_favoritos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_login
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login`(

	in p_correo varchar(60),
    in p_clave varchar(60)
)
begin

    SELECT codigo_usuario, codigo_tipo_usuario, codigo_plan, usuario,correo
    FROM tbl_usuarios
    WHERE (correo = p_correo AND clave = sha1(p_clave));
  
	 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_nombre_archivos
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nombre_archivos`(
    in p_codigo_archivo int
    
)
begin

    SELECT nombre_archivo
    FROM tbl_archivo
    WHERE (codigo_archivo = p_codigo_archivo);
  
	 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_usuarios
-- -----------------------------------------------------

DELIMITER $$
USE `mihaly`$$
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

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
