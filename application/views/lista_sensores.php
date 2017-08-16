<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Sistema de Monitoreo de Humedad y Temperatura</title>
 	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >

   	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />




</head>
<script type="text/javascript">
jQuery(document).ready(function() {

});
</script>
<style type="text/css">

</style>


<body>

<?php echo form_open('lista_sensores/guardar/',array('id' => 'registro'));?>

<?php echo validation_errors(); ?>

<?php echo form_fieldset(''); ?>


<?php
$cant_reg=count($datos["sensores"]);
$cant_cam=count($datos["camaras"]);
echo "<input type='text' id='cant_sensores' name='cant_sensores' value='".$cant_reg."' readonly hidden>";
echo "<input type='text' id='cant_camaras' name='cant_camaras' value='".$cant_cam."' readonly hidden>";

?>




	<div class="container">
	<div class="form-horizontal">

	
		<?php
	for ($i=0; $i <$cant_cam ; $i++) { 
		echo "<table class='table table-condensed'>";
		echo "<tr>";
		echo "<td><p>Nombre de la camara</p></td>";
		echo "<td><p>Código de la camara</p></td>";
		echo "</tr>";
		echo "<tr>";
		echo "<td class='col-md-3'><p><input type='text' class='form-control' id='nombre_cam-".$i."' name='nombre_cam-".$i."' value='".$datos["camaras"][$i]["nombre"]."'></p></td>";
		echo "<td class='col-md-2'><p><input type='text' class='form-control' id='mac_cam-".$i."' name='mac_cam-".$i."' value='".$datos["camaras"][$i]["mac_camara"]."' readonly></p></td>";
		echo "<td><input type='text' id='id_cam-".$i."' name='id_cam-".$i."' value='".$datos["camaras"][$i]["id"]."' readonly hidden></td>";
		echo "</tr>";


		echo "<table class='table'>";
		echo "<tr>";
		echo "<td><p>Nombre del sensor</p></td>";
		echo "<td><p>Código del sensor</p></td>";
		echo "<td><p>Estado del sensor</p></td>";
		echo "<td></td>";

		echo "</tr>";

		for ($j=0; $j <$cant_reg ; $j++) { 
			if($datos["sensores"][$j]["id_camara"]==$datos["camaras"][$i]["id"]){
		echo "<tr>";
		echo "<td class='col-md-3'><p><input type='text' class='form-control' id='nombre_sensor-".$j."' name='nombre_sensor-".$j."' value='".$datos["sensores"][$j]["nombre"]."'></p></td>";
		echo "<td class='col-md-2'><p><input type='text' class='form-control' id='mac_sensor-".$j."' name='mac_sensor-".$j."' value='".$datos["sensores"][$j]["mac_sensor"]."' readonly></p></td>";
		if ($datos["sensores"][$j]["habilitado"]) {
			echo "<td><label class='radio-inline'><input type='radio' id='estado_sensor-".$j."' name='estado_sensor-".$j."'  value='1' checked ><p>Habilitado</p></label>   <label class='radio-inline'><input type='radio' id='estado_sensor-".$j."' name='estado_sensor-".$j."'  value='0'><p>Deshabilitado</p></label></td>";
		}else{
			echo "<td><label class='radio-inline'><input type='radio' id='estado_sensor-".$j."' name='estado_sensor-".$j."'  value='1'><p>Habilitado</p></label>   <label class='radio-inline'><input type='radio' id='estado_sensor-".$j."' name='estado_sensor-".$j."'  value='0' checked><p>Deshabilitado</p></label></td>";
		}
		echo "<td><input type='text' id='id_sensor-".$j."' name='id_sensor-".$j."' value='".$datos["sensores"][$j]["id"]."' readonly hidden></td>";
		echo "</tr>";
		}
	}
		echo "</table>";

	}

	?>
	</table>


<!--


	<table class='table'>
	<tr>
	<td><p>Nombre del sensor</p></td>
	<td><p>Código del sensor</p></td>
	<td><p>Estado del sensor</p></td>
	<td></td>

	</tr>
	<?php
	for ($i=0; $i <$cant_reg ; $i++) { 
		echo "<tr>";
		echo "<td class='col-md-3'><p><input type='text' class='form-control' id='id-".$i."' name='nombre-".$i."' value='".$datos["sensores"][$i]["nombre"]."'></p></td>";
		echo "<td class='col-md-2'><p><input type='text' class='form-control' id='id-".$i."' name='mac-".$i."' value='".$datos["sensores"][$i]["mac_sensor"]."' readonly></p></td>";
		if ($datos["sensores"][$i]["habilitado"]) {
			echo "<td><label class='radio-inline'><input type='radio' id='estado-".$i."' name='estado-".$i."'  value='1' checked ><p>Habilitado</p></label>   <label class='radio-inline'><input type='radio' id='estado-".$i."' name='estado-".$i."'  value='0'><p>Deshabilitado</p></label></td>";
		}else{
			echo "<td><label class='radio-inline'><input type='radio' id='estado-".$i."' name='estado-".$i."'  value='1'><p>Habilitado</p></label>   <label class='radio-inline'><input type='radio' id='estado-".$i."' name='estado-".$i."'  value='0' checked><p>Deshabilitado</p></label></td>";
		}
		echo "<td><input type='text' id='id-".$i."' name='id-".$i."' value='".$datos["sensores"][$i]["id"]."' readonly hidden></td>";
		echo "</tr>";
	}

	?>

	</table> -->
<p><input type="submit" class="btn btn-success" value="Guardar cambios"></p>
</div>
</div>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>


</body>


<!--

<?php echo form_open('configuracion/guardar/',array('id' => 'registro'));?>

<?php echo validation_errors(); ?>

<?php echo form_fieldset(''); ?>

<div class="container">
<h2>Alarmas:</h2>
<div class="form-horizontal">
<div class="form-group">
<label class='col-md-3 text-left'><p>Temperatura Mínima:<span>°C</span></p></label>
<div class="col-md-1"><p><input type='number' class="form-control" id="t_min" name="t_min" value=<?php echo "'".$datos["limites"]['t_min']."'"; ?>></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Temperatura Máxima:<span>°C</span></p></label>
<div class="col-md-1"><p><input type='number' class="form-control" id="t_max" name="t_max" value=<?php echo "'".$datos["limites"]['t_max']."'"; ?>></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Humedad Mínima:<span>%</span></p></label>
<div class="col-md-1"><p><input type='number' class="form-control" id="h_min" name="h_min" value=<?php echo "'".$datos["limites"]['h_min']."'"; ?>></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Humedad Maxima:<span>%</span></p></label>
<div class="col-md-1"><p><input type='number' class="form-control" id="h_max" name="h_max" value=<?php echo "'".$datos["limites"]['h_max']."'"; ?>></input></p></div>
</div>

<p><input type="submit" class="btn btn-success" value="Guardar cambios"></p>
</div>
</div>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>


<?php echo form_open('configuracion/borrar_registros/',array('id' => 'registro'));?>

<?php echo validation_errors(); ?>

<?php echo form_fieldset(''); ?>

<div class="container">
<h2>Borrar registros datos de humedad y temperatura:</h2>
	<div class="form-horizontal">
		<div class="form-group">
		<div class='col-md-2'><p><input type="submit" class="btn btn-danger" name="btn_borrar_registros" value="Borrar Datos"></p></div>
			
		</div>
	</div>
</div>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>


<?php echo form_open('configuracion/borrar_alertas/',array('id' => 'registro'));?>

<?php echo validation_errors(); ?>

<?php echo form_fieldset(''); ?>

<div class="container">
<h2>Borrar registros de alertas emitidas:</h2>
	<div class="form-horizontal">
		<div class="form-group">
		<div class='col-md-2'><p><input type="submit" class="btn btn-danger" name="btn_borrar_alertas" value="Borrar Alertas"></p></div>
			
		</div>
	</div>
</div>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>

<?php echo form_open('configuracion/agendar/',array('id' => 'registro'));?>

<?php echo validation_errors(); ?>

<?php echo form_fieldset(''); ?>

<div class="container">
<h2>Suscribirse por e-mail para recibir alertas:</h2>
	<div class="form-horizontal">
		<div class="form-group">
		<label class='col-md-3 pull-left'><p>Ingrese su email</p></label>
		<div class="col-md-7"><p><input type="email" class="form-control" id="email" name="email" required></p></div>
		<div class='col-md-2'><p><input type="submit" class="btn btn-success" name="btn_agregar" value="Agregar Correo"></p></div>
			
		</div>
	</div>
</div>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>

-->