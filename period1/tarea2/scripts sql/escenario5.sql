-- 1️⃣ Crear la base de datos
CREATE DATABASE SistemaMedico;
USE SistemaMedico;

-- 2️⃣ Crear la tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(15),
    rol ENUM('paciente', 'medico', 'administrador') NOT NULL
);

-- 3️⃣ Crear la tabla de médicos
CREATE TABLE medicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL,
    especialidad VARCHAR(255) NOT NULL,
    numero_licencia VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 4️⃣ Crear la tabla de pacientes
CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL,
    alergias TEXT,
    enfermedades_previas TEXT,
    tratamientos_actuales TEXT,
    condiciones_heredadas TEXT,
    contacto_emergencia VARCHAR(255),
    medico_asignado INT,
    ultima_consulta TIMESTAMP,
    seguimiento TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (medico_asignado) REFERENCES medicos(id) ON DELETE SET NULL
);

-- 5️⃣ Crear la tabla de consultas médicas
CREATE TABLE consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id INT NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duracion INT,
    sintomas TEXT,
    observaciones TEXT,
    diagnostico TEXT,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE CASCADE
);

-- 6️⃣ Crear la tabla de recetas médicas
CREATE TABLE recetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id INT NOT NULL,
    medicamentos TEXT NOT NULL,
    indicaciones TEXT NOT NULL,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE CASCADE
);

-- 7️⃣ Crear la tabla de consentimientos informados
CREATE TABLE consentimientos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id INT NOT NULL,
    documento TEXT NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE CASCADE
);

-- 8️⃣ Crear la tabla de tickets de soporte
CREATE TABLE tickets_soporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    asunto VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    estado ENUM('abierto', 'en proceso', 'cerrado') NOT NULL DEFAULT 'abierto',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 9️⃣ Insertar datos de ejemplo
-- Insertar usuarios
INSERT INTO usuarios (nombre, email, contrasena, fecha_nacimiento, telefono, rol) VALUES
('Juan Pérez', 'juan.perez@mail.com', '123456', '1985-06-15', '555-1234', 'paciente'),
('Dra. Ana Gómez', 'ana.gomez@mail.com', 'medico123', '1978-04-22', '555-5678', 'medico'),
('Carlos Ramírez', 'carlos.ramirez@mail.com', 'admin123', '1990-09-12', '555-8765', 'administrador');

-- Obtener el ID de la doctora
SET @medico_id = (SELECT id FROM usuarios WHERE email = 'ana.gomez@mail.com');

-- Insertar médicos
INSERT INTO medicos (usuario_id, especialidad, numero_licencia) VALUES
(@medico_id, 'Cardiología', 'MED-456789');

-- Obtener el ID del paciente Juan Pérez
SET @paciente_id = (SELECT id FROM usuarios WHERE email = 'juan.perez@mail.com');

-- Obtener el ID del médico recién insertado
SET @medico_asignado = (SELECT id FROM medicos WHERE usuario_id = @medico_id);

-- Insertar pacientes
INSERT INTO pacientes (usuario_id, alergias, enfermedades_previas, tratamientos_actuales, condiciones_heredadas, contacto_emergencia, medico_asignado, ultima_consulta, seguimiento)
VALUES (@paciente_id, 'Polen', 'Hipertensión', 'Atenolol', 'Historial de hipertensión', '555-9999', @medico_asignado, NOW(), 'Control de presión arterial');

-- Insertar consulta médica
INSERT INTO consultas (paciente_id, medico_id, fecha, duracion, sintomas, observaciones, diagnostico) VALUES
(@paciente_id, @medico_asignado, NOW(), 30, 'Dolor de cabeza y mareo', 'Presión arterial alta', 'Hipertensión controlada');

-- Obtener el ID de la consulta recién insertada
SET @consulta_id = (SELECT id FROM consultas WHERE paciente_id = @paciente_id ORDER BY fecha DESC LIMIT 1);

-- Insertar receta médica
INSERT INTO recetas (consulta_id, medicamentos, indicaciones) VALUES
(@consulta_id, 'Losartán 50mg', 'Tomar 1 tableta al día');

-- Insertar consentimiento informado
INSERT INTO consentimientos (consulta_id, documento, fecha) VALUES
(@consulta_id, 'Documento de consentimiento firmado por el paciente', NOW());

-- Insertar ticket de soporte
INSERT INTO tickets_soporte (usuario_id, asunto, descripcion, estado, fecha_creacion) VALUES
(@paciente_id, 'Problema con cita médica', 'No puedo cambiar la fecha de mi cita', 'abierto', NOW());

-- 🔎 10️⃣ Consultas de prueba

-- Obtener todos los pacientes con sus médicos asignados
SELECT p.id, u.nombre AS paciente, m.especialidad AS medico_asignado
FROM pacientes p
JOIN usuarios u ON p.usuario_id = u.id
LEFT JOIN medicos m ON p.medico_asignado = m.id;

-- Obtener todas las consultas médicas de un paciente específico
SELECT c.id, c.fecha, c.sintomas, c.diagnostico, u.nombre AS medico
FROM consultas c
JOIN medicos m ON c.medico_id = m.id
JOIN usuarios u ON m.usuario_id = u.id
WHERE c.paciente_id = @paciente_id;

-- Listar todas las recetas médicas junto con la información de la consulta asociada
SELECT r.id, r.medicamentos, r.indicaciones, c.fecha, u.nombre AS paciente
FROM recetas r
JOIN consultas c ON r.consulta_id = c.id
JOIN pacientes p ON c.paciente_id = p.id
JOIN usuarios u ON p.usuario_id = u.id;

-- Obtener todos los tickets de soporte abiertos
SELECT t.id, u.nombre AS usuario, t.asunto, t.estado, t.fecha_creacion
FROM tickets_soporte t
JOIN usuarios u ON t.usuario_id = u.id
WHERE t.estado = 'abierto';
