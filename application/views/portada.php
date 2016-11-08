<!DOCTYPE html>
<html>
 <head>
  <title>Sistema Integral de Gestión de Proyectos de Extensión | UNMdP</title>
  <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
  <meta name="description" content="Login Sistema integral de gestion de proyectos" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <!--<meta name="keywords" content="extension, proyectos, convocatoria, subsidio, unicen, voluntariado, ppua" /> -->
    <link href="<?php echo base_url();?>css/general_evaluadores.css" media="screen,print" rel="stylesheet" type="text/css" />
    <style type="text/css">
#LoginUsuarios{ width:400px; margin:auto; background:#FFFFFF; padding:40px;-webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; border:#CCC 1px solid; margin-top:100px; }
#LoginUsuarios h1{ font-size:30px; border-bottom:#CCC 1px solid; padding-bottom:10px; margin-bottom:10px}
.footer{ margin:10px;}
.legend{font-size:12px; font-weight:bold; color:#999999; margin:0px; padding:0px; margin-bottom:10px; position:absolute; bottom:0px; width:100%; text-align:center}
.LoginUsuariosDato {margin:10px}
.registro {
    background: rgba(203,96,179,1);
background: -moz-linear-gradient(left, rgba(203,96,179,1) 0%, rgba(168,0,119,1) 0%, rgba(193,70,161,1) 0%, rgba(95,95,199,1) 0%, rgba(101,29,143,1) 100%);
background: -webkit-gradient(left top, right top, color-stop(0%, rgba(203,96,179,1)), color-stop(0%, rgba(168,0,119,1)), color-stop(0%, rgba(193,70,161,1)), color-stop(0%, rgba(95,95,199,1)), color-stop(100%, rgba(101,29,143,1)));
background: -webkit-linear-gradient(left, rgba(203,96,179,1) 0%, rgba(168,0,119,1) 0%, rgba(193,70,161,1) 0%, rgba(95,95,199,1) 0%, rgba(101,29,143,1) 100%);
background: -o-linear-gradient(left, rgba(203,96,179,1) 0%, rgba(168,0,119,1) 0%, rgba(193,70,161,1) 0%, rgba(95,95,199,1) 0%, rgba(101,29,143,1) 100%);
background: -ms-linear-gradient(left, rgba(203,96,179,1) 0%, rgba(168,0,119,1) 0%, rgba(193,70,161,1) 0%, rgba(95,95,199,1) 0%, rgba(101,29,143,1) 100%);
background: linear-gradient(to right, rgba(203,96,179,1) 0%, rgba(168,0,119,1) 0%, rgba(193,70,161,1) 0%, rgba(95,95,199,1) 0%, rgba(101,29,143,1) 100%);
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#cb60b3', endColorstr='#651d8f', GradientType=1 );
  border: 1px solid #85AB57 !important;
  border-bottom: 2px solid #6A9832 !important;
  color:#fff !important;
  cursor: pointer !important;
  font-size: 16px !important;
  font-weight:bold;
  padding: 2px 2px !important;
  text-shadow: 0 -1px 0 #333 !important;
  overflow: visible !important;
  display: inline-block;
  -moz-border-radius: 15px !important;
  -webkit-border-radius: 15px !important;
}

</style>

  </head>

<body>



 <div class="footer" align="center">
 <img class="img-responsive" src="<?php echo base_url();?>img/extension_nuevo.jpg" width="1200" height="100"></div>

 <?php echo form_open('login/'); ?>
<div id="LoginUsuarios" class="support-body">
  <h1>Plataforma Virtual de Extensión Universitaria</h1>
  <h2>iniciar sesión</h2>
    <div class="fila">
       <div><input id="cuillogin" name='cuillogin' type="textbox" autofocus="autofocus" placeholder="Usuario" class="form-control"></div>   
       <br>
    </div>
    <div class="fila">
       <div><input type="password" id="passwordlogin" name="passwordlogin" value="" placeholder="Contraseña" class="form-control"></div>
    </div>
    <br>
    <div class="fila">


  <?php if(isset($data['error'])){?>

    <div class="LoginUsuariosError" ><?= form_error('passwordlogin');?></div>
      <div class="LoginUsuariosError" style="border:#0F3 1px solid; background-color:#0F9; margin: 20px -40px 20px -40px; padding:10px;" align="center">

    <?php
      echo $data['error'];
    echo form_error('dnilogin');
  ?>

       </div>
    <?php } ?>
       <div>
        <input type="submit" value="Ingresar" class='btn btn-success'>
        <a href="login/recordar" class='btn btn-info' style="color:white;">Olvidé mi contraseña</a></br></br>
        <input type="button" class='btn btn-warning' value="registrar usuario" onclick="location.href = 'login/registro1';">
        <input type="button" class='btn btn-warning' value="registrar organización" onclick="location.href = 'login/registro2';">
       </div>
       <br>
 </div>
 </form>
</body>
 </html>



  <!--
  <body>
  <div id="imagen">
 <img src="<?php //echo base_url();?>img/extension.png" ></div>
    <div id="panel" align="left">
      <label id="titulo">Sistema Integral de Gestión de Proyectos de Extensión</label></br>
     <?php //echo form_open('login/'); ?>
     <?php //if(isset($data['error'])){?>
      <label id="error" style="color: red;"><?php //echo $data['error'];?></label></br>
      <?php// }?>
      <input id="cuillogin" name='cuillogin' type="textbox" autofocus="autofocus" placeholder="CUIL"></br>
      <input type="password" id="passwordlogin" name="passwordlogin" value="" placeholder="Contraseña">
      <input type="submit" id="ing" value="Ingresar"></br>
      <input type="button" value="registrar usuario" onclick="location.href = 'login/registro1';">
      <input type="button" value="registrar organizacion" onclick="location.href = 'login/registro2';"></br>
      <a href="login/recordar" class="registro" style="width:90px; margin-left:10px;">Olvidé mi contraseña</a>
      </form>
    </div>
    <div id="map-canvas"></div>
    <div id='footer'>
    <label id='texto'><a>Secretaría de Extensión</a> | Universidad Nacional de Mar del Plata. Diag. Alberdi 2695 4to piso, Mar del Plata. Buenos Aires. Argentina.</br>Consultas: Tel: (0223) 492-1700/05 interno 176 / 17 - secexten@mdp.edu.ar</label>


    </div>

  </body>
</html> -->
