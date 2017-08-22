<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Termometria de Camaras</title>
 	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />
 	<script src="https://d3js.org/d3.v4.min.js"></script>



</head>
<script type="text/javascript">
$(document).ready(function() {
setTimeout('document.location.reload()',10000);


})
</script>
<style type="text/css">

</style>

<?php 
$cant_camaras=Count($datos["camaras"]);
?>
<div class="container">
<div class="form-horizontal">



<?php




for ($i=0; $i <$cant_camaras ; $i++) { 
  echo "<table class='table table-condensed'>";
echo "<tr>";
  echo "<td class='active'><p>Camara:</p></td>";
  echo "<td class='active'><p>".$this->data_model->NombreCodigoCamara($datos["camaras"][$i]["id"])."</p></td>";
echo "</tr>";
for ($j=0; $j < count($datos["sensores_camara"][$i]); $j++) { 
  echo "<tr>";
  echo "<td class='active'><p>Sensor:</p></td>";
  echo "<td class='active'><p>".$this->data_model->NombreCodigo($datos["sensores_camara"][$i][$j]["id"])."</p></td>";  
echo "</tr>";
echo "<tr>";
if ($datos["sensores_camara"][$i][$j]["temperatura"]<$datos["umbrales"]["t_min"]) {
      echo "<td class='info'><p>Temperatura:</p></td>";
      echo "<td class='info'><p>".$datos["sensores_camara"][$i][$j]["temperatura"]."</p></td>";
    }elseif ($datos["sensores_camara"][$i][$j]["temperatura"]<=$datos["umbrales"]["t_max"]) {
      echo "<td class='success'><p>Temperatura:</p></td>";
      echo "<td class='success'><p>".$datos["sensores_camara"][$i][$j]["temperatura"]."</p></td>";
    }else{
      echo "<td class='danger'><p>Temperatura:</p></td>";
      echo "<td class='danger'><p>".$datos["sensores_camara"][$i][$j]["temperatura"]."</p></td>";
    }
echo "</tr>";
echo "<tr>";

echo "</tr>";
$delta=getdate()[0]-strtotime($datos["sensores_camara"][$i][$j]["cuando"]);
if($delta<=600){
echo "<tr><td class='success'><p>Ultima actualizacion:</p></td>";
echo "<td class='success'><p>".$datos["sensores_camara"][$i][$j]["cuando"]."</p>";
echo "</td>";
echo "</tr>";
}elseif ($delta<=3600) {
  echo "<tr><td class='warning'><p>Ultima actualizacion:</p></td>";
echo "<td class='warning'><p>".$datos["sensores_camara"][$i][$j]["cuando"]."</p>";
echo "</td>";
echo "</tr>";
}else{
  echo "<tr><td class='danger'><p>Ultima actualizacion:</p></td>";
echo "<td class='danger'><p>".$datos["sensores_camara"][$i][$j]["cuando"]."</p>";
echo "</td>";
echo "</tr>";
}



}
echo "</tr>";


echo "</table>";
echo "</br>";
}






?>








</div>
</div>



