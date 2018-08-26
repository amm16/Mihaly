use mihaly;
DROP PROCEDURE IF EXISTS sp_archivos;
DELIMITER //
create procedure sp_archivos(
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
	 
END //
DELIMITER ; 
 


