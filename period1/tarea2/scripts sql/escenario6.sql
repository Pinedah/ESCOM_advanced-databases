-- 1️⃣ Crear la base de datos
CREATE DATABASE SistemaNutricional;
USE SistemaNutricional;

-- 2️⃣ Crear la tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(15),
    rol ENUM('paciente', 'nutricionista') NOT NULL
);

-- 3️⃣ Crear la tabla de nutricionistas
CREATE TABLE nutricionistas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL,
    numero_licencia VARCHAR(50) UNIQUE NOT NULL,
    experiencia TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 4️⃣ Crear la tabla de pacientes
CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL,
    altura DECIMAL(5,2), -- En metros
    peso_actual DECIMAL(5,2), -- En kg
    peso_objetivo DECIMAL(5,2), -- En kg
    restricciones TEXT,
    preferencias TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 5️⃣ Crear la tabla de planes de dieta
CREATE TABLE planes_dieta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    duracion_dias INT NOT NULL,
    categorias_permitidas TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6️⃣ Crear la tabla de planes de dieta personalizados para pacientes
CREATE TABLE planes_pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    plan_id INT NOT NULL,
    nutricionista_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('activo', 'completado', 'cancelado') DEFAULT 'activo',
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES planes_dieta(id) ON DELETE CASCADE,
    FOREIGN KEY (nutricionista_id) REFERENCES nutricionistas(id) ON DELETE CASCADE
);

-- 7️⃣ Crear la tabla de alimentos y su información nutricional
CREATE TABLE alimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    calorias INT NOT NULL,
    proteinas DECIMAL(5,2) NOT NULL,
    grasas DECIMAL(5,2) NOT NULL,
    carbohidratos DECIMAL(5,2) NOT NULL,
    categoria VARCHAR(255) NOT NULL
);

-- 8️⃣ Crear la tabla de comidas diarias registradas por el paciente
CREATE TABLE comidas_diarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    fecha DATE NOT NULL,
    alimento_id INT NOT NULL,
    cantidad DECIMAL(5,2) NOT NULL, -- en gramos
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (alimento_id) REFERENCES alimentos(id) ON DELETE CASCADE
);

-- 9️⃣ Crear la tabla de progreso del paciente
CREATE TABLE progreso_paciente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    fecha DATE NOT NULL,
    peso DECIMAL(5,2),
    calorias_consumidas INT NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE
);

-- 🔟 Crear la tabla de evaluaciones y retroalimentación del nutricionista
CREATE TABLE evaluaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    nutricionista_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (nutricionista_id) REFERENCES nutricionistas(id) ON DELETE CASCADE
);

-- 1️⃣1️⃣ Insertar datos de ejemplo
-- Insertar usuarios
INSERT INTO usuarios (nombre, email, contrasena, fecha_nacimiento, telefono, rol) VALUES
('Dr. Luis Mendoza', 'luis.mendoza@mail.com', 'nutri123', '1980-05-14', '555-1111', 'nutricionista'),
('Ana Torres', 'ana.torres@mail.com', 'paciente123', '1995-08-25', '555-2222', 'paciente');

-- Obtener ID del nutricionista
SET @nutricionista_id = (SELECT id FROM usuarios WHERE email = 'luis.mendoza@mail.com');

-- Insertar nutricionista
INSERT INTO nutricionistas (usuario_id, numero_licencia, experiencia) VALUES
(@nutricionista_id, 'NUT-987654', 'Especialista en control de peso');

-- Obtener ID del paciente
SET @paciente_id = (SELECT id FROM usuarios WHERE email = 'ana.torres@mail.com');

-- Insertar paciente
INSERT INTO pacientes (usuario_id, altura, peso_actual, peso_objetivo, restricciones, preferencias) VALUES
(@paciente_id, 1.65, 70.0, 60.0, 'Intolerancia a la lactosa', 'Dieta vegetariana');

-- Insertar plan de dieta
INSERT INTO planes_dieta (nombre, descripcion, duracion_dias, categorias_permitidas) VALUES
('Dieta Baja en Carbohidratos', 'Plan de dieta para reducir la ingesta de carbohidratos y mejorar el metabolismo.', 30, 'Proteínas, Verduras, Grasas saludables');

-- Obtener ID del plan de dieta
SET @plan_id = (SELECT id FROM planes_dieta WHERE nombre = 'Dieta Baja en Carbohidratos');

-- Asignar plan de dieta al paciente
INSERT INTO planes_pacientes (paciente_id, plan_id, nutricionista_id, fecha_inicio, fecha_fin) VALUES
(@paciente_id, @plan_id, @nutricionista_id, '2025-03-10', '2025-04-10');

-- Insertar alimentos
INSERT INTO alimentos (nombre, calorias, proteinas, grasas, carbohidratos, categoria) VALUES
('Pechuga de Pollo', 165, 31.0, 3.6, 0.0, 'Proteínas'),
('Aguacate', 160, 2.0, 15.0, 9.0, 'Grasas saludables'),
('Brócoli', 55, 3.7, 0.6, 11.2, 'Verduras');

-- Insertar comida diaria del paciente
INSERT INTO comidas_diarias (paciente_id, fecha, alimento_id, cantidad) VALUES
(@paciente_id, '2025-03-10', (SELECT id FROM alimentos WHERE nombre = 'Pechuga de Pollo'), 150);

-- Insertar progreso del paciente
INSERT INTO progreso_paciente (paciente_id, fecha, peso, calorias_consumidas) VALUES
(@paciente_id, '2025-03-10', 69.5, 1600);

-- Insertar evaluación del nutricionista
INSERT INTO evaluaciones (paciente_id, nutricionista_id, observaciones) VALUES
(@paciente_id, @nutricionista_id, 'El paciente ha reducido peso de forma estable, se recomienda seguir con el plan.');

-- 🔎 1️⃣2️⃣ Consultas de prueba

-- Obtener el plan de dieta de un paciente
SELECT u.nombre AS paciente, pd.nombre AS plan_dieta, pp.fecha_inicio, pp.fecha_fin, pp.estado
FROM planes_pacientes pp
JOIN planes_dieta pd ON pp.plan_id = pd.id
JOIN pacientes p ON pp.paciente_id = p.id
JOIN usuarios u ON p.usuario_id = u.id
WHERE p.id = @paciente_id;

-- Obtener los alimentos consumidos por un paciente en un día
SELECT u.nombre AS paciente, a.nombre AS alimento, cd.cantidad, a.calorias, a.proteinas, a.grasas, a.carbohidratos
FROM comidas_diarias cd
JOIN alimentos a ON cd.alimento_id = a.id
JOIN pacientes p ON cd.paciente_id = p.id
JOIN usuarios u ON p.usuario_id = u.id
WHERE cd.fecha = '2025-03-10' AND p.id = @paciente_id;
