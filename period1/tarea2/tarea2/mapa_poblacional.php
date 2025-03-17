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

$sql = "SELECT nom_ent, 
    SUM(pobtot) AS pobtot, 
    SUM(pobfem) AS pobfem, 
    SUM(pobmas) AS pobmas 
    FROM inegi_clean 
    GROUP BY nom_ent";
$result = $conn->query($sql);

$poblacion = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $poblacion[] = $row;
    }
}
$conn->close();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gráfica de Población de México</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

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
        #map {
            height: 600px;
            width: 80%;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        #chart-container {
            width: 80%;
        }
    </style>
</head>
<body>
    <h2>Mapa de Población de México</h2>
    <div id="map"></div>
    <h2>Gráfica de Población de México</h2>
    <div id="chart-container">
        <canvas id="poblacionChart"></canvas>
    </div>
    <script>
        var poblacion = <?php echo json_encode($poblacion); ?>;
        console.log(poblacion);

        var estados = [];
        var poblaciones = [];

        poblacion.forEach(function(entidad) {
            estados.push(entidad.nom_ent);
            poblaciones.push(entidad.pobtot);
        });

        var ctx = document.getElementById('poblacionChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: estados,
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

    
    <script>
        var map = L.map('map').setView([23.6345, -102.5528], 5); // Centro de México
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        var poblacion = <?php echo json_encode($poblacion); ?>;
        
        //console.log(poblacion[14].nom_ent)
        poblacion[14].nom_ent = "méxico"                // Cambiar el nombre del estado de mexico por los acentos
        //console.log(poblacion[8].nom_ent)
        poblacion[8].nom_ent = "ciudad de méxico"       // Cambiar el nombre de la ciudad de méxico por los acentos

        // Diccionario para la gráfica
        var estados = [];
        var poblaciones = [];

        fetch("mexicoHigh.json")
            .then(response => response.json())
            .then(geojsonData => {
                L.geoJSON(geojsonData, {
                    style: function (feature) {
                        return {
                            fillColor: "lightblue",
                            weight: 2,
                            opacity: 1,
                            color: "blue",
                            fillOpacity: 0.5
                        };
                    },
                    
                    onEachFeature: function (feature, layer) {
                    
                        var estado = feature.properties.name;
                        for (var j = 31; j >= 0; j--) {
                            if (poblacion[j].nom_ent.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase() === estado.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase()) {
                                var pobtot = poblacion[j].pobtot;
                                break;
                            }
                        }    

                        // Agregar a la gráfica si la población está disponible
                        if (pobtot !== "No disponible") {
                            estados.push(estado);
                            poblaciones.push(pobtot);
                        }

                        // Agregar popup con la población
                        layer.bindPopup("<b>" + estado + "</b><br>Población: " + (pobtot !== "No disponible" ? parseInt(pobtot).toLocaleString() : "No disponibleeeee"));
                    }
                }).addTo(map);

                
            })
            .catch(error => console.error("Error cargando mexicoHigh.json:", error));
    </script>

</body>
</html>