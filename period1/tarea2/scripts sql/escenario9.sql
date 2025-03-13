CREATE DATABASE IF NOT EXISTS sistema_grafos;
USE sistema_grafos;

-- Tabla de noticias
CREATE TABLE noticias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fuente VARCHAR(500), -- URL, API o archivo
    fecha_publicacion TIMESTAMP,
    texto TEXT, -- Texto procesado sin stopwords
    idioma VARCHAR(10)
);

-- Tabla de entidades (personas, lugares, eventos, etc.)
CREATE TABLE entidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('persona', 'organización', 'evento', 'ubicación', 'otro'),
    nombre VARCHAR(255) UNIQUE
);

-- Tabla de relaciones entre entidades
CREATE TABLE relaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entidad_origen INT,
    entidad_destino INT,
    tipo_relacion VARCHAR(255), -- Ejemplo: "trabaja_en", "ubicado_en"
    confianza FLOAT, -- Nivel de confianza basado en PLN
    FOREIGN KEY (entidad_origen) REFERENCES entidades(id),
    FOREIGN KEY (entidad_destino) REFERENCES entidades(id)
);

-- Tabla de grafos generados a partir de noticias
CREATE TABLE grafos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    noticia_id INT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (noticia_id) REFERENCES noticias(id) ON DELETE CASCADE
);

-- Tabla de nodos dentro de cada grafo
CREATE TABLE nodos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    grafo_id INT,
    entidad_id INT,
    tipo VARCHAR(255), -- Puede heredar el tipo de la entidad
    propiedades JSON, -- Información adicional del nodo
    FOREIGN KEY (grafo_id) REFERENCES grafos(id) ON DELETE CASCADE,
    FOREIGN KEY (entidad_id) REFERENCES entidades(id) ON DELETE CASCADE
);

-- Tabla de aristas para conectar nodos en los grafos
CREATE TABLE aristas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    grafo_id INT,
    nodo_origen INT,
    nodo_destino INT,
    peso FLOAT, -- Relevancia de la relación
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grafo_id) REFERENCES grafos(id) ON DELETE CASCADE,
    FOREIGN KEY (nodo_origen) REFERENCES nodos(id) ON DELETE CASCADE,
    FOREIGN KEY (nodo_destino) REFERENCES nodos(id) ON DELETE CASCADE
);

-- Tabla de análisis semántico (temas y sentimientos)
CREATE TABLE analisis_semanico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    noticia_id INT,
    tema_principal VARCHAR(255),
    sentimiento ENUM('positivo', 'negativo', 'neutro'),
    FOREIGN KEY (noticia_id) REFERENCES noticias(id) ON DELETE CASCADE
);

-- Tabla para almacenar el historial de consultas realizadas
CREATE TABLE historial_consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(255), -- Puede ser un identificador de usuario externo
    consulta TEXT, -- Búsqueda realizada
    fecha_consulta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de exportaciones en distintos formatos (RDF, JSON-LD, Neo4j)
CREATE TABLE exportaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    grafo_id INT,
    usuario VARCHAR(255),
    formato ENUM('RDF', 'JSON-LD', 'Neo4j'),
    fecha_exportacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grafo_id) REFERENCES grafos(id) ON DELETE CASCADE
);
