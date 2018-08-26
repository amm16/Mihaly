use mihaly;
DROP PROCEDURE IF EXISTS sp_consulta_usuarios_registrados;
DELIMITER //
create procedure sp_consulta_usuarios_registrados() 
begin
	SELECT codigo_usuario, codigo_tipo_usuario, A.codigo_plan as codigo_plan, usuario,correo,nombre_plan,fecha_registro
    FROM tbl_usuarios A
    LEFT JOIN tbl_planes B
    Left JOIN tbl_tipos_usuarios C
    ON (A.codigo_plan=B.codigo_plan)
    ON (A.codigo_tipo_usuario=B.codigo_tipo_usuario);
            
	 
END //
DELIMITER ; 
 
