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
