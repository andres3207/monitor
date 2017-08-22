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


		var cant_sensores=$("#cant_sensor").val();
		//console.log(cant_sensores);
		for (var i = 0; i < cant_sensores; i++) {
			var cant_reg_act=$("#cant_reg_act-"+i).val();
			var cant_reg_ant=$("#cant_reg_ant-"+i).val();
			//console.log(cant_reg_act);
			
			var fechas_act = new Array();
			var temperaturas_act = new Array();


			for (var j = 0; j < cant_reg_act; j++) {
				fechas_act[j]=$("#fecha_act-"+i+"-"+j).val();
				temperaturas_act[j]=parseFloat($("#temp_act-"+i+"-"+j).val());

			}
			//console.log(fechas_act);
			//console.log(humedades_act);
			var render_temp="graficoTemp_act-"+i
			var texto=$("#nombre_codigo-"+i).val();
			chart = new Highcharts.Chart({
			chart: {
				renderTo: render_temp, 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Temperatura'	// Titulo (Opcional)
			},
			subtitle: {
				text: texto		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas_act,
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
		                data: temperaturas_act
		            }],
		});	

			
			var fechas_ant = new Array();
			var temperaturas_ant = new Array();


			for (var j = 0; j < cant_reg_ant; j++) {
				fechas_ant[j]=$("#fecha_ant-"+i+"-"+j).val();
				temperaturas_ant[j]=parseFloat($("#temp_ant-"+i+"-"+j).val());

			}
			//console.log(humedades_ant)
			var render_temp="graficoTemp_ant-"+i
			var texto=$("#nombre_codigo-"+i).val();
			chart = new Highcharts.Chart({
			chart: {
				renderTo: render_temp, 	// Le doy el nombre a la gráfica
				defaultSeriesType: 'line'	// Pongo que tipo de gráfica es
			},
			title: {
				text: 'Datos de Temperatura'	// Titulo (Opcional)
			},
			subtitle: {
				text: texto		// Subtitulo (Opcional)
			},
			// Pongo los datos en el eje de las 'X'
			xAxis: {
				categories: fechas_ant,
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
		                data: temperaturas_ant
		            }],
		});	

			


		}










	
	
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



	echo "<br>";
	echo "<br>";
}


echo "<div class='container'><h2>Graficos del Mes Anterior:</h2></div>";
for ($i=0; $i < $datos["cant_sensores"]; $i++) { 
	echo "<div id='graficoTemp_ant-".$i."' style='width: 100%; height: 500px; margin: 0 auto'></div>";
	echo "<br></br>";



	echo "<br>";
	echo "<br>";
}


for ($i=0; $i <$datos["cant_sensores"] ; $i++) { 
	$cant_reg_act=count($datos["datos_actual"][$i]);
	$cant_reg_ant=count($datos["datos_anterior"][$i]);
	echo "<input type='text' id='nombre_codigo-".$i."' name='nombre_codigo-".$i."' value='".$datos["nombre_codigo"][$i]."' hidden >";
	echo "<input type='text' id='cant_reg_act-".$i."' name='cant_reg_act-".$i."' value='".$cant_reg_act."' hidden >";
	for ($j=0; $j < $cant_reg_act ; $j++) { 
		echo "<input type='text' id='id_act-".$i."-".$j."' name='id_act-".$j."' value='".$datos["datos_actual"][$i][$j]["id"]."' hidden >";
		echo "<input type='text' id='temp_act-".$i."-".$j."' name='temp_act-".$j."' value='".$datos["datos_actual"][$i][$j]["temperatura"]."' hidden >";
		echo "<input type='text' id='fecha_act-".$i."-".$j."' name='fecha_act-".$j."' value='".$datos["datos_actual"][$i][$j]["cuando"]."' hidden >";
	}


	echo "<input type='text' id='cant_reg_ant-".$i."' name='cant_reg_ant-".$i."' value='".$cant_reg_ant."' hidden >";

	for ($j=0; $j < $cant_reg_ant; $j++) { 
		echo "<input type='text' id='id_ant-".$i."-".$j."' name='id_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["id"]."' hidden >";
		echo "<input type='text' id='temp_ant-".$i."-".$j."' name='temp_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["temperatura"]."' hidden >";
		echo "<input type='text' id='fecha_ant-".$i."-".$j."' name='fecha_ant-".$j."' value='".$datos["datos_anterior"][$i][$j]["cuando"]."' hidden >";
	}
}
?>




</body>



