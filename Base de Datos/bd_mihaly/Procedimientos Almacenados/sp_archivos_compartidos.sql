use mihaly;
DROP PROCEDURE IF EXISTS sp_archivos_compartidos;
DELIMITER //
create procedure sp_archivos_compartidos(
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
	 
END //
DELIMITER ; 
 


