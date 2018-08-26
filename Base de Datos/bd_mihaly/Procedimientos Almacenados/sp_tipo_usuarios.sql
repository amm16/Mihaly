use mihaly;
DROP PROCEDURE IF EXISTS sp_tipo_usuarios;
DELIMITER //
create procedure sp_tipo_usuarios(
	in p_accion int,
	in p_codigo_tipo_usuario int,
    in p_nombre_tipo_usuario varchar(60)
) 
begin
	if p_accion=1 then
    -- Se agrega nuevo tipo usuario
		INSERT INTO tbl_tipos_usuarios (
            nombre_tipo_usuario
            )
		VALUES (
			p_nombre_tipo_usuario
            );
    ELSEIF p_accion=2  AND p_codigo_tipo_usuario IS NOT NULL THEN
		-- Modificar Tipo Usuario
		IF p_nombre_tipo_usuario IS NOT NULL THEN
			UPDATE tbl_tipos_usuarios
			SET nombre_tipo_usuario = p_nombre_tipo_usuario
			WHERE (codigo_tipo_usuario = p_codigo_tipo_usuario); 
        END IF;
		
    ELSEIF p_accion=3 AND p_codigo_tipo_usuario IS NOT NULL THEN
    -- Se elimina tipo usuario
        DELETE FROM tbl_tipos_usuarios
		WHERE (codigo_tipo_usuario = p_codigo_tipo_usuario); 
    ELSE 
		SELECT 'Error,No es una accion definida';
	END IF;
	 
END //
DELIMITER ; 
 


