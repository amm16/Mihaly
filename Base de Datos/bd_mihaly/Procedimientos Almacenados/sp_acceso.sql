use mihaly;
DROP PROCEDURE IF EXISTS sp_accesos;
DELIMITER //
create procedure sp_accesos(

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
  
	 
END //
DELIMITER ; 
 


