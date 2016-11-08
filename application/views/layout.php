<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8;charset=utf-8" />
    <META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">
	<title>Sistema de Monitoreo de Humedad y Temperatura</title>
	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />
    <link href="<?php echo base_url();?>css/form.css" type="text/css" rel="stylesheet" media="screen" /> 
   <link href="<?php echo base_url();?>css/menu.css" type="text/css" rel="stylesheet" media="screen" />
	<script src="<?php echo base_url();?>js/jquery-1.7.2.js" type="text/javascript" ></script>
    <script src="<?php echo base_url();?>js/jquery.validate.min.js" type="text/javascript" ></script>
</head>
<body>
<!--begin:nave_page-->
<header>
    <nav style="background:#07375b;">
    
    
    
        <div id="headi" class="container_16" style="width: 960px; margin: 0 auto;">
           
          

        </div>
        <div id="navi" class="container_16" style="width: 960px; margin: 0 auto;">
        <? echo $layout_navigation; ?>
        
        </div>
    </nav>
</header>
<!--end:nav_page-->
<!--begin:page_title-->
<div id="company-content">
<div class="wrapper clearfix">
<div id="section-header" class="clearfix">
          <h1><?=$section_title?></h1>
        </div>
</div>
<!--end:page_title-->
<div id='company-support-portal'>
<div class='wrapper'>
<!--begin:body-->
<div id="support-main" class="columnas2" style="width:700px">
	<!--begin:content-->
  	<div class='support-body' style="padding:10px">
    
    <?php echo $layout_body;?>
    
	</div>
    <!--end:content-->
    <!--begin:footer-->
    <div id='footer'>
    	<a>Secretaría de Extensión</a> | Universidad Nacional de Mar del Plata.
	Diag. Alberdi 2695 4to piso, Mar del Plata. Buenos Aires. Argentina. <br />

Consultas: Tel: (0223) 492-1700/05 interno 176 / 17 - secexten@mdp.edu.ar
        
        
    </div>
	<!--end:footer-->
</div>
<!--begin:body-->
<!--begin:sidebar_rigth-->
<div id='support-side' class="sidebarsi" >
	<div class='content'>
			<? echo $layout_sidebar ;?>
	</div>
	
</div>
<!--end:sidebar_rigth-->
</div>
</div>
</div>
</body>
</html>
<!-- 
* Este documento proviene de la secretaria de extension de la unicen www.extension.unicen.edu.ar 
* Desarrollo: Marcelo Javier Prado prado@rec.unicen.edu.ar
-->