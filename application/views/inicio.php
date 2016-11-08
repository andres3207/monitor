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

<?php echo form_open('crear_noticia/guardar',array('id' => 'password'));?>

<div class="container">
<div class="form-horizontal">
<h2>Noticia:</h2>
<div class="form-group">
<div class="col-md-9"><p><textarea id="noticia" name="noticia" class="form-control" rows="5" required></textarea></p></div>
</div>

<p><input type="submit" value="Guardar" class="btn btn-success"></p>

</div>
</div>


<!--
<?php echo form_label('Noticia: ', 'noti');?><?php echo "</br><textarea id='noticia' name='noticia' required></textarea>";?>

<p>&nbsp;</p>



<?php

if ($this->session->userdata('login_tipo')==5){
	echo'<input type="button" value="Enviar" disabled>';
}
else{
	$data = array(
		 'name' => 'button',
		 'id' => 'button',
		 'value' => 'true',
		 'type' => 'submit',
		 'content' => 'Guardar',
		 'class' => 'btn btn-success',

 	 );

	echo form_button($data);
}
?>
</p>
<p>&nbsp;</p> -->
<?php echo form_close(); ?>

