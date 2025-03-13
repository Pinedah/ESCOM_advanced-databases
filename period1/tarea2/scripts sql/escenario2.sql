CREATE DATABASE CendiBiblioteca;
USE CendiBiblioteca;

CREATE TABLE Alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100),
    escuela VARCHAR(50) DEFAULT 'CENDI IPN',
    ciclo_escolar VARCHAR(20)
);

CREATE TABLE Especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Editoriales (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(255),
    telefono VARCHAR(15)
);

CREATE TABLE Libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    paginas INT,
    id_especialidad INT,
    id_editorial INT,
    FOREIGN KEY (id_especialidad) REFERENCES Especialidades(id_especialidad),
    FOREIGN KEY (id_editorial) REFERENCES Editoriales(id_editorial)
);

CREATE TABLE Autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100)
);

CREATE TABLE LibroAutor (
    id_libro INT,
    id_autor INT,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);

CREATE TABLE Prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    id_libro INT,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
);

-- Inserciones de prueba
INSERT INTO Alumnos (nombre_completo, ciclo_escolar) VALUES
('Sofía Hernández', '2024-2025'),
('Carlos López', '2024-2025');

INSERT INTO Especialidades (nombre) VALUES
('Ciencia'),
('Historia');

INSERT INTO Editoriales (nombre, direccion, telefono) VALUES
('Editorial Alfa', 'Calle 123, CDMX', '5556789001'),
('Editorial Beta', 'Av. Reforma 456, CDMX', '5556789002');

INSERT INTO Libros (titulo, paginas, id_especialidad, id_editorial) VALUES
('El Universo', 300, 1, 1),
('Historia de México', 250, 2, 2);

INSERT INTO Autores (nombre, correo) VALUES
('Juan Pérez', 'juanp@example.com'),
('Ana Torres', 'anatorres@example.com');

INSERT INTO LibroAutor (id_libro, id_autor) VALUES
(1, 1),
(2, 2);

INSERT INTO Prestamos (id_alumno, id_libro, fecha_prestamo, fecha_devolucion) VALUES
(1, 1, '2024-03-01', '2024-03-10'),
(2, 2, '2024-03-02', '2024-03-12');

-- Consultas básicas
SELECT * FROM Alumnos;
SELECT * FROM Libros;
SELECT * FROM Editoriales;
SELECT nombre_completo FROM Alumnos WHERE ciclo_escolar = '2024-2025';
SELECT L.titulo, A.nombre FROM Libros L