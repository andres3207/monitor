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

<p><input type="submit" class="btn btn-success" value="Guardar"></p>
</div>
</div>

<?php echo form_fieldset_close(); ?>
<?php echo form_close(); ?>

