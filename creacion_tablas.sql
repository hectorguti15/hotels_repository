
CREATE TABLE `auditoria_reservas` (
  `auditoria_id` int(11) NOT NULL,
  `reserva_id` int(11) DEFAULT NULL,
  `motivo_cancelacion` varchar(255) DEFAULT NULL,
  `fecha_cancelacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `habitaciones` (
  `habitacion_id` int(11) NOT NULL,
  `numero` varchar(10) NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `estado` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pagos` (
  `pago_id` int(11) NOT NULL,
  `reserva_id` int(11) NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `reservas_confirmadas` (
`reserva_id` int(11)
,`cliente` varchar(50)
,`cliente_apellido` varchar(50)
,`habitacion` varchar(10)
,`fecha_entrada` date
,`fecha_salida` date
,`monto_total` decimal(10,2)
);


CREATE TABLE `reservas` (
  `reserva_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `habitacion_id` int(11) NOT NULL,
  `fecha_entrada` date NOT NULL,
  `fecha_salida` date NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `estado_reserva` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `reservas_servicios` (
  `reserva_id` int(11) NOT NULL,
  `servicio_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `resumen_reservas_cliente` (
`cliente_id` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`total_reservas` bigint(21)
,`total_pagado` decimal(32,2)
);

CREATE TABLE `servicios_adicionales` (
  `servicio_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `clientes` (
  `cliente_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

CREATE TABLE Empleado_Turno (
    empleado_turno_id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT,
    turno_id INT,
    fecha_asignacion DATE,
    FOREIGN KEY (empleado_id) REFERENCES Empleados(empleado_id),
    FOREIGN KEY (turno_id) REFERENCES Turnos(turno_id)
);

CREATE TABLE Turnos (
    turno_id INT AUTO_INCREMENT PRIMARY KEY,
    hora_inicio TIME,
    hora_fin TIME
);

CREATE TABLE Empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    cargo VARCHAR(50),
    fecha_contratacion DATE
);
