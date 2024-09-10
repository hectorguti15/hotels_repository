

-- Creación de view reservas_confirmadas
CREATE VIEW Reservas_Confirmadas AS
SELECT R.reserva_id, C.nombre AS cliente, C.apellido AS cliente_apellido, H.numero AS habitacion, R.fecha_entrada, R.fecha_salida, R.monto_total
FROM Reservas R
JOIN Clientes C ON R.cliente_id = C.cliente_id
JOIN Habitaciones H ON R.habitacion_id = H.habitacion_id
WHERE R.estado_reserva = 'Confirmada';

-- Creación de view Pagos_Realizados
CREATE VIEW Pagos_Realizados AS
SELECT P.pago_id, R.reserva_id, C.nombre AS cliente, C.apellido AS cliente_apellido, P.fecha_pago, P.monto, P.metodo_pago
FROM Pagos P
JOIN Reservas R ON P.reserva_id = R.reserva_id
JOIN Clientes C ON R.cliente_id = C.cliente_id;

-- Creación de view Servicios_Reserva
CREATE VIEW Servicios_Reserva AS
SELECT R.reserva_id, C.nombre AS cliente, C.apellido AS cliente_apellido, S.nombre AS servicio, RS.cantidad
FROM Reservas_Servicios RS
JOIN Reservas R ON RS.reserva_id = R.reserva_id
JOIN Clientes C ON R.cliente_id = C.cliente_id
JOIN Servicios_Adicionales S ON RS.servicio_id = S.servicio_id;

-- Creación de view Habitaciones_Disponibles
CREATE VIEW Habitaciones_Disponibles AS
SELECT H.habitacion_id, H.numero, H.tipo, H.precio_noche
FROM Habitaciones H
WHERE H.estado = 'Disponible';


-- Creación de view Resumen_Reservas_Cliente
CREATE VIEW Resumen_Reservas_Cliente AS
SELECT C.cliente_id, C.nombre, C.apellido, COUNT(R.reserva_id) AS total_reservas, SUM(P.monto) AS total_pagado
FROM Clientes C
LEFT JOIN Reservas R ON C.cliente_id = R.cliente_id
LEFT JOIN Pagos P ON R.reserva_id = P.reserva_id
GROUP BY C.cliente_id, C.nombre, C.apellido;


-- Creación de la función Calcular_dias_reserva
DELIMITER $$
CREATE FUNCTION Calcular_Dias_Reserva(
    p_fecha_entrada DATE,
    p_fecha_salida DATE
)
RETURNS INT
BEGIN
    DECLARE num_dias INT;

    SET num_dias = DATEDIFF(p_fecha_salida, p_fecha_entrada);
    
    RETURN num_dias;
END$$
DELIMITER ;

-- Creación de la función Calcular_Monto_Total_Reserva
DELIMITER $$
CREATE FUNCTION Calcular_Monto_Total_Reserva(
    p_precio_noche DECIMAL(10,2),
    p_fecha_entrada DATE,
    p_fecha_salida DATE
)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE num_dias INT;
    DECLARE monto_total DECIMAL(10,2);
    

    SET num_dias = DATEDIFF(p_fecha_salida, p_fecha_entrada);

    SET monto_total = num_dias * p_precio_noche;
    
    RETURN monto_total;
END$$
DELIMITER ;

-- Creación de la tabla Auditoria_Habitaciones
CREATE TABLE  Auditoria_Habitaciones (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    habitacion_id INT,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (habitacion_id) REFERENCES Habitaciones(habitacion_id)
);
-- Creación de la tabla Auditoria_Reservas
CREATE TABLE Auditoria_Reservas (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT,
    motivo_cancelacion VARCHAR(255),
    fecha_cancelacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reserva_id) REFERENCES Reservas(reserva_id)
);

-- Creación de trigger Registrar_Cancelacion_Reserva
DELIMITER $$
CREATE TRIGGER Registrar_Cancelacion_Reserva
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF OLD.estado_reserva <> 'Cancelada' AND NEW.estado_reserva = 'Cancelada' THEN
  
        UPDATE Habitaciones
        SET estado = 'Disponible'
        WHERE habitacion_id = NEW.habitacion_id;
        
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


-- Creación de prodecimiento almacenado Actualizar_Estado_Reserva
DELIMITER $$
CREATE PROCEDURE Actualizar_Estado_Reserva(
    IN p_reserva_id INT,
    IN p_nuevo_estado VARCHAR(50)
)
BEGIN
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
    

    UPDATE Habitaciones
    SET estado = 'Ocupada'
    WHERE habitacion_id = p_habitacion_id;
END$$
DELIMITER ;
