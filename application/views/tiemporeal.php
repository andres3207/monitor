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
setTimeout('document.location.reload()',10000);
</script>
<style type="text/css">

</style>


<div class="container">
<div class="form-horizontal">
<div class="form-group">
<label class='col-md-3 text-left'><p>Temperatura Actual:</p></label>
<div class="col-md-2"><p><input type='text' class="form-control" id="temp" name="temp" readonly value=<?php echo "'".$datos["temp"]."°C'"; ?>></input></p></div>
</div>

<div class="form-group">
<label class='col-md-3 text-left'><p>Humedad Actual:</p></label>
<div class="col-md-2"><p><input type='text' class="form-control" id="hum" name="hum" readonly value=<?php echo "'".$datos["hum"]."%'"; ?>></input></p></div>
</div>

</div>
</div>



