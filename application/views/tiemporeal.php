<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Sistema de Monitoreo de Humedad y Temperatura</title>
 	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />



</head>
<script type="text/javascript">
$(document).ready(function() {
setTimeout('document.location.reload()',10000);

var c = document.getElementById("myCanvas");
var ctx = c.getContext("2d");
ctx.moveTo(570,702);
ctx.lineTo(1130,508);
ctx.stroke();

ctx.moveTo(1130,508);
ctx.lineTo(1130,142);
ctx.stroke();

ctx.moveTo(1130,142); //ARREGLAR
ctx.lineTo(902,10);
ctx.stroke();

ctx.moveTo(570,702);
ctx.lineTo(342,570);
ctx.stroke();


ctx.moveTo(342,570);
ctx.lineTo(342,204);
ctx.stroke();

ctx.moveTo(342,204);
ctx.lineTo(902,10);
ctx.stroke();

ctx.moveTo(570,702);
ctx.lineTo(570,336);
ctx.stroke();

ctx.moveTo(570,336);
ctx.lineTo(342,204);
ctx.stroke();

ctx.moveTo(570,336);
ctx.lineTo(1130,142);
ctx.stroke();

var temp=$("#temp2").val();
var hum=$("#hum2").val();

ctx.font = "30px Arial";
ctx.fillText("T: "+temp,850,356);
ctx.font = "30px Arial";
ctx.fillText("H: "+hum,850,400);

})
</script>
<style type="text/css">

</style>

<?php 

$cant_sensor=count($datos["sensores"]);
?>
<div class="container">
<div class="form-horizontal">
<!--
<label>DHT22:</label>
<div class="form-group">
<label class='col-md-3 text-left'><p>Temperatura Actual:</p></label>
<div class="col-md-2"><p><input type='text' class="form-control" id="temp" name="temp" readonly value=<?php echo "'".$datos["temp"]." °C'"; ?>></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Humedad Actual:</p></label>
<div class="col-md-2"><p><input type='text' class="form-control" id="hum" name="hum" readonly value=<?php echo "'".$datos["hum"]." %'"; ?>></input></p></div>
</div>

<label>SHT71</label> 

<div class="form-group">
<label class='col-md-3 text-left'><p>Temperatura Actual:</p></label>
<div class="col-md-2"><p><input type='text' class="form-control" id="temp2" name="temp2" readonly value=<?php echo "'".$datos["temp2"]." °C'"; ?>></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Humedad Actual:</p></label>
<div class="col-md-2"><p><input type='text' class="form-control" id="hum2" name="hum2" readonly value=<?php echo "'".$datos["hum2"]." %'"; ?>></input></p></div>
</div>
-->

<?php

for ($i=0; $i <$cant_sensor ; $i++) { 
	if($datos["sensores"][$i]["habilitado"]){
		if($datos["sensores"][$i]["nombre"]==""){
			echo "<h2>".$datos["sensores"][$i]["mac_sensor"]."</h2>";
		}else{
			echo "<h2>".$datos["sensores"][$i]["nombre"]."</h2>";
		}
		echo "<div class='form-group'>";
		echo "<label class='col-md-3 text-left'><p>Temperatura Actual:</p></label>";
		echo "<div class='col-md-2'><p><input type='text' class='form-control' id='temp2' name='temp2' readonly value='".$datos["sensores"][$i]["temperatura"]." °C'></input></p></div>";
		echo "</div>";
		echo "<div class='form-group'>";
		echo "<label class='col-md-3 text-left'><p>Humedad Actual:</p></label>";
		echo "<div class='col-md-2'><p><input type='text' class='form-control' id='hum2' name='hum2' readonly value='".$datos["sensores"][$i]["humedad"]." %'></input></p></div>";
		echo "</div>";
		echo "</br>";
		echo "</br>";
	}
}

?>

<canvas id="myCanvas" width="1140" height="712" style="border:1px solid #d3d3d3;">
</div>
</div>



