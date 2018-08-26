use mihaly;
DROP PROCEDURE IF EXISTS sp_consulta_perfil;
DELIMITER //
create procedure sp_consulta_perfil(

	in p_codigo_usuario int
    
) 
begin
	SELECT codigo_usuario, codigo_tipo_usuario, A.codigo_plan as codigo_plan, usuario,correo,nombre_plan,fecha_registro
    FROM tbl_usuarios A
    LEFT JOIN tbl_planes B
    ON (A.codigo_plan=B.codigo_plan)
    WHERE (codigo_usuario=p_codigo_usuario );
            
	 
END //
DELIMITER ; 
 
