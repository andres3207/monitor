<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 	<title>Sistema Integral de Gestión de Proyectos de Extensión | UNMdP</title>
 	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
 	<meta name="description" content="Login Sistema integral de gestion de proyectos" />
 	<!--<meta name="keywords" content="extension, proyectos, convocatoria, subsidio, unicen, voluntariado, ppua" /> -->
   	<link href="<?php echo base_url();?>css/general.css" media="screen,print" rel="stylesheet" type="text/css" /> 




</head>

<script>

</script>
<style>



</style>
<body>

<?php
echo "<div id='contenedor' class='table-responsive'>";
echo "<table class='table table-condensed'>";
echo "<tr>";

if ($this->session->userdata('login_persona')=="user"){
  echo "<td class='active col-md-2'>";
  $foto='/var/www/nuevo_sistema_2/uploads/imagenes/foto'.$this->session->userdata('login_cuil').'.jpg';
  if (file_exists($foto)){
    echo "<img src='".base_url()."/uploads/imagenes/foto".$this->session->userdata('login_cuil').'.jpg'."'  width='100' height='100'>";
  }else{
    echo "<p>foto NO Subida</p>";
  }
  echo "</td>";
  echo "<td>";
  echo "<p>Usuario: ".$this->session->userdata('login_cuil')."</p>";
  echo "<p>".$this->session->userdata('login_nombre')." ".$this->session->userdata('login_apellido')."</p>";
  echo "<p>".$datos["usuario"]["categoria"]." - ".$datos["usuario"]["tipo"]." - ".$datos["usuario"]["dependencia"]."</p>";
  echo "<p>".$datos["usuario"]["email"]."</p>";
  echo "</br>";
  $cv='/var/www/nuevo_sistema_2/uploads/cvs/cv'.$this->session->userdata('login_cuil').'.pdf';
  if (file_exists($cv)){
    echo "<p><a href=".base_url()."uploads/cvs/cv".$this->session->userdata('login_cuil').".pdf title='Ver CV'>Ver CV</a></p>";
  }else{
    echo "<p>CV en PDF NO Subido</p>";
  }
  echo "</td>";

}elseif ($this->session->userdata('login_persona')=="admin") {
  echo "<td class='active'></td>";
  echo "<td>";
  echo "<p>Usuario: ".$this->session->userdata('login_usuario')."</p>";
  echo "<p>Dependencia: ".$this->session->userdata('login_depend')."</p>";
  if ($this->session->userdata('login_permisos')) {
    echo "<p>Adminidstrador con permisos de lectura y escritura</p>";
  }else{
    echo "<p>Adminidstrador con permisos de solo lectura</p>";
  }
}elseif ($this->session->userdata('login_persona')=="organizacion") {
  echo "<td class='active'></td>";
  echo "<td>";
  echo "<p>Usuario: ".$this->session->userdata('login_cuit')."</p>";
  echo "<p>Nombre de la organizacion: ".$this->session->userdata('login_nombre')."</p>";
  echo "<p>Representante de la organizacion: ".$this->session->userdata('rep_nombre')." ".$this->session->userdata('rep_apellido')."</p>";
  echo "</td>";
}

echo "</tr>";


echo "<tr>";
echo "<td class='active'><p>NOTICIAS</p></td>";
$noticia=$this->data_model->CargarNoticias(10);
//print_r($noticia);exit();
if (isset($noticia['mensaje'])) {
     echo "<td><p><textarea rows='5' class='form-control' readonly>".$noticia['mensaje']."</textarea></p></td>";
   }else{
    echo "<td><p><textarea rows='5' class='form-control' readonly>No hay noticias</textarea></p></td>";
   } 
echo "</tr>";



// Muestro la seccion de noticias de unidad academica, solo a los admins que no sean de la secretaria, es decir que pertenezcan a una unidad, y a los users que su dependencia no sea la secretaria de extension
if ((($this->session->userdata('login_persona')=="admin") and ($this->session->userdata('login_depend')!="10")) or (($this->session->userdata('login_persona')=="user") and ($this->data_model->DependenciaPersona($this->session->userdata('login_id'))!="10"))) {
  echo "<tr>";
  echo "<td class='active'><p></p></td>";
  if ($this->session->userdata('login_persona')=="admin") {
    $noticia=$this->data_model->CargarNoticias($this->session->userdata('login_depend'));
  }elseif ($this->session->userdata('login_persona')=="user") {
    $noticia=$this->data_model->CargarNoticias($this->data_model->DependenciaPersona($this->session->userdata('login_id')));
  } 
  if (isset($noticia['mensaje'])) {
     echo "<td><p><textarea rows='5' class='form-control' readonly>".$noticia['mensaje']."</textarea></p></td>";
   }else{
    echo "<td><p><textarea rows='5' class='form-control' readonly>No hay noticias</textarea></p></td>";
   } 
  
  echo "</tr>";
}


echo "<tr>";
if (($this->session->userdata('login_persona')=="user") or ($this->session->userdata('login_persona')=="organizacion")){
  echo "<td class='active'><p>NOTIFICACIONES</br>DE PROYECTOS</p></td>";
  echo "<td>";
  $cant_solicitudes_p=count($datos['solicitudes_p']);
  if ($cant_solicitudes_p==0){
    echo "<p>No hay solicitudes pendientes</p>";
  }else{
    echo "<table class='table table-striped table-condensed'>";
    echo "<tr class='info'>";
    //echo "<td>Nº de peticion</td>";
    echo "<td class='col-md-2'><p>Fecha</p></td>";
    echo "<td class='col-md-2'><p>Nombre del proyecto</p></td>";
    echo "<td class='col-md-1'><p>Rol asignado</p></td>"; 
    echo "<td class='col-md-2'><p>Director</p></td>";
    echo "<td class='col-md-1'><p>Dependencia</p></td>";   
    echo "<td class='col-md-1'></td>";
    echo "<td class='col-md-1'></td>";
    echo "</tr>";
    for ($i=0;$i<$cant_solicitudes_p;$i++){
      echo "<tr>";
      //echo "<td>".($i+1)."</td>";
      echo "<td><p>".$datos['solicitudes_p'][$i]["cuando"]."</p></td>";      
      echo "<td><p>".$datos['solicitudes_p'][$i]["nombre_proyecto"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_p'][$i]["rol"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_p'][$i]["director_nombre"]." ".$datos['solicitudes_p'][$i]["director_apellido"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_p'][$i]["director_dependencia"]."</p></td>";     
      echo "<td>";
      echo "<form action='login_ok/aceptar' method='post'>";
      echo "<input id='solicitud' name='solicitud' value='".$datos['solicitudes_p'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_aceptar' value='Aceptar' class='btn btn-success'></p>";
      echo "</form>";
      echo "</td>";
      echo "<td>";
      echo "<form action='login_ok/rechazar' method='post'>";
      echo "<input id='solicitud' name='solicitud' value='".$datos['solicitudes_p'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_rechazar' value='Rechazar' class='btn btn-danger'></p>";
      echo "</form>";
      echo "</td>";
      echo "</tr>";
    }
    echo "</table>";
  }
  echo "</td>";
}elseif ($this->session->userdata('login_persona')=="admin") {
  echo "<td class='active'><p>BITACORA DE</br>LA DEPENDENCIA</p></td>";
  echo "<td>";
  $cant_registros=count($datos['bitacora']);

  echo "<table class='table table-striped table-condensed'>";
  echo "<thead>";
  echo "<tr class='info'>";
  echo "<td><p>Nº de registro</p></td>";
  echo "<td><p>Tipo de mensaje</p></td>";
  echo "<td><p>Mensaje</p></td>";
  echo "<td><p>Quien</p></td>";
  echo "<td><p>Cuando</p></td>";
  echo "</tr>";
  echo "</thead>";
  echo "<tbody>";
  for ($i=0;$i<$cant_registros;$i++){

    echo "<tr>";
    echo "<td><p>".($i+1)."</h4></td>";
    echo "<td><p>".$datos['bitacora'][$i]["tipo"]."</p></td>";
    echo "<td><p>".$datos['bitacora'][$i]["descripcion"]."</p></td>";
    echo "<td><p>".$datos['bitacora'][$i]["quien"]."</p></td>";
    echo "<td><p>".$datos['bitacora'][$i]["cuando"]."</p></td>";
    echo "</tr>";
  }
  echo "</tbody>";
  echo "</table>";
  echo "</td>";
}
echo "</tr>"; 

echo "<tr>";
if (($this->session->userdata('login_persona')=="user") or ($this->session->userdata('login_persona')=="organizacion")){
  echo "<td class='active'><p>NOTIFICACIONES</br>DE ACTIVIDADES</p></td>";
  echo "<td>";
  $cant_solicitudes_a=count($datos['solicitudes_a']);
  if ($cant_solicitudes_a==0){
    echo "<p>No hay solicitudes pendientes</p>";
  }else{
    echo "<table class='table table-striped table-condensed'>";
    echo "<tr class='info'>";
    echo "<td class='col-md-2'><p>Fecha</p></td>";
    echo "<td class='col-md-2'><p>Nombre de la actividad</p></td>";
    echo "<td class='col-md-1'><p>Rol asignado</p></td>";
    echo "<td class='col-md-2'><p>Director</p></td>";  
    echo "<td class='col-md-1'><p>Dependencia</p></td>";         
    echo "<td class='col-md-1'></td>";
    echo "<td class='col-md-1'></td>";
    echo "</tr>";
    for ($i=0;$i<$cant_solicitudes_a;$i++){
      echo "<tr>";
      echo "<td><p>".$datos['solicitudes_a'][$i]["cuando"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_a'][$i]["nombre_actividad"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_a'][$i]["rol"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_a'][$i]["director_nombre"]." ".$datos['solicitudes_a'][$i]["director_apellido"]."</p></td>";  
      echo "<td><p>".$datos['solicitudes_a'][$i]["director_dependencia"]."</p></td>";        
      echo "<td>";
      echo "<form action='login_ok/aceptar' method='post'>";
      echo "<input id='solicitud' name='solicitud' value='".$datos['solicitudes_a'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_aceptar' value='Aceptar' class='btn btn-success'></p>";
      echo "</form>";
      echo "</td>";
      echo "<td>";
      echo "<form action='login_ok/rechazar' method='post'>";
      echo "<input id='solicitud' name='solicitud' value='".$datos['solicitudes_a'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_rechazar' value='Rechazar' class='btn btn-danger'></p>";
      echo "</form>";
      echo "</td>";
      echo "</tr>";
    }
    echo "</table>";
  }
  echo "</td>";
}
echo "</tr>";

echo "<tr>";
if (($this->session->userdata('login_persona')=="user") or ($this->session->userdata('login_persona')=="organizacion")){
  echo "<td class='active'><p>NOTIFICACIONES</br>DE ESTRUCTURAS ORGANIZACIONALES</p></td>";
  echo "<td>";
  $cant_solicitudes_e=count($datos['solicitudes_e']);
  if ($cant_solicitudes_e==0){
    echo "<p>No hay solicitudes pendientes</p>";
  }else{
    echo "<table class='table table-striped table-condensed'>";
    echo "<tr class='info'>";
    echo "<td class='col-md-2'><p>Fecha</p></td>";
    echo "<td class='col-md-2'><p>Denominacion de la estructura</p></td>";
    echo "<td class='col-md-1'><p>Rol asignado</p></td>";
    echo "<td class='col-md-2'><p>Creador</p></td>";  
    echo "<td class='col-md-1'><p>Dependencia</p></td>";         
    echo "<td class='col-md-1'></td>";
    echo "<td class='col-md-1'></td>";
    echo "</tr>";
    for ($i=0;$i<$cant_solicitudes_e;$i++){
      echo "<tr>";
      echo "<td><p>".$datos['solicitudes_e'][$i]["cuando"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_e'][$i]["denominacion"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_e'][$i]["rol"]."</p></td>";
      echo "<td><p>".$datos['solicitudes_e'][$i]["creador"]."</p></td>"; 
      echo "<td><p>".$datos['solicitudes_e'][$i]["dependencia"]."</p></td>";        
      echo "<td>";
      echo "<form action='login_ok/aceptar2' method='post'>";
      echo "<input id='solicitud' name='solicitud' value='".$datos['solicitudes_e'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_aceptar' value='Aceptar' class='btn btn-success'></p>";
      echo "</form>";
      echo "</td>";
      echo "<td>";
      echo "<form action='login_ok/rechazar2' method='post'>";
      echo "<input id='solicitud' name='solicitud' value='".$datos['solicitudes_e'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_rechazar' value='Rechazar' class='btn btn-danger'></p>";
      echo "</form>";
      echo "</td>";
      echo "</tr>";
    }
    echo "</table>";
  }
  echo "</td>";
}
echo "</tr>";

echo "<tr>";
if (($this->session->userdata('login_persona')=="user") or ($this->session->userdata('login_persona')=="organizacion")){
  echo "<td class='active'><p>MENSAJES</p></td>";
  echo "<td>";
  $cant_notificaciones=count($datos['notificaciones']);
  if ($cant_notificaciones==0){
    echo "<p>No hay notificaciones pendientes</p>";
  }else{
    echo "<table class='table table-striped table-condensed'>";
    echo "<tr class='info'>";
    //echo "<td>Nº de notificacion</td>";
    echo "<td class='col-md-2'><p>Fecha</p></td>";
    echo "<td class='col-md-7'><p>Mensaje</p></td>";    
    echo "<td class='col-md-1'></td>";
    echo "</tr>";
    for ($i=0;$i<$cant_notificaciones;$i++){
      echo "<tr>";
      //echo "<td>".($i+1)."</td>";
      echo "<td><p>".$datos['notificaciones'][$i]["cuando"]."</p></td>";
      echo "<td><p>".$datos['notificaciones'][$i]["mensaje"]."</p></td>";      
      echo "<td>";
      echo "<form action='login_ok/noti_vista' method='post'>";
      echo "<input id='notificacion' name='notificacion' value='".$datos['notificaciones'][$i]['id']."' hidden>";
      echo "<p><input type='submit' id='btn_visto' value='Visto' class='btn btn-info'></p>";
      echo "</form>";
      echo "</td>";
      echo "</tr>";
    }
    echo "</table>";
  }
  echo "</td>";
}
echo "</tr>";

echo "</table>";

echo "</div>";


?>



</body>
 </html>
