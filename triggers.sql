-- Creación de trigger Registrar_Cancelacion_Reserva
DELIMITER $$
CREATE TRIGGER Registrar_Cancelacion_Reserva
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF OLD.estado_reserva <> 'Cancelada' AND NEW.estado_reserva = 'Cancelada' THEN
        -- Actualizar el estado de la habitación asociada
        UPDATE Habitaciones
        SET estado = 'Disponible'
        WHERE habitacion_id = NEW.habitacion_id;
        
        -- Registrar la cancelación en la auditoría
        INSERT INTO Auditoria_Reservas (reserva_id, motivo_cancelacion, fecha_cancelacion)
        VALUES (NEW.reserva_id, 'Cancelación realizada por cliente', NOW());
    END IF;
END$$
DELIMITER ;

-- Creación de trigger Registrar_Cambio_Estado_Habitacion
DELIMITER $$
CREATE TRIGGER Registrar_Cambio_Estado_Habitacion
AFTER UPDATE ON Habitaciones
FOR EACH ROW
BEGIN
    IF OLD.estado <> NEW.estado THEN
        INSERT INTO Auditoria_Habitaciones (habitacion_id, estado_anterior, estado_nuevo, fecha_cambio)
        VALUES (NEW.habitacion_id, OLD.estado, NEW.estado, NOW());
    END IF;
END$$
DELIMITER ;
