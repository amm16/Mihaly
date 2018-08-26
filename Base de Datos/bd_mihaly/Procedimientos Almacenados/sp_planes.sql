use mihaly;
DROP PROCEDURE IF EXISTS sp_planes;
DELIMITER //
create procedure sp_planes(
	in p_accion int,
	in p_codigo_plan int,
    in p_nombre_plan varchar(60),
    in p_capacidad int,
    in p_descripcion varchar(200),
    in p_meses_vigencia int,
    in p_precio float
) 
begin
	if p_accion=1 then
    -- Se agrega nuevo tipo usuario
		INSERT INTO tbl_planes ( 
            nombre_plan, 
            capacidad, 
            descripcion,
            meses_vigencia,
            precio
            )
		VALUES (
			p_nombre_plan,
            p_capacidad,
            p_descripcion,
            p_meses_vigencia,
            p_precio
            
            );
    ELSEIF p_accion=2 AND p_codigo_plan  IS NOT NULL THEN
		-- Modificar Nombre Plan
		IF p_nombre_plan IS NOT NULL THEN
			UPDATE tbl_planes
			SET nombre_plan = p_nombre_plan
			WHERE (codigo_plan = p_codigo_pla); 
        END IF;
		-- Modificar Capacidad
		IF p_capacidad IS NOT NULL THEN
			UPDATE tbl_planes
			SET capacidad = p_capacidad
			WHERE (codigo_plan = p_codigo_pla); 
        END IF;
		-- Modificar Descripcion
		IF p_descripcion IS NOT NULL THEN
			UPDATE tbl_planes
			SET descripcion = p_descripcion
			WHERE (codigo_plan = p_codigo_pla); 
        END IF;
        
        -- Modificar Meses d Vigencia del Plan
		IF p_meses_vigencia IS NOT NULL THEN
			UPDATE tbl_planes
			SET meses_vigencia = p_meses_vigencia
			WHERE (codigo_plan = p_codigo_pla); 
        END IF;
         -- Modificar Precio
		IF p_precio IS NOT NULL THEN
			UPDATE tbl_planes
			SET precio = p_precio
			WHERE (codigo_plan = p_codigo_plan); 
        END IF;
    ELSEIF p_accion=3  AND p_codigo_plan  IS NOT NULL THEN
    -- Se elimina usuario
        DELETE FROM tbl_planes
		WHERE (codigo_plan = p_codigo_plan); 
    ELSE 
		SELECT 'Error,No es una accion definida';
	END IF;
	 
END //
DELIMITER ; 
 


