use mihaly;
DROP PROCEDURE IF EXISTS sp_consulta_archivos;
DELIMITER //
create procedure sp_consulta_archivos(

	in p_codigo_usuario int,
    in p_codigo_padre int
    
) 
begin
	if(p_codigo_padre is null) then
		SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
		FROM tbl_archivo
		WHERE (codigo_usuario = p_codigo_usuario AND
			codigo_carpeta_padre is null AND
            estado='1');
	ELSE
		SELECT codigo_archivo, nombre_archivo, fecha_creacion, codigo_carpeta_padre, tipo_archivo, url_archivo
		FROM tbl_archivo
		WHERE (codigo_usuario = p_codigo_usuario AND
			codigo_carpeta_padre =p_codigo_padre AND
            estado='1');
	END IF;
	 
END //
DELIMITER ; 
 

