use mihaly;
DROP PROCEDURE IF EXISTS sp_login;
DELIMITER //
create procedure sp_login(

	in p_correo varchar(60),
    in p_clave varchar(60)
) 
begin

    SELECT codigo_usuario, codigo_tipo_usuario, codigo_plan, usuario,correo
    FROM tbl_usuarios
    WHERE (correo = p_correo AND clave = sha1(p_clave));
  
	 
END //
DELIMITER ; 
 


