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


<form action=sensor/guardar method="GET">
<div class="container">
<div class="form-horizontal">
<div class="form-group">
<label class='col-md-3 text-left'><p>Temperatura:<span>°C</span></p></label>
<div class="col-md-3"><p><input type='text' class="form-control" id="temp" name="temp"></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Humedad:<span>%</span></p></label>
<div class="col-md-3"><p><input type='text' class="form-control" id="hum" name="hum" ></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>MAC:<span>%</span></p></label>
<div class="col-md-3"><p><input type='text' class="form-control" id="mac" name="mac" ></input></p></div>
</div>


<p><input type="submit" class="btn btn-success" value="Guardar cambios"></p>
</div>
</div>

