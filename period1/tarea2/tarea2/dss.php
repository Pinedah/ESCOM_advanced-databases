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

// Obtener datos de sismos
$sql_sismos = "SELECT referencia_de_localizacion, latitud, longitud, COUNT(*) as num_sismos 
               FROM ssn_clean 
               WHERE magnitud > 6 
               GROUP BY referencia_de_localizacion, latitud, longitud";
$result_sismos = $conn->query($sql_sismos);

$sismos = [];
if ($result_sismos->num_rows > 0) {
    while ($row = $result_sismos->fetch_assoc()) {
        $sismos[] = $row;
    }
}

// Obtener datos de población
$sql_poblacion = "SELECT nom_ent, latitud, longitud, pobtot FROM inegi_clean WHERE pobtot > 100000";
$result_poblacion = $conn->query($sql_poblacion);

$poblacion = [];
if ($result_poblacion->num_rows > 0) {
    while ($row = $result_poblacion->fetch_assoc()) {
        $poblacion[] = $row;
    }
}

$conn->close();

// Seleccionar ubicaciones específicas para los edificios
$edificios = [
    ['latitud' => 19.432608, 'longitud' => -99.133209, 'nombre' => 'Ciudad de México'], // Ciudad de México
    ['latitud' => 25.686614, 'longitud' => -100.316113, 'nombre' => 'Monterrey, Nuevo León'], // Monterrey, Nuevo León
    ['latitud' => 25.67507, 'longitud' => -100.31847, 'nombre' => 'San Nicolás de los Garza, Nuevo León'], // San Nicolás de los Garza, Nuevo León
    ['latitud' => 21.161908, 'longitud' => -86.851528, 'nombre' => 'Cancún, Quintana Roo'] // Cancún, Quintana Roo
];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa de Sismos y Población</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f9;
        }
        #map {
            height: 600px;
            width: 80%;
            margin: 20px auto;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        #chart-container {
            width: 80%;
            margin: 20px auto;
        }
        .chart {
            margin-bottom: 40px;
        }
    </style>
</head>
<body>
    <h2>Mapa de Sismos y Población</h2>
    <div id="map"></div>

    <!-- Gráficas 
    <h2>Análisis de Sismos por Estado</h2>
    <div id="chart-container">
        <div class="chart">
            <canvas id="sismosChart"></canvas>
        </div>
        <h2>Análisis de Población por Estado</h2>
        <div class="chart">
            <canvas id="poblacionChart"></canvas>
        </div>
    </div>
    -->

    <script>
        var map = L.map('map').setView([23.6345, -102.5528], 5); // Centro de México
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        var sismos = <?php echo json_encode($sismos); ?>;
        var poblacion = <?php echo json_encode($poblacion); ?>;
        var edificios = <?php echo json_encode($edificios); ?>;

        console.log("Sismos:", sismos);
        console.log("Población:", poblacion);
        console.log("Edificios:", edificios);

        // Agregar marcadores de sismos
        sismos.forEach(function(sismo) {
            L.circleMarker([sismo.latitud, sismo.longitud], {
                radius: 5,
                color: "blue",
                fillColor: "blue",
                fillOpacity: 0.5
            }).addTo(map).bindPopup("Sismo: " + sismo.referencia_de_localizacion + " - " + sismo.num_sismos + " sismos");
        });

        // Agregar marcadores de población
        poblacion.forEach(function(entidad) {
            L.circleMarker([entidad.latitud, entidad.longitud], {
                radius: 5,
                color: "blue",
                fillColor: "blue",
                fillOpacity: 0.5
            }).addTo(map).bindPopup("Población: " + entidad.nom_ent + " - " + entidad.pobtot + " habitantes");
        });

        // Agregar marcadores de edificios
        edificios.forEach(function(edificio) {
            L.marker([edificio.latitud, edificio.longitud], {
                icon: L.icon({
                    iconUrl: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
                    iconSize: [32, 32],
                    iconAnchor: [16, 32],
                    popupAnchor: [0, -32]
                })
            }).addTo(map).bindPopup("Edificio en: " + edificio.nombre);
        });

        // Crear la gráfica de sismos por estado
        var ctxSismos = document.getElementById('sismosChart').getContext('2d');
        var estadosSismos = sismos.map(function(sismo) { return sismo.referencia_de_localizacion; });
        var numSismos = sismos.map(function(sismo) { return sismo.num_sismos; });

        new Chart(ctxSismos, {
            type: 'bar',
            data: {
                labels: estadosSismos,
                datasets: [{
                    label: 'Número de Sismos',
                    data: numSismos,
                    backgroundColor: 'rgba(255, 99, 132, 0.5)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        //console.log("entidad", entidad);

        // Crear la gráfica de población por estado
        var ctxPoblacion = document.getElementById('poblacionChart').getContext('2d');
        var estadosPoblacion = poblacion.map(function(entidad) { return entidad.nom_ent; });
        var poblaciones = poblacion.map(function(entidad) { return entidad.pobtot; });

        console.log(estadosPoblacion);

        new Chart(ctxPoblacion, {
            type: 'bar',
            data: {
                labels: estadosPoblacion,
                datasets: [{
                    label: 'Población Total',
                    data: poblaciones,
                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
