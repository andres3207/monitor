<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Sistema de Monitoreo de Humedad y Temperatura</title>
 	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />
 	
 	<script src="<?php echo base_url();?>js/highcharts.js" ></script>
 	<script src="<?php echo base_url();?>js/modules/exporting.js" type="text/javascript" ></script>
 	
 	
	<!-- <script src="http://code.highcharts.com/highcharts.js"></script>
	<script src="http://code.highcharts.com/modules/exporting.js"></script> -->
	



</head>
<script type="text/javascript">
var chart;
	$(document).ready(function() {
		var fechas1 = new Array();
		var temperaturas1 = new Array();
		var humedades1 = new Array();
		var n1=$("#cant_reg1").val();

		var fechas2 = new Array();
		var temperaturas2 = new Array();
		var humedades2 = new Array();
		var n2=$("#cant_reg2").val();


		//console.log(n);
		for (var i = 0; i < n1 ; i++) {
			fechas1[i]=$("#fecha1-"+i).val();
			temperaturas1[i]=parseFloat($("#temp1-"+i).val());
			humedades1[i]=parseFloat($("#hum1-"+i).val());
		}

		for (var i = 0; i < n2 ; i++) {
			fechas2[i]=$("#fecha2-"+i).val();
			temperaturas2[i]=parseFloat($("#temp2-"+i).val());
			humedades2[i]=parseFloat($("#hum2-"+i).val());
		}

		//console.log(temperaturas);

		chart = new Highcharts.Chart({
			chart: {
				renderTo: 'graficoTemp1', 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Temperatura'	// Titulo (Opcional)
			},
			subtitle: {
				text: 'Mes Actual'		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas1,
				// Pongo el título para el eje de las 'X'
				title: {
					text: 'Fechas'
				}
			},
			yAxis: {
				// Pongo el título para el eje de las 'Y'
				title: {
					text: 'Temperatura [°C]'
				}
			},
			// Doy formato al la "cajita" que sale al pasar el ratón por encima de la gráfica
			tooltip: {
				enabled: true,
				formatter: function() {
					return '<b>'+ this.series.name +'</b><br/>'+
						this.x +': '+ this.y +' '+this.series.name;
				}
			},
			// Doy opciones a la gráfica
			plotOptions: {
				line: {
					dataLabels: {
						enabled: false
					},
					enableMouseTracking: true
				}
			},
			// Doy los datos de la gráfica para dibujarlas
			series: [{
		                name: 'Temperatura',
		                data: temperaturas1
		            }],
		});	
	chart2 = new Highcharts.Chart({
			chart: {
				renderTo: 'graficoHum1', 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Humedad'	// Titulo (Opcional)
			},
			subtitle: {
				text: 'Mes Actual'		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas1,
				// Pongo el título para el eje de las 'X'
				title: {
					text: 'Fechas'
				}
			},
			yAxis: {
				// Pongo el título para el eje de las 'Y'
				title: {
					text: 'Humedad [%]'
				}
			},
			// Doy formato al la "cajita" que sale al pasar el ratón por encima de la gráfica
			tooltip: {
				enabled: true,
				formatter: function() {
					return '<b>'+ this.series.name +'</b><br/>'+
						this.x +': '+ this.y +' '+this.series.name;
				}
			},
			// Doy opciones a la gráfica
			plotOptions: {
				line: {
					dataLabels: {
						enabled: false
					},
					enableMouseTracking: true
				}
			},
			// Doy los datos de la gráfica para dibujarlas
			series: [{
		                name: 'Humedad',
		                data: humedades1
		            }],
		});	
	chart3 = new Highcharts.Chart({
			chart: {
				renderTo: 'graficoTemp2', 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Temperatura'	// Titulo (Opcional)
			},
			subtitle: {
				text: 'Mes Anterior'		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas2,
				// Pongo el título para el eje de las 'X'
				title: {
					text: 'Fechas'
				}
			},
			yAxis: {
				// Pongo el título para el eje de las 'Y'
				title: {
					text: 'Temperatura [°C]'
				}
			},
			// Doy formato al la "cajita" que sale al pasar el ratón por encima de la gráfica
			tooltip: {
				enabled: true,
				formatter: function() {
					return '<b>'+ this.series.name +'</b><br/>'+
						this.x +': '+ this.y +' '+this.series.name;
				}
			},
			// Doy opciones a la gráfica
			plotOptions: {
				line: {
					dataLabels: {
						enabled: false
					},
					enableMouseTracking: true
				}
			},
			// Doy los datos de la gráfica para dibujarlas
			series: [{
		                name: 'Temperatura',
		                data: temperaturas2
		            }],
		});	
	chart4 = new Highcharts.Chart({
			chart: {
				renderTo: 'graficoHum2', 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Humedad'	// Titulo (Opcional)
			},
			subtitle: {
				text: 'Mes Anterior'		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas2,
				// Pongo el título para el eje de las 'X'
				title: {
					text: 'Fechas'
				}
			},
			yAxis: {
				// Pongo el título para el eje de las 'Y'
				title: {
					text: 'Humedad [%]'
				}
			},
			// Doy formato al la "cajita" que sale al pasar el ratón por encima de la gráfica
			tooltip: {
				enabled: true,
				formatter: function() {
					return '<b>'+ this.series.name +'</b><br/>'+
						this.x +': '+ this.y +' '+this.series.name;
				}
			},
			// Doy opciones a la gráfica
			plotOptions: {
				line: {
					dataLabels: {
						enabled: false
					},
					enableMouseTracking: true
				}
			},
			// Doy los datos de la gráfica para dibujarlas
			series: [{
		                name: 'Humedad',
		                data: humedades2
		            }],
		});	
	});
</script>
<style type="text/css">

</style>



<body>
<?php
echo "<input type='text' id='cant_sensor' name='cant_sensor' value='".$datos["cant_sensores"]."' hidden>";

echo "<div class='container'><h2>Graficos del Mes Actual:</h2></div>";
for ($i=0; $i < $datos["cant_sensores"]; $i++) { 
	echo "<div id='graficoTemp_act-".$i."' style='width: 100%; height: 500px; margin: 0 auto'></div>";
	echo "<br></br>";

	echo "<div id='graficoHum_act-".$i."' style='width: 100%; height: 500px; margin: 0 auto'></div>";

	echo "<br>";
	echo "<br>";
}


echo "<div class='container'><h2>Graficos del Mes Anterior:</h2></div>";
for ($i=0; $i < $datos["cant_sensores"]; $i++) { 
	echo "<div id='graficoTemp_ant-".$i."' style='width: 100%; height: 500px; margin: 0 auto'></div>";
	echo "<br></br>";

	echo "<div id='graficoHum_ant-".$i."' style='width: 100%; height: 500px; margin: 0 auto'></div>";

	echo "<br>";
	echo "<br>";
}


for ($i=0; $i <$datos["cant_sensores"] ; $i++) { 
	$cant_reg_act=count($datos["datos_actual"][$i]);
	$cant_reg_ant=count($datos["datos_anterior"][$i]);
	echo "<input type='text' id='cant_reg_act-".$i."' name='cant_reg_act-".$i."' value='".$cant_reg_act."' >";
	for ($j=0; $j < $cant_reg_act ; $j++) { 
		echo "<input type='text' id='id_act-".$j."' name='id_act-".$j."' value='".$datos["datos_actual"][$i][$j]["id"]."' >";
		echo "<input type='text' id='temp_act-".$j."' name='temp_act-".$j."' value='".$datos["datos_actual"][$i][$j]["temperatura"]."' >";
		echo "<input type='text' id='hum_act-".$j."' name='hum_act-".$j."' value='".$datos["datos_actual"][$i][$j]["humedad"]."' >";
		echo "<input type='text' id='fecha_act-".$j."' name='fecha_act-".$j."' value='".$datos["datos_actual"][$i][$j]["cuando"]."' >";
	}


	echo "<input type='text' id='cant_reg_ant-".$i."' name='cant_reg_ant-".$i."' value='".$cant_reg_ant."' >";

	for ($j=0; $j < $cant_reg_ant; $j++) { 
		echo "<input type='text' id='id_ant-".$j."' name='id_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["id"]."' >";
		echo "<input type='text' id='temp_ant-".$j."' name='temp_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["temperatura"]."' >";
		echo "<input type='text' id='hum_ant-".$j."' name='hum_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["humedad"]."' >";
		echo "<input type='text' id='fecha_ant-".$j."' name='fecha_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["cuando"]."' >";
	}
}
?>




</body>



