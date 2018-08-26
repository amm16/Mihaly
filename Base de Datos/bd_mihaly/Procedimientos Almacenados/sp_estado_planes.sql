use mihaly;
DROP PROCEDURE IF EXISTS sp_estado_planes;
DELIMITER //
create procedure sp_estado_planes()

begin
    -- Se agrega nuevo registro de plan
	use mihaly;
DROP PROCEDURE IF EXISTS sp_estado_planes;
DELIMITER //
create procedure sp_estado_planes(
) 
begin
DECLARE v_codigo INT;
DECLARE v_fecha DATE;
DECLARE v_numero_meses INT;
DECLARE fin INTEGER DEFAULT 0;

DECLARE cursor_registro CURSOR FOR 
		SELECT codigo_registro,
				fecha_adquisicion,
                meses_vigencia
		FROM tbl_registro_planes as A
        LEFT JOIN tbl_planes as B
		ON (A.codigo_plan = B.codigo_plan)
        WHERE (A.estado='1');
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
OPEN cursor_registro;
bucle: LOOP
    FETCH cursor_registro INTO v_codigo,v_fecha,v_numero_meses;
    IF fin = 1 THEN
       LEAVE bucle;
    END IF;
    SET @numero_meses := (SELECT TIMESTAMPDIFF(MONTH, v_fecha, sysdate()));
	IF(@numero_meses > v_numero_meses)THEN
		UPDATE tbl_registro_planes
		SET estado = '2'
		WHERE (codigo_registro = v_codigo);
	END IF;
END LOOP bucle;
 
CLOSE cursor_registro;

END //
DELIMITER ; 
 


