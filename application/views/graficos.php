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
		var fechas = new Array();
		var temperaturas = new Array();
		var humedades = new Array();
		var n=$("#cant_reg").val();
		//console.log(n);
		for (var i = 0; i < n ; i++) {
			fechas[i]=$("#fecha-"+i).val();
			temperaturas[i]=parseFloat($("#temp-"+i).val());
			humedades[i]=parseFloat($("#hum-"+i).val());
		}
		//console.log(temperaturas);

		chart = new Highcharts.Chart({
			chart: {
				renderTo: 'graficoTemp', 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Temperatura'	// Titulo (Opcional)
			},
			subtitle: {
				text: 'Ultimos 30 dias'		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas,
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
		                data: temperaturas
		            }],
		});	
	chart2 = new Highcharts.Chart({
			chart: {
				renderTo: 'graficoHum', 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Humedad'	// Titulo (Opcional)
			},
			subtitle: {
				text: 'Ultimos 30 dias'		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas,
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
		                data: humedades
		            }],
		});	
	});
</script>
<style type="text/css">

</style>



<body>
	<div id="graficoTemp" style="width: 100%; height: 500px; margin: 0 auto"></div>
	<br></br>

	<div id="graficoHum" style="width: 100%; height: 500px; margin: 0 auto"></div>

<?php
$cant_reg=count($datos["datos"]);
echo "<input type='text' id='cant_reg' name='cant_reg' value='".$cant_reg."' hidden>";
for ($i=0; $i < $cant_reg; $i++) { 
		echo "<input type='text' id='id-".$i."' name='id-".$i."' value='".$datos["datos"][$i]["id"]."' hidden>";
		echo "<input type='text' id='temp-".$i."' name='temp-".$i."' value='".$datos["datos"][$i]["temperatura"]."' hidden>";
		echo "<input type='text' id='hum-".$i."' name='hum-".$i."' value='".$datos["datos"][$i]["humedad"]."' hidden>";
		echo "<input type='text' id='fecha-".$i."' name='fecha-".$i."' value='".$datos["datos"][$i]["cuando"]."' hidden>";
	}
	?> 
</body>



