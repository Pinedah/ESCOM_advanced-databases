DROP DATABASE IF EXISTS Mastrettadesign;
CREATE DATABASE Mastrettadesign;
USE Mastrettadesign;

-- Tabla de Fabricantes
CREATE TABLE Fabricante (
    codigo CHAR(3) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de Piezas
CREATE TABLE Pieza (
    id INT(8) PRIMARY KEY,
    codigo VARCHAR(8) NOT NULL,
    codigo_fabricante CHAR(3),
    descripcion TEXT NOT NULL,
    programa_cad VARCHAR(150),
    material ENUM('AL', 'AC', 'PL') NOT NULL,
    FOREIGN KEY (codigo_fabricante) REFERENCES Fabricante(codigo)
);

-- Tabla de Piezas Compuestas
CREATE TABLE PiezaCompuesta (
    id_pieza INT(8),
    id_pieza_componente INT(8),
    PRIMARY KEY (id_pieza, id_pieza_componente),
    FOREIGN KEY (id_pieza) REFERENCES Pieza(id),
    FOREIGN KEY (id_pieza_componente) REFERENCES Pieza(id)
);

-- Tabla de Motores
CREATE TABLE Motor (
    id INT(8) PRIMARY KEY,
    descripcion TEXT NOT NULL,
    num_piezas INT NOT NULL,
    programa_cad VARCHAR(150)
);

-- Tabla de Motores para motocicletas
CREATE TABLE MotorMotocicleta (
    id_motor INT(8) PRIMARY KEY,
    caballos_fuerza INT NOT NULL,
    tipo_refrigeracion VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_motor) REFERENCES Motor(id)
);

-- Tabla de Motores para automóviles
CREATE TABLE MotorAutomovil (
    id_motor INT(8) PRIMARY KEY,
    potencia_fiscal INT NOT NULL,
    tipo_anclaje VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_motor) REFERENCES Motor(id)
);

-- Tabla de la relación entre Motores y Piezas
CREATE TABLE MotorPieza (
    id_motor INT(8),
    id_pieza INT(8),
    PRIMARY KEY (id_motor, id_pieza),
    FOREIGN KEY (id_motor) REFERENCES Motor(id),
    FOREIGN KEY (id_pieza) REFERENCES Pieza(id)
);

-- Tabla de Operarios
CREATE TABLE Operario (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL
);

-- Tabla de Eventos Especiales de Operarios
CREATE TABLE EventoOperario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_operario INT NOT NULL,
    fecha DATE NOT NULL,
    tiempo_empleado TIME NOT NULL,
    FOREIGN KEY (id_operario) REFERENCES Operario(id)
);

-- Tabla de Ensamblaje
CREATE TABLE Ensamblaje (
    id_motor INT(8),
    id_pieza INT(8),
    operario_instalacion INT NOT NULL,
    operario_revision INT NOT NULL,
    PRIMARY KEY (id_motor, id_pieza, operario_instalacion, operario_revision),
    FOREIGN KEY (id_motor) REFERENCES Motor(id),
    FOREIGN KEY (id_pieza) REFERENCES Pieza(id),
    FOREIGN KEY (operario_instalacion) REFERENCES Operario(id),
    FOREIGN KEY (operario_revision) REFERENCES Operario(id)
);


-- Inserts de Ejemplo
INSERT INTO Fabricante (codigo, nombre) VALUES ('F01', 'Fabricante A'), ('F02', 'Fabricante B');

INSERT INTO Pieza (id, codigo, codigo_fabricante, descripcion, programa_cad, material) VALUES
(10000001, 'PZ001', 'F01', 'Pieza de aluminio', '/cad/pz001.dwg', 'AL'),
(10000002, 'PZ002', 'F02', 'Pieza de acero', '/cad/pz002.dwg', 'AC');

INSERT INTO Motor (id, descripcion, num_piezas, programa_cad) VALUES
(20000001, 'Motor de alto rendimiento', 2, '/cad/motor1.dwg');

INSERT INTO MotorPieza (id_motor, id_pieza) VALUES
(20000001, 10000001), (20000001, 10000002);

INSERT INTO Operario (id, nombre, sueldo) VALUES
(1, 'Juan Pérez', 15000.00),
(2, 'María López', 16000.00);

INSERT INTO Ensamblaje (id_motor, id_pieza, operario_instalacion, operario_revision) VALUES
(20000001, 10000001, 1, 2),
(20000001, 10000002, 2, 1);

-- Consultas para probar el funcionamiento
-- Obtener todas las piezas fabricadas por un fabricante específico
SELECT * FROM Pieza WHERE codigo_fabricante = 'F01';

-- Obtener los motores y sus piezas asociadas
SELECT m.id AS MotorID, m.descripcion AS MotorDescripcion, p.id AS PiezaID, p.descripcion AS PiezaDescripcion
FROM Motor m
JOIN MotorPieza mp ON m.id = mp.id_motor
JOIN Pieza p ON mp.id_pieza = p.id;

-- Obtener los operarios y sus ensamblajes
SELECT o.id AS OperarioID, o.nombre AS NombreOperario, e.id_motor, e.id_pieza
FROM Operario o
JOIN Ensamblaje e ON o.id = e.operario_instalacion OR o.id = e.operario_revision;
