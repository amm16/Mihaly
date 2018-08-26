use mihaly;
DROP PROCEDURE IF EXISTS sp_contenido_archivo;
DELIMITER //
create procedure sp_contenido_archivo(
    in p_codigo_archivo int
    
) 
begin

    SELECT nombre_archivo,contenido,codigo_archivo
    FROM tbl_archivo
    WHERE (codigo_archivo = p_codigo_archivo);
  
	 
END //
DELIMITER ; 
 
