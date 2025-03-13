CREATE DATABASE IF NOT EXISTS sistema_sismos;
USE sistema_sismos;

-- Tabla principal de eventos sísmicos
CREATE TABLE sismos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP,
    duracion FLOAT,
    latitud DECIMAL(10,6),
    longitud DECIMAL(10,6),
    magnitud FLOAT,
    profundidad FLOAT,
    zona VARCHAR(255),
    fuente ENUM('API_SSN', 'Manual')
);

-- Tabla de epicentros
CREATE TABLE epicentros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sismo_id INT,
    descripcion TEXT,
    FOREIGN KEY (sismo_id) REFERENCES sismos(id) ON DELETE CASCADE
);

-- Tabla de zonas de impacto
CREATE TABLE zonas_impacto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sismo_id INT,
    radio_km FLOAT,
    descripcion TEXT,
    FOREIGN KEY (sismo_id) REFERENCES sismos(id) ON DELETE CASCADE
);

-- Tabla de réplicas de sismos
CREATE TABLE replicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sismo_origen INT,
    sismo_replica INT,
    diferencia_tiempo FLOAT, -- Diferencia en horas o minutos
    distancia_km FLOAT, -- Distancia entre eventos sísmicos
    FOREIGN KEY (sismo_origen) REFERENCES sismos(id) ON DELETE CASCADE,
    FOREIGN KEY (sismo_replica) REFERENCES sismos(id) ON DELETE CASCADE
);

-- Tabla de coordenadas geográficas para visualización en mapas
CREATE TABLE mapa_geografico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sismo_id INT,
    tipo ENUM('epicentro', 'zona_impacto'),
    coordenadas TEXT, -- JSON con latitudes y longitudes
    FOREIGN KEY (sismo_id) REFERENCES sismos(id) ON DELETE CASCADE
);

-- Tabla para predicciones de actividad sísmica
CREATE TABLE predicciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zona VARCHAR(255),
    probabilidad ENUM('baja', 'moderada', 'alta'),
    modelo_usado VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de series temporales de datos sísmicos
CREATE TABLE series_temporales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sismo_id INT,
    datos TEXT, -- JSON con datos históricos de actividad sísmica
    FOREIGN KEY (sismo_id) REFERENCES sismos(id) ON DELETE CASCADE
);

-- Tabla de historial de consultas realizadas
CREATE TABLE consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(255),
    parametros TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para exportaciones en CSV o JSON
CREATE TABLE exportaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(255),
    formato ENUM('CSV', 'JSON'),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
