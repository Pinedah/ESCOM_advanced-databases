import csv

def csv_a_sql(nombre_archivo_csv, nombre_archivo_sql, nombre_tabla):
    """
    Convierte un archivo CSV a un script SQL para crear una tabla e insertar datos.

    Args:
        nombre_archivo_csv: La ruta al archivo CSV de entrada.
        nombre_archivo_sql: La ruta al archivo SQL de salida.
        nombre_tabla: El nombre de la tabla SQL que se creará.
    """

    with open(nombre_archivo_csv, 'r', encoding='utf-8') as archivo_csv, open(nombre_archivo_sql, 'w', encoding='utf-8') as archivo_sql:
        lector_csv = csv.reader(archivo_csv)
        
        # Obtener la primera fila para los nombres de las columnas
        encabezado = next(lector_csv)

        # Crear la sentencia CREATE TABLE
        archivo_sql.write(f"CREATE TABLE {nombre_tabla} (\n")
        for nombre_columna in encabezado:
            # Limpiar y formatear el nombre de la columna para SQL
            nombre_columna = nombre_columna.replace(" ", "_").lower()  # Ejemplo: "Nombre Cliente" -> "nombre_cliente"
            archivo_sql.write(f"    {nombre_columna} TEXT,\n")  # Asume tipo TEXT, puedes ajustarlo
        archivo_sql.write(");\n\n")

        # Crear las sentencias INSERT INTO
        for fila in lector_csv:
            archivo_sql.write(f"INSERT INTO {nombre_tabla} (")
            archivo_sql.write(", ".join(f'"{col.replace(" ", "_").lower()}"' for col in encabezado))  # Columnas
            archivo_sql.write(") VALUES (")
            archivo_sql.write(", ".join(f"'{valor}'" for valor in fila))  # Valores
            archivo_sql.write(");\n")

# Ejemplo de uso
csv_a_sql("C:\\Users\\Dell Latitude\\Documents\\GitHub\\ESCOM_advanced-databases\\period1\\tarea1\\SSNMX_clean.csv", "SSN.sql", "SNN")