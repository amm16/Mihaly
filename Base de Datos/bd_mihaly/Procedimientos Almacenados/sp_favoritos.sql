use mihaly;
DROP PROCEDURE IF EXISTS sp_favoritos;
DELIMITER //
create procedure sp_favoritos(
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


END //
DELIMITER ; 
 


