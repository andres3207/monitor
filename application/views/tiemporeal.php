<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Sistema de Monitoreo de Humedad y Temperatura</title>
 	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />
 	<script src="https://d3js.org/d3.v4.min.js"></script>



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

var cant_sensores=$("#cant_sens").val();

var nombres=[];
var temperaturas=[]
var humedades=[]

for (var i = 0; i < cant_sensores; i++) {
	nombres[i]=$("#nombre-"+i).val();
	temperaturas[i]=$("#temp-"+i).val();
	humedades[i]=$("#hum-"+i).val();
}

ctx.font = "27px Arial";
for (var i = 0; i < cant_sensores; i++) {
	division=570+(i)*560/(cant_sensores);
	if (i!=0) {

		ctx.moveTo(division,702-Math.tan(19*3.14159/180)*(division-570));
		ctx.lineTo(division,702-366-Math.tan(19*3.14159/180)*(division-570));
		ctx.stroke();
		}
	posx=570+(2*i+1)*560/(2*cant_sensores);
	posy=702-220-Math.tan(19*3.14159/180)*(posx-570);
	ctx.fillText(nombres[i],posx-50,posy);
	ctx.fillText("T: "+temperaturas[i],posx-50,posy+50);
	ctx.fillText("H: "+humedades[i],posx-50,posy+100);
	console.log(division-570);

}


var j=Math.tan(3.14159/6);
console.log(j*(1130-570));



})
</script>
<style type="text/css">

</style>

<?php 
$cant_camaras=1;

$cant_sensor=0;
for ($i=0; $i < count($datos["sensores"]) ; $i++) { 
	if($datos["sensores"][$i]["habilitado"]){
		$cant_sensor=$cant_sensor+1;
	}
}

//$cant_sensor=count($datos["sensores"]);
echo "<input type='text' name='cant_sens' id='cant_sens' value='".$cant_sensor."' readonly hidden>";
for ($i=0; $i <$cant_sensor ; $i++) {
	if($datos["sensores"][$i]["habilitado"]){
		
		echo "<input type='text' id='temp-".$i."' name='temp-".$i."' readonly value='".$datos["sensores"][$i]["temperatura"]."°C' hidden>";
		echo "<input type='text' id='hum-".$i."' name='hum-".$i."' readonly value='".$datos["sensores"][$i]["humedad"]."%' hidden>";
	}
}
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

/*

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

*/

for ($i=0; $i <$cant_camaras ; $i++) { 
  echo "<table class='table table-condensed'>";
echo "<tr>";
  echo "<td class='active'><p>Camara:</p></td>";
  echo "<td class='active'><p>".($i+1)."</p></td>";
echo "</tr>";
for ($j=0; $j <$cant_sensor ; $j++) { 
  echo "<tr>";
  echo "<td class='active'><p>Sensor:</p></td>";
  if($datos["sensores"][$i]["nombre"]==""){
      echo "<td class='active'><p>".$datos["sensores"][$j]["mac_sensor"]."</p></td>";
    }else{
      echo "<td class='active'><p>".$datos["sensores"][$j]["nombre"]."</p></td>";
    }
echo "</tr>";
echo "<tr>";
if ($datos["sensores"][$j]["temperatura"]<$datos["umbrales"]["t_min"]) {
      echo "<td class='info'><p>Temperatura:</p></td>";
      echo "<td class='info'><p>".$datos["sensores"][$j]["temperatura"]."</p></td>";
    }elseif ($datos["sensores"][$i]["temperatura"]<=$datos["umbrales"]["t_max"]) {
      echo "<td class='success'><p>Temperatura:</p></td>";
      echo "<td class='success'><p>".$datos["sensores"][$j]["temperatura"]."</p></td>";
    }else{
      echo "<td class='danger'><p>Temperatura:</p></td>";
      echo "<td class='danger'><p>".$datos["sensores"][$j]["temperatura"]."</p></td>";
    }
echo "</tr>";
echo "<tr>";
    if ($datos["sensores"][$i]["humedad"]<$datos["umbrales"]["h_min"]) {
      echo "<td class='info'><p>Humedad:</p></td>";
      echo "<td class='info'><p>".$datos["datos"][$j]["humedad"]."</p></td>";
    }elseif ($datos["sensores"][$j]["humedad"]<=$datos["umbrales"]["h_max"]) {
      echo "<td class='success'><p>Humedad:</p></td>";
      echo "<td class='success'><p>".$datos["sensores"][$j]["humedad"]."</p></td>";
    }else{
      echo "<td class='danger'><p>Humedad:</p></td>";
      echo "<td class='danger'><p>".$datos["sensores"][$j]["humedad"]."</p></td>";
    }
echo "</tr>";
}


echo "</table>";
echo "</br>";
}



?>


<!-- <canvas id="myCanvas" width="1140" height="712" style="border:1px solid #d3d3d3;" hidden>-->





</div>
</div>



