CREATE DATABASE IF NOT EXISTS mastrettadesign;
USE mastrettadesign;

-- Tabla de Piezas
CREATE TABLE Piezas (
    id_pieza CHAR(8) PRIMARY KEY,
    codigo_pieza VARCHAR(8) NOT NULL,
    codigo_fabricante CHAR(3) NOT NULL,
    descripcion TEXT NOT NULL,
    programa_cad VARCHAR(150),
    material ENUM('AL', 'AC', 'PL') NOT NULL
);

-- Tabla de Motores
CREATE TABLE Motores (
    id_motor CHAR(8) PRIMARY KEY,
    descripcion TEXT NOT NULL,
    num_piezas INT NOT NULL,
    programa_cad VARCHAR(150),
    tipo ENUM('Motocicleta', 'Automóvil') NOT NULL,
    caballos_fuerza INT,
    tipo_refrigeracion VARCHAR(50),
    potencia_fiscal INT,
    tipo_anclaje VARCHAR(50)
);

-- Tabla de Operarios
CREATE TABLE Operarios (
    id_operario CHAR(8) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL
);

-- Tabla de Ensamblaje
CREATE TABLE Ensamblaje (
    id_ensamblaje INT AUTO_INCREMENT PRIMARY KEY,
    id_motor CHAR(8),
    id_pieza CHAR(8),
    id_operario_instala CHAR(8),
    id_operario_revisa CHAR(8),
    FOREIGN KEY (id_motor) REFERENCES Motores(id_motor),
    FOREIGN KEY (id_pieza) REFERENCES Piezas(id_pieza),
    FOREIGN KEY (id_operario_instala) REFERENCES Operarios(id_operario),
    FOREIGN KEY (id_operario_revisa) REFERENCES Operarios(id_operario)
);

-- Tabla de Expedientes Especiales
CREATE TABLE Expedientes (
    id_expediente INT AUTO_INCREMENT PRIMARY KEY,
    id_operario CHAR(8),
    fecha_evento DATE NOT NULL,
    tiempo_evento INT NOT NULL,
    FOREIGN KEY (id_operario) REFERENCES Operarios(id_operario)
);

-- Insertando datos de prueba
INSERT INTO Piezas VALUES
('PZ000001', 'ABC12345', 'F01', 'Culata de aluminio', '/cad/culata.dwg', 'AL'),
('PZ000002', 'DEF67890', 'F02', 'Cigüeñal de acero', '/cad/ciguenal.dwg', 'AC');

INSERT INTO Motores VALUES
('MT000001', 'Motor de alto rendimiento para auto', 150, '/cad/motor1.dwg', 'Automóvil', NULL, NULL, 120, 'Montura fija'),
('MT000002', 'Motor de motocicleta 250cc', 80, '/cad/motor2.dwg', 'Motocicleta', 30, 'Aire', NULL, NULL);

INSERT INTO Operarios VALUES
('OP000001', 'Carlos Pérez', 18000.50),
('OP000002', 'Ana López', 17000.00);

INSERT INTO Ensamblaje (id_motor, id_pieza, id_operario_instala, id_operario_revisa) VALUES
('MT000001', 'PZ000001', 'OP000001', 'OP000002'),
('MT000002', 'PZ000002', 'OP000002', 'OP000001');

INSERT INTO Expedientes (id_operario, fecha_evento, tiempo_evento) VALUES
('OP000001', '2025-03-01', 5),
('OP000002', '2025-02-20', 3);

-- Consultas básicas
-- 1. Ver todos los motores y sus descripciones
SELECT * FROM Motores;

-- 2. Ver todas las piezas y sus materiales
SELECT id_pieza, descripcion, material FROM Piezas;

-- 3. Ver qué operarios han participado en ensamblajes
SELECT DISTINCT O.nombre FROM Operarios O
JOIN Ensamblaje E ON O.id_operario = E.id_operario_instala OR O.id_operario = E.id_operario_revisa;

-- 4. Ver cuántas piezas tiene cada motor
SELECT M.descripcion, COUNT(E.id_pieza) AS cantidad_piezas
FROM Motores M
LEFT JOIN Ensamblaje E ON M.id_motor = E.id_motor
GROUP BY M.id_motor;

-- 5. Ver operarios con eventos especiales
SELECT O.nombre, E.fecha_evento, E.tiempo_evento
FROM Operarios O
JOIN Expedientes E ON O.id_operario = E.id_operario;

-- 6. Ver los ensamblajes realizados por cada operario
SELECT O.nombre, COUNT(E.id_ensamblaje) AS ensamblajes
FROM Operarios O
LEFT JOIN Ensamblaje E ON O.id_operario = E.id_operario_instala
GROUP BY O.id_operario;

