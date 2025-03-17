<?php
$servername = "localhost";
$username = "root"; // Cambia esto si tienes otro usuario
$password = "panke"; // Cambia esto si tienes contraseña
$dbname = "tarea2";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$magnitud_minima = isset($_GET['magnitud_minima']) ? $_GET['magnitud_minima'] : 7;

$sql = "SELECT latitud, longitud, magnitud FROM ssn_clean WHERE magnitud > ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("d", $magnitud_minima);
$stmt->execute();
$result = $stmt->get_result();

$sismos = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $sismos[] = $row;
    }
}

$sql_top15 = "SELECT latitud, longitud, magnitud, referencia_de_localizacion FROM ssn_clean ORDER BY magnitud DESC LIMIT 15";
$result_top15 = $conn->query($sql_top15);

$top15_sismos = [];
if ($result_top15->num_rows > 0) {
    while ($row = $result_top15->fetch_assoc()) {
        $top15_sismos[] = $row;
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa de Sismos</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f4f4f9;
        }
        h2 {
            margin-top: 20px;
            color: #333;
        }
        #form-container {
            margin: 20px 0;
        }
        #map {
            height: 600px;
            width: 80%;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        #chart-container {
            width: 80%;
            margin-bottom: 20px;
        }
        input[type="text"] {
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 10px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h2>Mapa de Sismos</h2>
    <div id="form-container">
        <form method="GET" action="">
            <label for="magnitud_minima">Magnitud mínima:</label>
            <input type="text" id="magnitud_minima" name="magnitud_minima" value="<?php echo htmlspecialchars($magnitud_minima); ?>">
            <input type="submit" value="Actualizar">
        </form>
    </div>
    <div id="map"></div>
    <div id="chart-container">
        <canvas id="top15Chart"></canvas>
    </div>
    <script>
        var map = L.map('map').setView([23.6345, -102.5528], 5); // Centro de México
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        var sismos = <?php echo json_encode($sismos); ?>;

        sismos.forEach(function(sismo) {
            var marker = L.circleMarker([sismo.latitud, sismo.longitud], {
                radius: sismo.magnitud * 2, // Tamaño según magnitud
                color: "red",
                fillColor: "red",
                fillOpacity: 0.5
            }).addTo(map);
            marker.bindTooltip("Magnitud: " + sismo.magnitud, { permanent: false, direction: "top" });
        });

        var top15Sismos = <?php echo json_encode($top15_sismos); ?>;
        var labels = top15Sismos.map(function(sismo) {
            return sismo.referencia_de_localizacion;
        });
        var data = top15Sismos.map(function(sismo) {
            return sismo.magnitud;
        });

        var ctx = document.getElementById('top15Chart').getContext('2d');
        var top15Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Magnitud',
                    data: data,
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                indexAxis: 'y',
                scales: {
                    x: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>