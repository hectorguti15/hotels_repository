-- Creación de prodecimiento almacenado Actualizar_Estado_Reserva
DELIMITER $$
CREATE PROCEDURE Actualizar_Estado_Reserva(
    IN p_reserva_id INT,
    IN p_nuevo_estado VARCHAR(50)
)
BEGIN
    -- Actualizar el estado de la reserva
    UPDATE Reservas
    SET estado_reserva = p_nuevo_estado
    WHERE reserva_id = p_reserva_id;
END$$
DELIMITER ;

-- Creación de prodecimiento almacenado Registrar_Reserva
DELIMITER $$
CREATE PROCEDURE Registrar_Reserva(
    IN p_cliente_id INT,
    IN p_habitacion_id INT,
    IN p_fecha_entrada DATE,
    IN p_fecha_salida DATE,
    IN p_monto_total DECIMAL(10,2),
    IN p_estado_reserva VARCHAR(50)
)
BEGIN
    -- Insertar la nueva reserva
    INSERT INTO Reservas (cliente_id, habitacion_id, fecha_entrada, fecha_salida, monto_total, estado_reserva)
    VALUES (p_cliente_id, p_habitacion_id, p_fecha_entrada, p_fecha_salida, p_monto_total, p_estado_reserva);
    
    -- Actualizar el estado de la habitación a 'Ocupada'
    UPDATE Habitaciones
    SET estado = 'Ocupada'
    WHERE habitacion_id = p_habitacion_id;
END$$
DELIMITER ;