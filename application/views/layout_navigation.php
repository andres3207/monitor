<!-- Navigation layout begin -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
    <title>Sistema Integral de Gestión de Proyectos de Extensión | UNMdP</title>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
    <meta name="description" content="Login Sistema integral de gestion de proyectos" />
    <!--<meta name="keywords" content="extension, proyectos, convocatoria, subsidio, unicen, voluntariado, ppua" /> -->
    <link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" />




</head>
<div  >
<ul  id='menu-bar' >
	<li><a href="<?=base_url()?>inicio" title="Inicio" ><h6>Inicio</h6></a></li>
	<li><a href="#" title="Perfil" ><h6>Perfil</h6></a>
        <ul class='nav navbar-nav'>
	  <?php
	   echo "<li ><a href='".base_url()."password' title='Cambiar contraseña' ><h6>Cambiar contraseña</h6></a></li>";

	  echo "<li ><a href='".base_url()."edit_perfil/index/' title='Editar Perfil' > <h6>Editar Perfil</h6> </a></li>";
      echo "<li ><a href='".base_url()."foto_cv/index/' title='Subir foto y cv' > <h6>Subir Foto y CV</h6> </a></li>";


      ?>
        </ul>
    </li>
    <li><a href="#" title="Estructura Organizacional" > <h6>Estructura Organizacional</h6></a>
    <ul class='nav navbar-nav'>
         <?php 
            echo "<li><a href='".base_url()."estructuras/MisCentros/' title='Mis Centros'><h6>Mis Centros</h6></a></li>";
            echo "<li><a href='".base_url()."estructuras/MisProgramas/' title='Mis Programas'><h6>Mis Programas</h6></a></li>";
            echo "<li><a href='".base_url()."estructuras/MisGrupos/' title='Mis Grupos'><h6>Mis Grupos</h6></a></li>";
            echo "<li><a href='".base_url()."estructuras/TodosCentros/' title='Todos los Centros'><h6>Todos los Centros</h6></a></li>";
            echo "<li><a href='".base_url()."estructuras/TodosProgramas/' title='Todos los Programas'><h6>Todos los Programas</h6></a></li>";
            echo "<li><a href='".base_url()."estructuras/TodosGrupos/'' title='Todos los Grupos'><h6>Todos los Grupos</h6></a></li>";
            /*if($this->data_model->SoyDocente($this->session->userdata('login_id'))){
    echo "<li><a href='".base_url()."index.php/eorga' title='Crear nueva E.O.'>Crear nueva E.O.</a></li>";
    echo "<li><a href='".base_url()."index.php/mis_eo' title='Mis E.O.'>Mis E.O.</a></li>";
     }*/   ?>
     <!-- <li ><a href="<?=base_url()?>todos_eo" title="Todas las E.O." ><h6>Todas las E.O.</h6></a></li>-->
        </ul>
    </li>









</ul>
</div>
<!--Navigation layout begin -->
