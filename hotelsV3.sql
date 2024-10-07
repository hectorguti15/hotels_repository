-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-10-2024 a las 18:40:28
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `hotels`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_habitaciones`
--

CREATE TABLE `auditoria_habitaciones` (
  `auditoria_id` int(11) NOT NULL,
  `habitacion_id` int(11) DEFAULT NULL,
  `estado_anterior` varchar(50) DEFAULT NULL,
  `estado_nuevo` varchar(50) DEFAULT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_reservas`
--

CREATE TABLE `auditoria_reservas` (
  `auditoria_id` int(11) NOT NULL,
  `reserva_id` int(11) DEFAULT NULL,
  `motivo_cancelacion` varchar(255) DEFAULT NULL,
  `fecha_cancelacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `cliente_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `empleado_id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado_turno`
--

CREATE TABLE `empleado_turno` (
  `empleado_turno_id` int(11) NOT NULL,
  `empleado_id` int(11) DEFAULT NULL,
  `turno_id` int(11) DEFAULT NULL,
  `fecha_asignacion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitaciones`
--

CREATE TABLE `habitaciones` (
  `habitacion_id` int(11) NOT NULL,
  `numero` varchar(10) NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `estado` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `habitaciones`
--
DELIMITER $$
CREATE TRIGGER `Registrar_Cambio_Estado_Habitacion` AFTER UPDATE ON `habitaciones` FOR EACH ROW BEGIN
    IF OLD.estado <> NEW.estado THEN
        INSERT INTO Auditoria_Habitaciones (habitacion_id, estado_anterior, estado_nuevo, fecha_cambio)
        VALUES (NEW.habitacion_id, OLD.estado, NEW.estado, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `habitaciones_disponibles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `habitaciones_disponibles` (
`habitacion_id` int(11)
,`numero` varchar(10)
,`tipo` varchar(30)
,`precio_noche` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `pago_id` int(11) NOT NULL,
  `reserva_id` int(11) NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `pagos_realizados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `pagos_realizados` (
`pago_id` int(11)
,`reserva_id` int(11)
,`cliente` varchar(50)
,`cliente_apellido` varchar(50)
,`fecha_pago` date
,`monto` decimal(10,2)
,`metodo_pago` varchar(30)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `reserva_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `habitacion_id` int(11) NOT NULL,
  `empleado_id` int(11) DEFAULT NULL,
  `turno_id` int(11) DEFAULT NULL,
  `fecha_entrada` date NOT NULL,
  `fecha_salida` date NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `estado_reserva` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `reservas`
--
DELIMITER $$
CREATE TRIGGER `Registrar_Cancelacion_Reserva` AFTER UPDATE ON `reservas` FOR EACH ROW BEGIN
    IF OLD.estado_reserva <> 'Cancelada' AND NEW.estado_reserva = 'Cancelada' THEN
        -- Actualizar el estado de la habitación asociada
        UPDATE Habitaciones
        SET estado = 'Disponible'
        WHERE habitacion_id = NEW.habitacion_id;
        
        -- Registrar la cancelación en la auditoría
        INSERT INTO Auditoria_Reservas (reserva_id, motivo_cancelacion, fecha_cancelacion)
        VALUES (NEW.reserva_id, 'Cancelación realizada por cliente', NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `reservas_confirmadas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `reservas_confirmadas` (
`reserva_id` int(11)
,`cliente` varchar(50)
,`cliente_apellido` varchar(50)
,`habitacion` varchar(10)
,`fecha_entrada` date
,`fecha_salida` date
,`monto_total` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_servicios`
--

CREATE TABLE `reservas_servicios` (
  `reserva_id` int(11) NOT NULL,
  `servicio_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `resumen_reservas_cliente`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `resumen_reservas_cliente` (
`cliente_id` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`total_reservas` bigint(21)
,`total_pagado` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_adicionales`
--

CREATE TABLE `servicios_adicionales` (
  `servicio_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `servicios_reserva`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `servicios_reserva` (
`reserva_id` int(11)
,`cliente` varchar(50)
,`cliente_apellido` varchar(50)
,`servicio` varchar(50)
,`cantidad` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turnos`
--

CREATE TABLE `turnos` (
  `turno_id` int(11) NOT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fin` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura para la vista `habitaciones_disponibles`
--
DROP TABLE IF EXISTS `habitaciones_disponibles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `habitaciones_disponibles`  AS SELECT `h`.`habitacion_id` AS `habitacion_id`, `h`.`numero` AS `numero`, `h`.`tipo` AS `tipo`, `h`.`precio_noche` AS `precio_noche` FROM `habitaciones` AS `h` WHERE `h`.`estado` = 'Disponible' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `pagos_realizados`
--
DROP TABLE IF EXISTS `pagos_realizados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pagos_realizados`  AS SELECT `p`.`pago_id` AS `pago_id`, `r`.`reserva_id` AS `reserva_id`, `c`.`nombre` AS `cliente`, `c`.`apellido` AS `cliente_apellido`, `p`.`fecha_pago` AS `fecha_pago`, `p`.`monto` AS `monto`, `p`.`metodo_pago` AS `metodo_pago` FROM ((`pagos` `p` join `reservas` `r` on(`p`.`reserva_id` = `r`.`reserva_id`)) join `clientes` `c` on(`r`.`cliente_id` = `c`.`cliente_id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `reservas_confirmadas`
--
DROP TABLE IF EXISTS `reservas_confirmadas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reservas_confirmadas`  AS SELECT `r`.`reserva_id` AS `reserva_id`, `c`.`nombre` AS `cliente`, `c`.`apellido` AS `cliente_apellido`, `h`.`numero` AS `habitacion`, `r`.`fecha_entrada` AS `fecha_entrada`, `r`.`fecha_salida` AS `fecha_salida`, `r`.`monto_total` AS `monto_total` FROM ((`reservas` `r` join `clientes` `c` on(`r`.`cliente_id` = `c`.`cliente_id`)) join `habitaciones` `h` on(`r`.`habitacion_id` = `h`.`habitacion_id`)) WHERE `r`.`estado_reserva` = 'Confirmada' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `resumen_reservas_cliente`
--
DROP TABLE IF EXISTS `resumen_reservas_cliente`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `resumen_reservas_cliente`  AS SELECT `c`.`cliente_id` AS `cliente_id`, `c`.`nombre` AS `nombre`, `c`.`apellido` AS `apellido`, count(`r`.`reserva_id`) AS `total_reservas`, sum(`p`.`monto`) AS `total_pagado` FROM ((`clientes` `c` left join `reservas` `r` on(`c`.`cliente_id` = `r`.`cliente_id`)) left join `pagos` `p` on(`r`.`reserva_id` = `p`.`reserva_id`)) GROUP BY `c`.`cliente_id`, `c`.`nombre`, `c`.`apellido` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `servicios_reserva`
--
DROP TABLE IF EXISTS `servicios_reserva`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `servicios_reserva`  AS SELECT `r`.`reserva_id` AS `reserva_id`, `c`.`nombre` AS `cliente`, `c`.`apellido` AS `cliente_apellido`, `s`.`nombre` AS `servicio`, `rs`.`cantidad` AS `cantidad` FROM (((`reservas_servicios` `rs` join `reservas` `r` on(`rs`.`reserva_id` = `r`.`reserva_id`)) join `clientes` `c` on(`r`.`cliente_id` = `c`.`cliente_id`)) join `servicios_adicionales` `s` on(`rs`.`servicio_id` = `s`.`servicio_id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria_habitaciones`
--
ALTER TABLE `auditoria_habitaciones`
  ADD PRIMARY KEY (`auditoria_id`),
  ADD KEY `habitacion_id` (`habitacion_id`);

--
-- Indices de la tabla `auditoria_reservas`
--
ALTER TABLE `auditoria_reservas`
  ADD PRIMARY KEY (`auditoria_id`),
  ADD KEY `reserva_id` (`reserva_id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`cliente_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`empleado_id`);

--
-- Indices de la tabla `empleado_turno`
--
ALTER TABLE `empleado_turno`
  ADD PRIMARY KEY (`empleado_turno_id`),
  ADD KEY `empleado_id` (`empleado_id`),
  ADD KEY `turno_id` (`turno_id`);

--
-- Indices de la tabla `habitaciones`
--
ALTER TABLE `habitaciones`
  ADD PRIMARY KEY (`habitacion_id`),
  ADD UNIQUE KEY `numero` (`numero`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`pago_id`),
  ADD KEY `reserva_id` (`reserva_id`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`reserva_id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `habitacion_id` (`habitacion_id`);

--
-- Indices de la tabla `reservas_servicios`
--
ALTER TABLE `reservas_servicios`
  ADD PRIMARY KEY (`reserva_id`,`servicio_id`),
  ADD KEY `servicio_id` (`servicio_id`);

--
-- Indices de la tabla `servicios_adicionales`
--
ALTER TABLE `servicios_adicionales`
  ADD PRIMARY KEY (`servicio_id`);

--
-- Indices de la tabla `turnos`
--
ALTER TABLE `turnos`
  ADD PRIMARY KEY (`turno_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria_habitaciones`
--
ALTER TABLE `auditoria_habitaciones`
  MODIFY `auditoria_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditoria_reservas`
--
ALTER TABLE `auditoria_reservas`
  MODIFY `auditoria_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `cliente_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `empleado_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleado_turno`
--
ALTER TABLE `empleado_turno`
  MODIFY `empleado_turno_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `habitaciones`
--
ALTER TABLE `habitaciones`
  MODIFY `habitacion_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `pago_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `reserva_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicios_adicionales`
--
ALTER TABLE `servicios_adicionales`
  MODIFY `servicio_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `turnos`
--
ALTER TABLE `turnos`
  MODIFY `turno_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auditoria_habitaciones`
--
ALTER TABLE `auditoria_habitaciones`
  ADD CONSTRAINT `auditoria_habitaciones_ibfk_1` FOREIGN KEY (`habitacion_id`) REFERENCES `habitaciones` (`habitacion_id`);

--
-- Filtros para la tabla `auditoria_reservas`
--
ALTER TABLE `auditoria_reservas`
  ADD CONSTRAINT `auditoria_reservas_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`reserva_id`);

--
-- Filtros para la tabla `empleado_turno`
--
ALTER TABLE `empleado_turno`
  ADD CONSTRAINT `empleado_turno_ibfk_1` FOREIGN KEY (`empleado_id`) REFERENCES `empleados` (`empleado_id`),
  ADD CONSTRAINT `empleado_turno_ibfk_2` FOREIGN KEY (`turno_id`) REFERENCES `turnos` (`turno_id`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`reserva_id`);

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`),
  ADD CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`habitacion_id`) REFERENCES `habitaciones` (`habitacion_id`);

--
-- Filtros para la tabla `reservas_servicios`
--
ALTER TABLE `reservas_servicios`
  ADD CONSTRAINT `reservas_servicios_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`reserva_id`),
  ADD CONSTRAINT `reservas_servicios_ibfk_2` FOREIGN KEY (`servicio_id`) REFERENCES `servicios_adicionales` (`servicio_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
