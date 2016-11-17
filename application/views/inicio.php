<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Sistema Integral de Gestión de Proyectos de Extensión | UNMdP</title>
 	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
 	<meta name="description" content="Login Sistema integral de gestion de proyectos" />
 	<!--<meta name="keywords" content="extension, proyectos, convocatoria, subsidio, unicen, voluntariado, ppua" /> -->
   	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />




</head>
<script type="text/javascript">
jQuery(document).ready(function() {

});
</script>
<style type="text/css">

</style>

<?php
$cant_reg=count($datos["datos"]);
//echo $cant_reg;
//exit();
?>

<div class="container">
<div class="form-horizontal">
<h2>Datos:</h2>
<div class="form-group">
<div class="col-md-9"><p>

<table class='table'>
	<tr>
	<td><p>Temperatura</p></td>
	<td><p>Humedad</p></td>
	<td><p>Fecha</p></td>
	</tr>
	<?php
	for ($i=0; $i <$cant_reg ; $i++) { 
		echo "<tr>";
		if ($datos["datos"][$i]["temperatura"]<=$datos["limites"]["t_min"]) {
			echo "<td class='info'><p>".$datos["datos"][$i]["temperatura"]."</p></td>";
		}elseif ($datos["datos"][$i]["temperatura"]<=$datos["limites"]["t_max"]) {
			echo "<td class='success'><p>".$datos["datos"][$i]["temperatura"]."</p></td>";
		}else{
			echo "<td class='danger'><p>".$datos["datos"][$i]["temperatura"]."</p></td>";
		}

		if ($datos["datos"][$i]["humedad"]<=$datos["limites"]["h_min"]) {
			echo "<td class='info'><p>".$datos["datos"][$i]["humedad"]."</p></td>";
		}elseif ($datos["datos"][$i]["humedad"]<=$datos["limites"]["h_max"]) {
			echo "<td class='success'><p>".$datos["datos"][$i]["humedad"]."</p></td>";
		}else{
			echo "<td class='danger'><p>".$datos["datos"][$i]["humedad"]."</p></td>";
		}
		//echo "<td>".$datos["datos"][$i]["temperatura"]."</td>";
		//echo "<td>".$datos["datos"][$i]["humedad"]."</td>";
		echo "<td><p>".$datos["datos"][$i]["cuando"]."</p></td>";
		echo "</tr>";
	}
	?>
</table>

</p></div>
</div>


</div>
</div>




