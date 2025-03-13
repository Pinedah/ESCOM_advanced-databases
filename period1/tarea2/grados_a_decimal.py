import re

def dms_to_decimal(match):
    """
    Convert a coordinate string in DMS format to decimal degrees.
    Examples:
        "102°17'45.768\" W" -> -102.29605
        "21°52'47.362\" N" -> 21.87982
    """
    # Extract degrees, minutes, seconds, and direction
    
    #print("se encontro alguna chingadera")
    degrees = int(match.group(1))
    minutes = int(match.group(2))
    seconds = float(match.group(3))
    direction = match.group(4)
    
    # Convert to decimal degrees
    decimal = degrees + minutes/60 + seconds/3600
    
    # Apply negative sign for West and South
    if direction in ['W', 'S']:
        decimal = -decimal
        
    return str(round(decimal, 6))

def process_sql_file(input_file, output_file):
    """
    Read an SQL file, convert DMS coordinates to decimal degrees, and write the result to a new file.
    """
    chingaderas = 0
    #with open(input_file, "r") as f:
    #    sql = f.read()
    with open(input_file, 'r', encoding='utf-8') as f:
        sql = f.read()
    
    # Find all DMS coordinates in the SQL file

    for line in sql.split('\n'):
        #print("",line)
        pattern = r'(\d+)°(\d+)\'(\d+\.\d+)" ([NSEW])'
        match = re.search(pattern, line)

        if match:
            #print("matcheo alguna chingadera")
            decimal = dms_to_decimal(match)
            #print(decimal)
            new_line = re.sub(pattern, decimal, line)
            sql = sql.replace(line, new_line)
            #print(new_line)
        else:
            print("No se encontro ninguna coordenada")
            chingaderas += 1
    
    # Write the result to a new file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(sql)

    print("chingaderas no encontradas ", chingaderas)
        
# Usage example
if __name__ == "__main__":
    input_file = "inegi_nulls_degrees_mysql.sql"  # Replace with your SQL file path
    output_file = "output_decimal_coords2.sql"
    process_sql_file(input_file, output_file)