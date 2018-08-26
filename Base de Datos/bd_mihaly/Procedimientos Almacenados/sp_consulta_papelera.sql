use mihaly;
DROP PROCEDURE IF EXISTS sp_consulta_papelera;
DELIMITER //
create procedure sp_consulta_papelera(

	in p_codigo_usuario int
    
) 
	begin
	SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
	FROM tbl_archivo
	WHERE (codigo_usuario = p_codigo_usuario AND
            estado='2');
            
	 
END //
DELIMITER ; 
 

