use mihaly;
DROP PROCEDURE IF EXISTS sp_consulta_favoritos;
DELIMITER //
create procedure sp_consulta_favoritos(

	in p_codigo_usuario int
    
) 
	begin
	SELECT A.codigo_archivo as codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
	FROM tbl_favoritos A
	Left join tbl_archivo B
	on (A.codigo_archivo = B.codigo_archivo)
	WHERE (A.codigo_usuario = p_codigo_usuario AND
            estado='1');
            
	 
END //
DELIMITER ; 
 

