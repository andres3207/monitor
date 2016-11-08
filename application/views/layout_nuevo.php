<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8;charset=utf-8" />
    <META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">
	<title>Sistema Integral de Gestión de Proyectos de Extensión1</title>
	 <!--
   <link href="<?php echo base_url();?>css/general_evaluadores.css" media="screen" rel="stylesheet" type="text/css" /> 
	<link href="<?php echo base_url();?>css/imprimir.css" media="print" rel="stylesheet" type="text/css" />    -->
    <link href="<?php echo base_url();?>css/form.css" type="text/css" rel="stylesheet" media="screen" />
    <link href="<?php echo base_url();?>css/menu.css" type="text/css" rel="stylesheet" media="screen" />
    <!--<link href="<?php echo base_url();?>css/styles.css" type="text/css" rel="stylesheet" media="screen" /> -->
    
	<script src="<?php echo base_url();?>js/jquery-1.7.2.js" type="text/javascript" ></script>
    <script src="<?php echo base_url();?>js/jquery.validate.min.js" type="text/javascript" ></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container-fluid">
<header>
<figure>
 <img class="img-responsive" src="<?php echo base_url();?>img/extension_nuevo.jpg" width="1200" height="100">
 </figure>

</header>
           
   <nav class="navbar navbar-default">  
        <?php echo $data['layout_navigation'] ; ?>
   </nav>
  <div class="row">
    <h1> <?php echo $data['section_title'] ; ?> </h1>	     
  </div>
  <div class="row">    <?php 	echo $data['layout_body'] ; ?> </div>
 </div>
</body>
</html>
