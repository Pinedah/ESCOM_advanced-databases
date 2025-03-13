DROP DATABASE IF EXISTS ClinicaGuadalupana;
CREATE DATABASE ClinicaGuadalupana;
USE ClinicaGuadalupana;

CREATE TABLE Pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellidos VARCHAR(100),
    direccion VARCHAR(255),
    colonia VARCHAR(100),
    estado VARCHAR(50),
    codigo_postal VARCHAR(10),
    telefono VARCHAR(15),
    fecha_nacimiento DATE
);

CREATE TABLE Medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellidos VARCHAR(100),
    telefono VARCHAR(15),
    especialidad VARCHAR(100)
);

CREATE TABLE Ingresos (
    id_ingreso INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_medico INT,
    consultorio INT,
    cama INT,
    fecha_ingreso DATE,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);

-- Inserciones de prueba
INSERT INTO Pacientes (nombre, apellidos, direccion, colonia, estado, codigo_postal, telefono, fecha_nacimiento) VALUES
('Juan', 'Pérez López', 'Calle 1 #123', 'Centro', 'CDMX', '01000', '5551234567', '1990-05-15'),
('María', 'Gómez Torres', 'Av. Reforma #45', 'Roma', 'CDMX', '06700', '5559876543', '1985-09-23');

INSERT INTO Medicos (nombre, apellidos, telefono, especialidad) VALUES
('Carlos', 'Ramírez Fernández', '5551122334', 'Cardiología'),
('Ana', 'López Méndez', '5555566778', 'Pediatría');

INSERT INTO Ingresos (id_paciente, id_medico, consultorio, cama, fecha_ingreso) VALUES
(1, 1, 101, 5, '2024-03-01'),
(2, 2, 202, 10, '2024-03-02');

-- Consultas básicas
SELECT * FROM Pacientes;
SELECT * FROM Medicos;
SELECT * FROM Ingresos;
SELECT nombre, apellidos FROM Pacientes WHERE estado = 'CDMX';
SELECT Pacientes.nombre, Medicos.nombre AS medico, fecha_ingreso FROM Ingresos
JOIN Pacientes ON Ingresos.id_paciente = Pacientes.id_paciente
JOIN Medicos ON Ingresos.id_medico = Medicos.id_medico;
