use mihaly;
DROP PROCEDURE IF EXISTS sp_usuarios;
DELIMITER //
create procedure sp_usuarios(
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
	 
END //
DELIMITER ; 
 


