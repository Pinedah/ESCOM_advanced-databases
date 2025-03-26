CREATE TABLE
    IF NOT EXISTS registros_sismos (
        id SERIAL PRIMARY KEY,
        fecha DATE,
        hora TIME,
        magnitud NUMERIC(3, 1),
        latitud NUMERIC(6, 3),
        longitud NUMERIC(6, 3),
        profundidad NUMERIC(6, 1),
        referencia_localizacion VARCHAR(255),
        fecha_utc DATE,
        hora_utc TIME,
        estatus VARCHAR(50)
    );

CREATE TABLE
    public.economia_normalizada (
        entidad text,
        nombre_entidad text,
        municipio text,
        nombre_municipio text,
        codigo text,
        descripcion_actividad text,
        clasificacion text,
        produccion_bruta_total numeric(15, 3),
        consumo_intermedio numeric(15, 3),
        total_gastos numeric(15, 3),
        total_ingresos numeric(15, 3),
        tasa_rentabilidad_promedio numeric(15, 3),
        salario_promedio_diario_persona_operativa numeric(15, 3),
        salario_promedio_diario_persona_administrativa numeric(15, 3)
    );

CREATE TABLE
    datos_inegi (
        id SERIAL PRIMARY KEY,
        entidad_codigo CHAR(2),
        entidad_nombre VARCHAR(50),
        municipio_codigo CHAR(3),
        municipio_nombre VARCHAR(100),
        localidad_codigo CHAR(4),
        localidad_nombre VARCHAR(100),
        longitud DECIMAL(9, 6),
        latitud DECIMAL(9, 6),
        altitud INT,
        poblacion_total INT,
        viviendas_totales INT,
        viviendas_habitadas INT,
        viviendas_deshabitadas INT,
        tamano_localidad INT
    );