-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-10-2024 a las 18:39:29
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

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`cliente_id`, `nombre`, `apellido`, `email`, `telefono`, `direccion`) VALUES
(1, 'Juan', 'Pérez', 'juan.perez@example.com', '999888777', 'Calle Falsa 123'),
(2, 'Ana', 'Gómez', 'ana.gomez@example.com', '999777666', 'Av. Principal 456'),
(3, 'Luis', 'Martínez', 'luis.martinez@example.com', '988776655', 'Calle Secundaria 789'),
(4, 'María', 'López', 'maria.lopez@example.com', '977665544', 'Jr. Terciario 321'),
(5, 'Pedro', 'Sánchez', 'pedro.sanchez@example.com', '966554433', 'Calle Industrial 101');

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`empleado_id`, `nombre`, `apellido`, `cargo`, `fecha_contratacion`) VALUES
(1, 'Carlos', 'Pérez', 'Recepcionista', '2022-05-10'),
(2, 'Ana', 'Gómez', 'Camarera', '2021-07-15'),
(3, 'Luis', 'Fernández', 'Botones', '2023-02-01');

--
-- Volcado de datos para la tabla `empleado_turno`
--

INSERT INTO `empleado_turno` (`empleado_turno_id`, `empleado_id`, `turno_id`, `fecha_asignacion`) VALUES
(7, 1, 1, '2024-10-04'),
(8, 2, 2, '2024-10-04'),
(9, 3, 3, '2024-10-04');

--
-- Volcado de datos para la tabla `habitaciones`
--

INSERT INTO `habitaciones` (`habitacion_id`, `numero`, `tipo`, `precio_noche`, `estado`) VALUES
(1, '101', 'Simple', 50.00, 'Disponible'),
(2, '102', 'Doble', 80.00, 'Disponible'),
(3, '201', 'Suite', 120.00, 'Ocupada'),
(4, '202', 'Simple', 50.00, 'Disponible'),
(5, '203', 'Doble', 80.00, 'Ocupada');

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`pago_id`, `reserva_id`, `fecha_pago`, `monto`, `metodo_pago`) VALUES
(1, 1, '2024-08-31', 100.00, 'Tarjeta de crédito'),
(2, 2, '2024-09-04', 600.00, 'Transferencia bancaria'),
(3, 3, '2024-09-07', 320.00, 'Tarjeta de débito'),
(4, 5, '2024-09-15', 100.00, 'Efectivo');

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`reserva_id`, `cliente_id`, `habitacion_id`, `empleado_id`, `turno_id`, `fecha_entrada`, `fecha_salida`, `monto_total`, `estado_reserva`) VALUES
(1, 1, 1, 1, 1, '2024-09-01', '2024-09-03', 100.00, 'Confirmada'),
(2, 2, 2, 2, 2, '2024-09-05', '2024-09-10', 600.00, 'Confirmada'),
(3, 3, 3, 3, 1, '2024-09-08', '2024-09-12', 320.00, 'Pendiente'),
(4, 4, 2, 1, 3, '2024-09-11', '2024-09-15', 400.00, 'Cancelada'),
(5, 5, 1, 3, 1, '2024-09-16', '2024-09-18', 100.00, 'Confirmada');

--
-- Volcado de datos para la tabla `reservas_servicios`
--

INSERT INTO `reservas_servicios` (`reserva_id`, `servicio_id`, `cantidad`) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 4, 1),
(5, 5, 1);

--
-- Volcado de datos para la tabla `servicios_adicionales`
--

INSERT INTO `servicios_adicionales` (`servicio_id`, `nombre`, `descripcion`, `precio`) VALUES
(1, 'Desayuno', 'Servicio de desayuno continental', 15.00),
(2, 'Spa', 'Acceso a la zona de spa', 50.00),
(3, 'Transporte', 'Servicio de transporte al aeropuerto', 20.00),
(4, 'Cama adicional', 'Cama adicional en la habitación', 10.00),
(5, 'Cena', 'Cena gourmet para 2 personas', 30.00);

--
-- Volcado de datos para la tabla `turnos`
--

INSERT INTO `turnos` (`turno_id`, `hora_inicio`, `hora_fin`) VALUES
(1, '08:00:00', '14:00:00'),
(2, '14:00:00', '22:00:00'),
(3, '22:00:00', '06:00:00');

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
