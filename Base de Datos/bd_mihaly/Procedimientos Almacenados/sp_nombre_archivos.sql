use mihaly;
DROP PROCEDURE IF EXISTS sp_nombre_archivos;
DELIMITER //
create procedure sp_nombre_archivos(
    in p_codigo_archivo int
    
) 
begin

    SELECT nombre_archivo
    FROM tbl_archivo
    WHERE (codigo_archivo = p_codigo_archivo);
  
	 
END //
DELIMITER ; 
 
