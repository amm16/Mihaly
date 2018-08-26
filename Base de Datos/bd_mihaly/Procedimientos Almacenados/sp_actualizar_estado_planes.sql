use mihaly;
DROP PROCEDURE IF EXISTS sp_registro_planes;
DELIMITER //
create procedure sp_registro_planes(
	in p_accion int,
    in p_codigo_plan int,
	in p_fecha_adquisicion date,
    in p_estado varchar(30)
) 
begin
    -- Se agrega nuevo registro de plan
		INSERT INTO tbl_registro_planes (
           codigo_usuario,
           codigo_plan,
           fecha_adquisicion,
           estado
            )
		VALUES (
            p_codigo_usuario,
            p_codigo_plan,
            p_fecha_adquisicion,
            p_estado

            );
END //
DELIMITER ; 
 


