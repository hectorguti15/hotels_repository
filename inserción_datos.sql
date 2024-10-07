-- Inserción de datos en la tabla Clientes
INSERT INTO Clientes (nombre, apellido, email, telefono, direccion)
VALUES 
('Juan', 'Pérez', 'juan.perez@example.com', '999888777', 'Calle Falsa 123'),
('Ana', 'Gómez', 'ana.gomez@example.com', '999777666', 'Av. Principal 456'),
('Luis', 'Martínez', 'luis.martinez@example.com', '988776655', 'Calle Secundaria 789'),
('María', 'López', 'maria.lopez@example.com', '977665544', 'Jr. Terciario 321'),
('Pedro', 'Sánchez', 'pedro.sanchez@example.com', '966554433', 'Calle Industrial 101'); 

-- Inserción de datos en la tabla Reservas
INSERT INTO Reservas (cliente_id, habitacion_id, fecha_entrada, fecha_salida, monto_total, estado_reserva)
VALUES
(1, 1, '2024-09-01', '2024-09-03', 100.00, 'Confirmada'),
(2, 3, '2024-09-05', '2024-09-10', 600.00, 'Confirmada'),
(3, 2, '2024-09-08', '2024-09-12', 320.00, 'Pendiente'),
(4, 5, '2024-09-11', '2024-09-15', 400.00, 'Cancelada'),
(5, 4, '2024-09-16', '2024-09-18', 100.00, 'Confirmada');

-- Inserción de datos en la tabla Pagos
INSERT INTO Pagos (reserva_id, fecha_pago, monto, metodo_pago)
VALUES
(1, '2024-08-31', 100.00, 'Tarjeta de crédito'),
(2, '2024-09-04', 600.00, 'Transferencia bancaria'),
(3, '2024-09-07', 320.00, 'Tarjeta de débito'),
(5, '2024-09-15', 100.00, 'Efectivo');

-- Inserción de datos en la tabla Servicios_Adicionales
INSERT INTO Servicios_Adicionales (nombre, descripcion, precio)
VALUES
('Desayuno', 'Servicio de desayuno continental', 15.00),
('Spa', 'Acceso a la zona de spa', 50.00),
('Transporte', 'Servicio de transporte al aeropuerto', 20.00),
('Cama adicional', 'Cama adicional en la habitación', 10.00),
('Cena', 'Cena gourmet para 2 personas', 30.00);

-- Inserción de datos en la tabla Reservas_Servicios
INSERT INTO Reservas_Servicios (reserva_id, servicio_id, cantidad)
VALUES
(1, 1, 2),  
(1, 3, 1),  
(2, 2, 1),  
(3, 4, 1),  
(5, 5, 1);  

INSERT INTO Empleado_Turno (empleado_id, turno_id, fecha_asignacion)
VALUES
(1, 1, '2024-10-04'),
(2, 2, '2024-10-04'),
(3, 3, '2024-10-04');

INSERT INTO Turnos (hora_inicio, hora_fin)
VALUES
('08:00:00', '14:00:00'),
('14:00:00', '22:00:00'),
('22:00:00', '06:00:00');

INSERT INTO Empleados (nombre, apellido, cargo, fecha_contratacion)
VALUES
('Carlos', 'Pérez', 'Recepcionista', '2022-05-10'),
('Ana', 'Gómez', 'Camarera', '2021-07-15'),
('Luis', 'Fernández', 'Botones', '2023-02-01');


INSERT INTO Auditoria_Habitaciones (habitacion_id, estado_anterior, estado_nuevo, fecha_cambio)
VALUES
(101, 'Disponible', 'Ocupada', '2024-10-10'),  
(102, 'Disponible', 'Mantenimiento', '2024-10-12'), 
(103, 'Ocupada', 'Disponible', '2024-10-18'),
(104, 'Disponible', 'Ocupada', '2024-10-20'), 
(105, 'Ocupada', 'Disponible', '2024-10-25'); 


INSERT INTO Auditoria_Reserva (reserva_id, estado_anterior, estado_nuevo, fecha_cambio)
VALUES
(1, 'Pendiente', 'Confirmada', '2024-10-10'), 
(2, 'Pendiente', 'Cancelada', '2024-10-11'), 
(3, 'Confirmada', 'Cancelada', '2024-10-15'), 
(4, 'Pendiente', 'Confirmada', '2024-10-20'), 
(5, 'Pendiente', 'Confirmada', '2024-10-22'); 
