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
#print_r($datos["tmp"]);
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



<?php


/*

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
*/



echo "<table class='table table-condensed'>";
echo "<tr>";
  echo "<td class='active'><p>Camara:</p></td>";
  echo "<td class='active'><p>".$datos["tmp"]["camara"]."</p></td>";
echo "</tr>";

  echo "<tr>";
  echo "<td class='active'><p>Sensor:</p></td>";
      echo "<td class='active'><p>".$datos["tmp"]["sensor"]."</p></td>";
echo "</tr>";
echo "<tr>";
if ($datos["tmp"]["temperatura"]<$datos["umbrales"]["t_min"]) {
      echo "<td class='info'><p>Temperatura:</p></td>";
      echo "<td class='info'><p>".$datos["tmp"]["temperatura"]."</p></td>";
    }elseif ($datos["tmp"]["temperatura"]<=$datos["umbrales"]["t_max"]) {
      echo "<td class='success'><p>Temperatura:</p></td>";
      echo "<td class='success'><p>".$datos["tmp"]["temperatura"]."</p></td>";
    }else{
      echo "<td class='danger'><p>Temperatura:</p></td>";
      echo "<td class='danger'><p>".$datos["tmp"]["temperatura"]."</p></td>";
    }
echo "</tr>";
echo "<tr>";
    if ($datos["tmp"]["humedad"]<$datos["umbrales"]["h_min"]) {
      echo "<td class='info'><p>Humedad:</p></td>";
      echo "<td class='info'><p>".$datos["tmp"]["humedad"]."</p></td>";
    }elseif ($datos["tmp"]["humedad"]<=$datos["umbrales"]["h_max"]) {
      echo "<td class='success'><p>Humedad:</p></td>";
      echo "<td class='success'><p>".$datos["tmp"]["humedad"]."</p></td>";
    }else{
      echo "<td class='danger'><p>Humedad:</p></td>";
      echo "<td class='danger'><p>".$datos["tmp"]["humedad"]."</p></td>";
    }
echo "</tr>";
echo "<tr><td class='succes'><p>Ultima actualizacion:</p></td>";
echo "<td class='succes'><p>".$datos["tmp"]["cuando"]."</p></td>";
echo "</tr>";



echo "</table>";


?>


<!-- <canvas id="myCanvas" width="1140" height="712" style="border:1px solid #d3d3d3;" hidden>-->





</div>
</div>



