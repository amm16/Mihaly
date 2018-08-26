use mihaly;
DROP PROCEDURE IF EXISTS sp_correo;
DELIMITER //
create procedure sp_correo(

	in p_correo varchar(60)
) 
begin

    SELECT correo
    FROM tbl_usuarios
    WHERE (correo = p_correo);
  
	 
END //
DELIMITER ; 
 


