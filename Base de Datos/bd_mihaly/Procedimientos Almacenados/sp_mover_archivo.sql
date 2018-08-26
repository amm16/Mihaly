use mihaly;
DROP PROCEDURE IF EXISTS sp_mover_archivo;
DELIMITER //
create procedure sp_mover_archivo(
    in p_codigo_archivo int,
	in p_codigo_carpeta_padre int
) 
begin
	IF p_codigo_archivo IS NOT NULL THEN
			UPDATE tbl_archivo
			SET codigo_carpeta_padre= p_codigo_carpeta_padre
			WHERE (codigo_archivo=p_codigo_archivo); 
        END IF;
END //
DELIMITER ; 
 


