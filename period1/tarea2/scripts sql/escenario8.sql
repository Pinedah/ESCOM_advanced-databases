-- Script SQL para el Sistema de Búsqueda y Recomendación de Artículos Científicos

CREATE DATABASE IF NOT EXISTS BusquedaArticulos;
USE BusquedaArticulos;

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('estudiante', 'investigador', 'administrador') NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Preferencias de Usuarios
CREATE TABLE preferencias_usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tema VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de Artículos Científicos
CREATE TABLE articulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(500) NOT NULL,
    autores TEXT NOT NULL,
    anio_publicacion INT NOT NULL,
    resumen TEXT,
    palabras_clave TEXT,
    revista VARCHAR(255),
    enlace VARCHAR(500),
    fuente ENUM('CrossRef', 'SemanticScholar') NOT NULL
);

-- Tabla de Historial de Búsquedas
CREATE TABLE historial_busquedas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    termino_busqueda VARCHAR(500) NOT NULL,
    fecha_busqueda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    filtros_aplicados TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de Resultados de Búsqueda
CREATE TABLE resultados_busqueda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    busqueda_id INT NOT NULL,
    articulo_id INT NOT NULL,
    FOREIGN KEY (busqueda_id) REFERENCES historial_busquedas(id) ON DELETE CASCADE,
    FOREIGN KEY (articulo_id) REFERENCES articulos(id) ON DELETE CASCADE
);

-- Tabla de Favoritos
CREATE TABLE favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    articulo_id INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (articulo_id) REFERENCES articulos(id) ON DELETE CASCADE
);

-- Tabla de Recomendaciones
CREATE TABLE recomendaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    articulo_id INT NOT NULL,
    motivo TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (articulo_id) REFERENCES articulos(id) ON DELETE CASCADE
);

-- Ejemplo de inserciones
INSERT INTO usuarios (nombre, email, contrasena, rol) VALUES
('Juan Pérez', 'juan@example.com', 'hashed_password', 'estudiante'),
('Ana Gómez', 'ana@example.com', 'hashed_password', 'investigador'),
('Admin', 'admin@example.com', 'hashed_password', 'administrador');

INSERT INTO articulos (titulo, autores, anio_publicacion, resumen, palabras_clave, revista, enlace, fuente) VALUES
('Machine Learning Basics', 'John Doe, Jane Smith', 2023, 'Introducción a ML...', 'inteligencia artificial, machine learning', 'AI Journal', 'https://example.com/article1', 'CrossRef'),
('Quantum Computing Overview', 'Alice Brown', 2022, 'Explicación sobre computación cuántica...', 'física cuántica, computación', 'Quantum Journal', 'https://example.com/article2', 'SemanticScholar');

-- Consultas de prueba
-- 1. Obtener el historial de búsquedas de un usuario
SELECT * FROM historial_busquedas WHERE usuario_id = 1;

-- 2. Ver los artículos favoritos de un usuario
SELECT a.* FROM favoritos f JOIN articulos a ON f.articulo_id = a.id WHERE f.usuario_id = 1;

-- 3. Mostrar recomendaciones para un usuario
SELECT a.*, r.motivo FROM recomendaciones r JOIN articulos a ON r.articulo_id = a.id WHERE r.usuario_id = 1;
