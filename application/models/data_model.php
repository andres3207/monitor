<?php
 class data_model extends CI_Model
 {

 	function Datos(){
 		$consulta="SELECT * From datos WHERE 1";
 		$query = $this->db->query($consulta);
 		return $query->result_array();
 	}

 	function ActualizarLimites($t_min,$t_max,$h_min,$h_max){
 		$consulta="UPDATE configuracion set t_min='".$t_min."',t_max='".$t_max."',h_min='".$h_min."',h_max='".$h_max."' WHERE id=1";
 		$query = $this->db->query($consulta);
 		//return $query->result_array();
 	}
 	function CargarLimites(){
 		$consulta="SELECT t_min,t_max,h_min,h_max From configuracion WHERE id=1";
 		$query = $this->db->query($consulta);
 		return $query->row_array();
 	}
	function ValidarUsuario($cuil,$password)
	{  /* //   Consulta Mysql para buscar en la tabla Usuario aquellos usuarios que coincidan con el mail y password ingresados en pantalla de login
		$query = $this->db->where('dni',$dni);
		//   La consulta se efectúa mediante Active Record. Una manera alternativa, y en lenguaje más sencillo, de generar las consultas Sql.
		$query = $this->db->where('contrasenia',$password);
		// mientras que las contraseñas sean iguales
		$query = $this->db->get('personas_fisicas');

		$query2 = $this->db->where('cuit',$dni);
		//   La consulta se efectúa mediante Active Record. Una manera alternativa, y en lenguaje más sencillo, de generar las consultas Sql.
		$query2 = $this->db->where('contrasenia',$password);
		// mientras que las contraseñas sean iguales
		$query2 = $this->db->get('personas_juridicas');
		//   Devolvemos al controlador la fila que coincide con la búsqueda. (FALSE en caso que no existir coincidencias)

		if (count($query->row_array())>0) {
		return array($query->row_array(),0);
		}
		elseif (count($query2->row_array())>0) {
		 return array($query2->row_array(),1);
		}
		else return array(false,false); */
		$consulta="existe_usuario_pass('".$cuil."','".$password."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->result_array());exit();
		return $query->row_array()[$consulta];
	}
	function Login($cuil,$pass)
	{
		$consulta="login('".$cuil."','".$pass."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function LogOut($cuil)
	{
		$consulta="logout('".$cuil."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function LogOutAdmin($nombre)
	{
		$consulta="logout_admin('".$nombre."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function LoginAdmin($usuario,$pass)
	{
		$consulta="login_admin('".$usuario."','".$pass."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function ExisteUsuario($cuil)
	{
		$consulta="existe_usuario('".$cuil."')";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function ExisteAdmin($nombre)
	{
		$consulta="existe_admin('".$nombre."')";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function ExisteAdminPass($nombre,$pass)
	{
		$consulta="existe_admin_pass('".$nombre."','".$pass."')";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function CambiarPassAdmin($nombre,$pass,$quien)
	{
		$consulta="cambiar_pass_admin('".$nombre."','".$pass."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function CambiarPassUsuarioMismo($cuil,$pass_old,$pass_new,$quien)
	{
		$consulta="cambiar_pass_usuario_mismo('".$cuil."','".$pass_old."','".$pass_new."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function CambiarPassUsuario($cuil,$pass_new,$quien)
	{
		$consulta="cambiar_pass_usuario('".$cuil."','".$pass_new."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
  function CambiarPassOrganizacion($cuit,$pass_new,$quien)
	{
		$consulta="cambiar_pass_organizacion('".$cuit."','".$pass_new."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function CambiarPassOrganizacionMisma($cuit,$pass_old,$pass_new,$quien)
	{
		$consulta="cambiar_pass_organizacion_misma('".$cuit."','".$pass_old."','".$pass_new."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function ExisteOrganizacion($cuit)
	{
		$consulta="existe_organizacion('".$cuit."')";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function EstadoParticipanteProyecto($id_part,$id_pro,$pro_act)
	{
		$consulta="estado_participante_proyecto(".$id_part.",".$id_pro.",".$pro_act.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function UsuarioHabilitado($cuil)
	{
		$consulta="usuario_habilitado('".$cuil."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function UltimaDevolucion($id,$evaluado,$quien)
	{
		$consulta="obt_ult_visado(".$id.",".$evaluado.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function UltimoExpedienteUA($id,$evaluado,$quien)
	{
		$consulta="obt_ult_exp_ua(".$id.",".$evaluado.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}

	function GuardarVisado($id,$resultado,$expediente,$quien)
	{
		$consulta="visar_proyecto(".$id.",".$quien.",'".$resultado."','".$expediente."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function AprobarVisado($id,$resultado,$expediente,$quien)
	{
		$consulta="aprobar_proyecto_ua(".$id.",".$quien.",'".$resultado."','".$expediente."')";
		//echo $consulta;exit();
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function EnviarRevisionVisado($id,$resultado,$expediente,$quien)
	{
		$consulta="revision_proyecto_ua(".$id.",".$quien.",'".$resultado."','".$expediente."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function EvaluarProyecto($id,$expediente,$codigo,$c1_1,$c1_2,$c1_3,$c1_4,$c2_1,$c3_1,$c3_2,$c4_1,$c5_1,$c5_2,$sub1,$sub2,$sub3,$sub4,$sub5,$total,$o1_1,$o1_2,$o1_3,$o1_4,$o2_1,$o3_1,$o3_2,$o4_1,$o5_1,$o5_2,$cerrada,$quien)
	{
		$consulta="evaluar_proyecto(".$id.",'".$expediente."','".$codigo."','".$c1_1."','".$c1_2."','".$c1_3."','".$c1_4."','".$c2_1."','".$c3_1."','".$c3_2."','".$c4_1."','".$c5_1."','".$c5_2."','".$sub1."','".$sub2."','".$sub3."','".$sub4."','".$sub5."','".$total."','".$o1_1."','".$o1_2."','".$o1_3."','".$o1_4."','".$o2_1."','".$o3_1."','".$o3_2."','".$o4_1."','".$o5_1."','".$o5_2."',".$cerrada.",".$quien.")";
		//echo $consulta;exit();
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function AprobarConFinanciacion($id,$resultado,$quien)
	{
		$consulta="aprobar_uni(".$id.",".$quien.",'".$resultado."',1)";
		//echo $consulta;exit();
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function AprobarSinFinanciacion($id,$resultado,$quien)
	{
		$consulta="aprobar_uni(".$id.",".$quien.",'".$resultado."',0)";
		//echo $consulta;exit();
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function DesaprobarUni($id,$resultado,$quien)
	{
		$consulta="desaprobar_uni(".$id.",".$quien.",'".$resultado."')";
		//echo $consulta;exit();
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function NotificarEvaluacion($id,$mensaje,$quien)
	{
		$consulta="notificar_evaluacion(".$id.",'".$mensaje."',".$quien.")";
		//echo $consulta;exit();
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function SoyDirector($id,$quien)
	{
		$consulta="soy_director(".$id.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function SoyCoDirector($id,$quien)
	{
		$consulta="soy_codirector(".$id.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function ActualizarProyectoMonitorear($id,$cequipo,$res_equipo,$cradicacion,$cpresupuesto,$prorroga,$res_prorroga,$rparcial,$rtotal,$observaciones,$quien)
  {
    $consulta="actualizar_proyecto_monitorear(".$id.",'".$cequipo."','".$res_equipo."','".$cradicacion."','".$cpresupuesto."','".$prorroga."','".$res_prorroga."','".$rparcial."','".$rtotal."','".$observaciones."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
  }
  function EditarConvocatoria($id,$nombre,$inicio,$fin,$quien)
	{
		$consulta="editar_convocatoria(".$id.",'".$nombre."','".$inicio."','".$fin."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function AbrirConvocatoria($nombre,$inicio,$fin,$eval,$tipo,$dependencia,$quien)
	{
		$consulta="abrir_convocatoria('".$nombre."','".$inicio."','".$fin."',".$eval.",".$tipo.",".$dependencia.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	/*function PresentarUA($id,$quien)
	{
		$consulta="presentar_proyecto_ua(".$id.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	} */
	function PresentarProyecto($id,$convocatoria,$quien)
	{
		$consulta="presentar_proyecto(".$id.",".$convocatoria.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function EliminarProyecto($id,$quien)
	{
		$consulta="eliminar_proyecto(".$id.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function DedicacionProyecto($id_proyecto,$rol)
	{
		$consulta="dedicacion_proyecto(".$id_proyecto.",".$rol.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function GuardarBitacora($tipo,$msg,$quien)
	{
		$consulta="guardar_bitacora('".$tipo."','".$msg."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function ParticipacionPersonaProyecto($id_proyecto,$id_persona)
	{
		$consulta="participacion_persona_proyecto(".$id_proyecto.",".$id_persona.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function ExpedienteProyecto($id_proyecto)
	{
		$consulta="expediente_proyecto(".$id_proyecto.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function CodigoProyecto($id_proyecto)
	{
		$consulta="codigo_proyecto(".$id_proyecto.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function ProyectoPresentadoA($id_proyecto)
	{
		$consulta="proyecto_presentado_a(".$id_proyecto.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function FInicioProyecto($id_proyecto)
	{
		$consulta="f_inicio_proyecto(".$id_proyecto.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function SoyDocente($quien)
	{
		$consulta="soy_docente(".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function PersonaCuil($id_persona)
	{
		$consulta="persona_cuil(".$id_persona.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function OrganizacionCuit($id_orga)
	{
		$consulta="organizacion_cuit(".$id_orga.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	/*function NivelUsuario($id)
	{
		$consulta="nivel_usuario(".$id.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	} */
	function GuardarEstructura($deno,$tipo,$dependencia,$descrip,$info,$quien){
		$consulta="guardar_estructura('".$deno."',".$tipo.",".$dependencia.",'".$descrip."','".$info."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function CargarEstructuras($tipo)
	{
		$consulta="cargar_estructuras(".$tipo.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function CargarMisEstructuras($tipo,$tipo_quien,$quien)
	{
		$consulta="cargar_mis_estructuras(".$tipo.",".$tipo_quien.",".$quien.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function DatosUsuario($cuil)
	{
		$consulta="datos_usuario('".$cuil."')";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
  function DatosConvocatoria($id)
	{
		$consulta="datos_convocatoria(".$id.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
	function DatosDirectorProyecto($id)
	{
		$consulta="datos_director_proyecto('".$id."')";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
  function DatosCoDirectorProyecto($id)
	{
		$consulta="datos_codirector_proyecto('".$id."')";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
	function Convocatorias()
	{
		$consulta="convocatorias()";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function ParticipantesProyecto($proyecto)
	{
		$consulta="participantes_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function OrganizacionesProyecto($proyecto)
	{
		$consulta="organizaciones_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function ActosObjeto($objeto,$tipo)
	{
		$consulta="actos_objeto(".$objeto.",".$tipo.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function ProyectosUsuario($usuario)
	{
		$consulta="proyectos_usuario(".$usuario.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function ProyectosOrganizacion($organizacion)
	{
		$consulta="proyectos_organizacion(".$organizacion.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function CargarNoticias($dep)
	{
		$consulta="cargar_noticias(".$dep.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
  function PalabrasProyecto($proyecto)
	{
		$consulta="palabras_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function DestinatariosProyecto($proyecto)
	{
		$consulta="destinatarios_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function BarriosProyecto($proyecto)
	{
		$consulta="barrios_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function LocalidadProyecto($proyecto)
	{
		$consulta="localidad_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function OrganizacionProyecto($proyecto)
	{
		$consulta="organizacion_proyecto(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function EstadisticasProyectos()
	{
		$consulta="estadisticas_proyectos()";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function ObtenerEvaluacion($proyecto)
	{
		$consulta="obtener_evaluacion(".$proyecto.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
	function ConvocatoriaProyecto($id)
	{
		$consulta="convocatoria_proyecto(".$id.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	        $query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
	function BitacoraUsuario($usuario,$desde,$hasta)
	{
		$consulta="bitacora_usuario('".$usuario."','".$desde."','".$hasta."')";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function MisSolicitudesPendientes($cuil_cuit,$proy_act)
	{
		$consulta="mis_solicitudes_pendientes('".$cuil_cuit."',".$proy_act.")";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function MisSolicitudesPendientesEstructuras($cuil_cuit)
	{
		$consulta="mis_solicitudes_pendientes_estructuras('".$cuil_cuit."')";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function MisNotificacionesPendientes($usuario)
	{
		$consulta="mis_notificaciones_pendientes('".$usuario."')";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function ProyectosIds($quien)
	{
		$consulta="proyectos_ids('".$quien."')";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function UsuariosIds($quien)
	{
		$consulta="usuarios_ids('".$quien."')";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
   function UsuariosParaEstructuras()
	{
		$consulta="usuarios_para_estructuras()";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function OrganizacionesParaEstructuras()
	{
		$consulta="organizaciones_para_estructuras()";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function GuardarParticipanteEstructura($id_estru,$id_part,$id_rol,$hab,$quien){
		$consulta="guardar_participante_estructura(".$id_estru.",".$id_part.",".$id_rol.",".$hab.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
	function GuardarOrganizacionEstructura($id_estru,$id_org,$hab,$quien){
		$consulta="guardar_organizacion_estructura(".$id_estru.",".$id_org.",".$hab.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		return array_values($query->row_array())[0];
	}
  function OrganizacionesIds()
	{
		$consulta="organizaciones_ids()";
		//echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function VisarNotificacion($id_noti,$quien)
	{
		$consulta="visar_notificacion('".$id_noti."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function AceptarSolicitud($id_sol,$quien)
	{
		$consulta="aceptar_solicitud('".$id_sol."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function RechazarSolicitud($id_sol,$quien)
	{
		$consulta="rechazar_solicitud('".$id_sol."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function AceptarSolicitudEstructura($id_sol,$quien)
	{
		$consulta="aceptar_solicitud_estructura('".$id_sol."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function EstadoParticipacionEstructura($cuil_cuit,$estruc){
		$consulta="estado_participacion_estructura('".$cuil_cuit."','".$estruc."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function RechazarSolicitudEstructura($id_sol,$quien)
	{
		$consulta="rechazar_solicitud_estructura('".$id_sol."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function CrearNoticia($dependencia,$mensaje,$quien)
	{
		$consulta="crear_noticia('".$dependencia."','".$mensaje."','".$quien."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function ProyectoAvalado($id_proyecto)
	{
		$consulta="proyecto_avalado('".$id_proyecto."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function DependenciaPersonaReal($id_persona)
	{
		$consulta="dependencia_persona_real('".$id_persona."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function EjecutarProyecto($id_proyecto,$quien)
	{
		$consulta="ejecutar_proyecto(".$id_proyecto.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function FinalizarProyecto($id_proyecto,$quien)
	{
		$consulta="finalizar_proyecto(".$id_proyecto.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function DesistirDelProyecto($id_proyecto,$quien)
	{
		$consulta="desistir_del_proyecto(".$id_proyecto.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function CambiarEstadoProyecto($id_proyecto,$estado,$quien)
	{
		$consulta="cambiar_estado_proyecto(".$id_proyecto.",".$estado.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function CambiarCodigoProyecto($id_proyecto,$codigo,$quien)
	{
		$consulta="cambiar_codigo_proyecto(".$id_proyecto.",'".$codigo."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function CambiarDirectorProyecto($id_proyecto,$id_director,$dedicacion,$hs_sem,$honorarios,$quien)
	{
		$consulta="cambiar_director_proyecto(".$id_proyecto.",".$id_director.",'".$id_director."','".$id_director."','".$id_director."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function GuardarActo($objeto,$t_objeto,$t_acto,$n_acto,$detalles,$expediente,$quien)
	{
		$consulta="guardar_acto_2(".$objeto.",".$t_objeto.",".$t_acto.",".$n_acto.",'".$detalles."','".$expediente."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  /*function GuardarActo2($proyecto,$p_a,$tipo,$descripcion,$expediente,$UA_UNI,$quien)
	{
		$consulta="guardar_acto_2(".$proyecto.",".$p_a.",".$tipo.",'".$descripcion."','".$expediente."','".$UA_UNI."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	} */
	function ConvocatoriasVigentes()
	{
		$consulta="convocatorias_vigentes()";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function DatosOrganizacion($cuit)
	{
		$consulta="datos_organizacion('".$cuit."')";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
	function TablaEvaluacion()
	{
		$consulta="tabla_evaluacion()";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
                $query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
  function ProyectosMonitorear($quien)
	{
		$consulta="proyectos_monitorear(".$quien.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
                $query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function DatosAdmin($usuario)
	{
		$consulta="datos_administrador('".$usuario."')";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->row_array();
	}
	function Administradores()
	{
		$consulta="administradores()";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function ProyectosNoBorrador($quien)
	{
		$consulta="proyectos_no_borrador(".$quien.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($query->row_array());exit();
		//$query->close();
    	$query->next_result();
    	//$mysqli->next_result();
		return $query->result_array();
	}
	function MisProyectos($quien)
	{
		$consulta="mis_proyectos(".$quien.")";
		$query = $this->db->query('call '.$consulta);
    	$query->next_result();
		return $query->result_array();
	}
  function MisProyectosOrg($quien)
	{
		$consulta="mis_proyectos_org(".$quien.")";
		$query = $this->db->query('call '.$consulta);
    	$query->next_result();
		return $query->result_array();
	}
	function AsignarUsuarioGrupo($usuario,$grupo,$quien) //Borrar funcion
	{
		$consulta="asignar_usuario_grupo(".$usuario.",".$grupo.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function ConvocatoriaVigente()
	{
		$consulta="convocatoria_vigente()";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function FEntregaAvance($proyecto)
	{
		$consulta="select f_entrega_avance(".$proyecto.")";
		$query = $this->db->query($consulta);
    //echo $consulta;
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function FEntregafinal($proyecto)
	{
		$consulta="f_entrega_final(".$proyecto.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function EliminarUsuarioGrupos($usuario,$quien) //Borrar
	{
		$consulta="eliminar_usuario_grupos(".$usuario.",".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];

	}
	function DependenciaPersona($usuario)
	{
		$consulta="dependencia_persona(".$usuario.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];

	}
	function Bitacora($id)
	{
		$consulta="bitacora(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function Organizaciones()
	{
		$consulta="organizaciones()";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function Universidades()
	{
		$consulta="universidades()";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function DatosProyecto($id)
	{
		$consulta="datos_proyecto(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->row_array();
	}
	function DatosEstructura($id)
	{
		$consulta="datos_estructura(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->row_array();
	}
	function IntegrantesProyecto($id)
	{
		$consulta="integrantes_proyecto(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function IntegrantesEstructura($id)
	{
		$consulta="integrantes_estructura(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function OrganizacionesEstructura($id)
	{
		$consulta="organizaciones_estructura(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function ProyectosEstructura($id)
	{
		$consulta="proyectos_estructura(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function ActividadesEstructura($id)
	{
		$consulta="actividades_estructura(".$id.")";
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function ProyectosUAEstado($estado,$quien)
	{
		$consulta="proyectos_ua_estado(".$quien.",".$estado.")";
    //echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
  function ProyectosParaAprobar($quien)
	{
		$consulta="proyectos_para_aprobar(".$quien.")";
    //echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
  function ProyectosParaAvalar($quien)
	{
		$consulta="proyectos_para_avalar(".$quien.")";
    //echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
  function ProyectosParaEvaluar()
	{
		$consulta="proyectos_para_evaluar()";
    //echo $consulta;exit();
		$query = $this->db->query('call '.$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function UsuariosDepend($id)
	{
		$consulta="usuarios_ua(".$id.")";
		$query = $this->db->query('call '.$consulta);
		//print_r($consulta);exit();
		//print_r($query->result_array());exit();
		$query->next_result();
		return $query->result_array();
	}
	function HabilitarUser($cuil,$quien)
	{
		$consulta="habilitar_usuario('".$cuil."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function HabilitarOrg($cuit,$quien)
	{
		$consulta="habilitar_organizacion('".$cuit."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function DeshabilitarUser($cuil,$quien)
	{
		$consulta="deshabilitar_usuario('".$cuil."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
  function DeshabilitarOrg($cuit,$quien)
	{
		$consulta="deshabilitar_organizacion('".$cuit."',".$quien.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function Dependencia($id)
	{
		$consulta="dependencia(".$id.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function PersonaId($cuil)
	{
		$consulta="persona_id('".$cuil."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function OrganizacionId($cuit)
	{
		$consulta="organizacion_id('".$cuit."')";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function PersonaAdmin($id)
	{
		$consulta="persona_admin(".$id.")";
		$query = $this->db->query('select '.$consulta);
		//print_r($query->row_array());exit();
		return array_values($query->row_array())[0];
	}
	function NuevoUsuario($datos){
	/*$this->db->set('dni',$datos['dni']);
	$this->db->set('apellido',$datos['apellido']);
	$this->db->set('nombre',$datos['nombre']);
	$this->db->set('contrasenia',$datos['contrasenia']);
	$this->db->set('email',$datos['email']);
	$this->db->set('categoria',$datos['categoria']);
	$this->db->set('dependencia',$datos['dependencia']);
	$this->db->set('fecha_nac',$datos['fecha_nac']);
	$this->db->set('lugar_nac',$datos['lugar_nac']);
	$this->db->set('nacionalidad',$datos['nacionalidad']);
	$this->db->set('cuil',$datos['cuil']);
	$this->db->set('estado_civil',$datos['estado_civil']);
	$this->db->set('cant_hijos',$datos['cant_hijos']);
	$this->db->set('calle_res',$datos['calle_res']);
	$this->db->set('nro_res',$datos['nro_res']);
	$this->db->set('piso_res',$datos['piso_res']);
	$this->db->set('dto_res',$datos['dto_res']);
	$this->db->set('localidad_res',$datos['localidad_res']);
	$this->db->set('provincia_res',$datos['provincia_res']);
	$this->db->set('cp_res',$datos['cp_res']);
	$this->db->set('calle_lab',$datos['calle_lab']);
	$this->db->set('nro_lab',$datos['nro_lab']);
	$this->db->set('piso_lab',$datos['piso_lab']);
	$this->db->set('dto_lab',$datos['dto_lab']);
	$this->db->set('localidad_lab',$datos['localidad_lab']);
	$this->db->set('provincia_lab',$datos['provincia_lab']);
	$this->db->set('cp_lab',$datos['cp_lab']);
	$this->db->set('area_per',$datos['area_per']);
	$this->db->set('tel_per',$datos['tel_per']);
	$this->db->set('area_lab',$datos['area_lab']);
	$this->db->set('tel_lab',$datos['tel_lab']);
	$this->db->set('int_lab',$datos['int_lab']);
	$this->db->set('area_movil',$datos['area_movil']);
	$this->db->set('tel_movil',$datos['tel_movil']);
	$this->db->set('email_per',$datos['email_per']);
	$this->db->set('email_lab',$datos['email_lab']);
	$this->db->set('sitio_web',$datos['sitio_web']);*/

	$consulta="nueva_persona('".$datos['dni']."','".$datos['apellido']."','".$datos['nombre']."','".$datos['contrasenia']."','".$datos['email']."','".$datos['titulo']."','".$datos['categoria']."','".$datos['tipo']."','".$datos['dependencia']."'
          ,'".$datos['otra_dependencia']."','".$datos['cargo']."','".$datos['dedicacion']."','".$datos['condicion']."','".$datos['estado']."'
					,'".$datos['fecha_nac']."','".$datos['lugar_nac']."','".$datos['nacionalidad']."','".$datos['cuil']."','".$datos['estado_civil']."','".$datos['cant_hijos']."','".$datos['calle_res']."',
                    '".$datos['nro_res']."','".$datos['piso_res']."','".$datos['dto_res']."','".$datos['localidad_res']."','".$datos['provincia_res']."','".$datos['cp_res']."','".$datos['calle_lab']."','".$datos['nro_lab']."',
                    '".$datos['piso_lab']."','".$datos['dto_lab']."','".$datos['localidad_lab']."','".$datos['provincia_lab']."','".$datos['cp_lab']."','".$datos['area_per']."','".$datos['tel_per']."',
                    '".$datos['area_lab']."','".$datos['tel_lab']."','".$datos['int_lab']."','".$datos['area_movil']."','".$datos['tel_movil']."','".$datos['email_lab']."','".$datos['sitio_web']."','".$datos['cv_cuil']."',0)";

        //print_r($datos);echo $consulta;exit();

	$query = $this->db->query('select '.$consulta);
		//print_r(array_values($query->row_array()));exit();
		return array_values($query->row_array())[0];

	}
	function NuevoAdmin($datos,$quien)
	{
		$consulta="nuevo_admin('".$datos['usuario']."','".$datos['contrasenia']."','".$datos['dependencia']."','".$datos['permisos']."',".$quien.")";

	$query = $this->db->query('select '.$consulta);
		//print_r(array_values($query->row_array()));exit();
		return array_values($query->row_array())[0];

	}
	function NuevaOrganizacion($datos){
	/*$this->db->set('cuit',$datos['cuit']);
	$this->db->set('razon',$datos['razon']);
	$this->db->set('email_login',$datos['email_login']);
	$this->db->set('contrasenia',$datos['contrasenia']);
	$this->db->set('categoria',$datos['categoria']);
	$this->db->set('calle',$datos['calle']);
	$this->db->set('nro',$datos['nro']);
	$this->db->set('piso',$datos['piso']);
	$this->db->set('dto',$datos['dto']);
	$this->db->set('localidad',$datos['localidad']);
	$this->db->set('provincia',$datos['provincia']);
	$this->db->set('cp',$datos['cp']);
	$this->db->set('area_fijo',$datos['area_fijo']);
	$this->db->set('tel_fijo',$datos['tel_fijo']);
	$this->db->set('area_movil',$datos['area_movil']);
	$this->db->set('tel_movil',$datos['tel_movil']);
	$this->db->set('email',$datos['email']);
	$this->db->set('sitio_web',$datos['sitio_web']);
	$this->db->set('rep_apellido',$datos['rep_apellido']);
	$this->db->set('rep_nombre',$datos['rep_nombre']);
	$this->db->set('rep_dni',$datos['rep_dni']);
	$this->db->set('rep_calle',$datos['rep_calle']);
	$this->db->set('rep_nro',$datos['rep_nro']);
	$this->db->set('rep_piso',$datos['rep_piso']);
	$this->db->set('rep_dto',$datos['rep_dto']);
	$this->db->set('rep_localidad',$datos['rep_localidad']);
	$this->db->set('rep_provincia',$datos['rep_provincia']);
	$this->db->set('rep_cp',$datos['rep_cp']);
	$this->db->set('rep_tel_lab_area',$datos['rep_tel_lab_area']);
	$this->db->set('rep_tel_lab_nro',$datos['rep_tel_lab_nro']);
	$this->db->set('rep_tel_lab_int',$datos['rep_tel_lab_int']);
	$this->db->set('rep_movil_area',$datos['rep_movil_area']);
	$this->db->set('rep_movil_numero',$datos['rep_movil_numero']);
	$this->db->set('rep_email',$datos['rep_email']);

	return $this->db->insert('personas_juridicas'); */
	$consulta="nueva_organizacion('".$datos['cuit']."','".$datos['razon']."','".$datos['email_login']."','".$datos['contrasenia']."',
								  '".$datos['categoria']."','".$datos['calle']."','".$datos['nro']."','".$datos['piso']."','".$datos['dto']."',
								  '".$datos['localidad']."','".$datos['provincia']."','".$datos['cp']."','".$datos['area_fijo']."','".$datos['tel_fijo']."',
								  '".$datos['area_movil']."','".$datos['tel_movil']."','".$datos['email']."','".$datos['sitio_web']."','".$datos['rep_apellido']."',
								  '".$datos['rep_nombre']."','".$datos['rep_dni']."','".$datos['rep_calle']."','".$datos['rep_nro']."','".$datos['rep_piso']."',
								  '".$datos['rep_dto']."','".$datos['rep_localidad']."','".$datos['rep_provincia']."','".$datos['rep_cp']."','".$datos['rep_tel_lab_area']."',
								  '".$datos['rep_tel_lab_nro']."','".$datos['rep_tel_lab_int']."','".$datos['rep_movil_area']."','".$datos['rep_movil_numero']."',
								  '".$datos['rep_email']."',0)";
	$query = $this->db->query('select '.$consulta);
		//print_r(array_values($query->row_array()));exit();
	return array_values($query->row_array())[0];
	}

	function ActualizarUsuario($datos,$quien){
	/*$this->db->set('email',$datos['email']);
	$this->db->set('categoria',$datos['categoria']);
	$this->db->set('dependencia',$datos['dependencia']);
	$this->db->set('calle_res',$datos['calle_res']);
	$this->db->set('nro_res',$datos['nro_res']);
	$this->db->set('piso_res',$datos['piso_res']);
	$this->db->set('dto_res',$datos['dto_res']);
	$this->db->set('localidad_res',$datos['localidad_res']);
	$this->db->set('provincia_res',$datos['provincia_res']);
	$this->db->set('cp_res',$datos['cp_res']);
	$this->db->set('calle_lab',$datos['calle_lab']);
	$this->db->set('nro_lab',$datos['nro_lab']);
	$this->db->set('piso_lab',$datos['piso_lab']);
	$this->db->set('dto_lab',$datos['dto_lab']);
	$this->db->set('localidad_lab',$datos['localidad_lab']);
	$this->db->set('provincia_lab',$datos['provincia_lab']);
	$this->db->set('cp_lab',$datos['cp_lab']);
	$this->db->set('area_per',$datos['area_per']);
	$this->db->set('tel_per',$datos['tel_per']);
	$this->db->set('area_lab',$datos['area_lab']);
	$this->db->set('tel_lab',$datos['tel_lab']);
	$this->db->set('int_lab',$datos['int_lab']);
	$this->db->set('area_movil',$datos['area_movil']);
	$this->db->set('tel_movil',$datos['tel_movil']);
	$this->db->set('email_lab',$datos['email_lab']);
	$this->db->set('sitio_web',$datos['sitio_web']);

	$this->db->where('dni',$this->session->userdata('login_dni'));
	$this->db->update('personas_fisicas'); */

	$consulta="actualizar_usuario('".$datos['nombre']."','".$datos['apellido']."','".$datos['email']."','".$datos["titulo"]."','".$datos['categoria']."','".$datos['tipo']."','".$datos['dependencia']."'
          ,'".$datos['otra_dependencia']."','".$datos['cargo']."','".$datos['dedicacion']."','".$datos['condicion']."','".$datos['estado']."','".$datos['calle_res']."',
								'".$datos['nro_res']."','".$datos['piso_res']."','".$datos['dto_res']."','".$datos['localidad_res']."',
								'".$datos['provincia_res']."','".$datos['cp_res']."','".$datos['calle_lab']."','".$datos['nro_lab']."',
								'".$datos['piso_lab']."','".$datos['dto_lab']."','".$datos['localidad_lab']."','".$datos['provincia_lab']."',
								'".$datos['cp_lab']."','".$datos['area_per']."','".$datos['tel_per']."','".$datos['area_lab']."',
								'".$datos['tel_lab']."','".$datos['int_lab']."','".$datos['area_movil']."','".$datos['tel_movil']."',
								'".$datos['email_lab']."','".$datos['sitio_web']."',".$quien.")";
	$query = $this->db->query('select '.$consulta);
		//print_r(array_values($query->row_array()));exit();
	return array_values($query->row_array())[0];

	}

	function ActualizarOrganizacion($datos,$quien){
	/*$this->db->set('email_login',$datos['email_login']);
	$this->db->set('categoria',$datos['categoria']);
	$this->db->set('calle',$datos['calle']);
	$this->db->set('nro',$datos['nro']);
	$this->db->set('piso',$datos['piso']);
	$this->db->set('dto',$datos['dto']);
	$this->db->set('localidad',$datos['localidad']);
	$this->db->set('provincia',$datos['provincia']);
	$this->db->set('cp',$datos['cp']);
	$this->db->set('area_fijo',$datos['area_fijo']);
	$this->db->set('tel_fijo',$datos['tel_fijo']);
	$this->db->set('area_movil',$datos['area_movil']);
	$this->db->set('tel_movil',$datos['tel_movil']);
	//$this->db->set('email',$datos['email']);
	$this->db->set('sitio_web',$datos['sitio_web']);
	$this->db->set('rep_apellido',$datos['rep_apellido']);
	$this->db->set('rep_nombre',$datos['rep_nombre']);
	$this->db->set('rep_dni',$datos['rep_dni']);
	$this->db->set('rep_calle',$datos['rep_calle']);
	$this->db->set('rep_nro',$datos['rep_nro']);
	$this->db->set('rep_piso',$datos['rep_piso']);
	$this->db->set('rep_dto',$datos['rep_dto']);
	$this->db->set('rep_localidad',$datos['rep_localidad']);
	$this->db->set('rep_provincia',$datos['rep_provincia']);
	$this->db->set('rep_cp',$datos['rep_cp']);
	$this->db->set('rep_tel_lab_area',$datos['rep_tel_lab_area']);
	$this->db->set('rep_tel_lab_nro',$datos['rep_tel_lab_nro']);
	$this->db->set('rep_tel_lab_int',$datos['rep_tel_lab_int']);
	$this->db->set('rep_movil_area',$datos['rep_movil_area']);
	$this->db->set('rep_movil_numero',$datos['rep_movil_numero']);
	$this->db->set('rep_email',$datos['rep_email']);

	$this->db->where('cuit',$this->session->userdata('login_cuit'));
	$this->db->update('personas_juridicas'); */

	$consulta="actualizar_organizacion('".$datos['email_login']."','".$datos['categoria']."','".$datos['calle']."','".$datos['nro']."',
									'".$datos['piso']."','".$datos['dto']."','".$datos['localidad']."','".$datos['provincia']."',
									'".$datos['cp']."','".$datos['area_fijo']."','".$datos['tel_fijo']."','".$datos['area_movil']."',
									'".$datos['tel_movil']."','".$datos['sitio_web']."','".$datos['rep_apellido']."','".$datos['rep_nombre']."',
									'".$datos['rep_dni']."','".$datos['rep_calle']."','".$datos['rep_nro']."','".$datos['rep_piso']."',
									'".$datos['rep_dto']."','".$datos['rep_localidad']."','".$datos['rep_provincia']."','".$datos['rep_cp']."',
									'".$datos['rep_tel_lab_area']."','".$datos['rep_tel_lab_nro']."','".$datos['rep_tel_lab_int']."','".$datos['rep_movil_area']."',
									'".$datos['rep_movil_numero']."','".$datos['rep_email']."','".$quien."')";
	$query = $this->db->query('select '.$consulta);
		//print_r(array_values($query->row_array()));exit();
	return array_values($query->row_array())[0];
	}

	/*function Obt_Solicitudes($dni_cuil){
	return $this->db->query('SELECT * FROM solicitudes WHERE Para="'.$dni_cuil.'"')->result_array();
	}
	function Obt_Solicitudes_Pend($dni_cuil){
	return $this->db->query('SELECT * FROM solicitudes WHERE Para="'.$dni_cuil.'" and Pendiente=1')->result_array();
	}
	function Obt_SolicitudById($id){
	return $this->db->query('SELECT * FROM solicitudes WHERE id="'.$id.'"')->result_array();
	}
	function Acept_Sol($id){

	$this->db->query('UPDATE solicitudes SET Pendiente=0,Aceptado=1 WHERE id='.$id);
	}
	function Rech_Sol($id){

	$this->db->query('UPDATE solicitudes SET Pendiente=0,Rechazado=1 WHERE id='.$id);
	}

	function Obt_Usuarios($tabla)
	{
		//$this->db->where('*');
		if ($tabla==0){
		return $this->db->query('SELECT * FROM personas_fisicas WHERE 1 ORDER BY dni')->result_array();
		}elseif ($tabla==1){
		return $this->db->query('SELECT * FROM personas_juridicas WHERE 1 ORDER BY cuit')->result_array();
		}else return false;
	}


	function Obt_Usuario_Dni($dni)
	{
		if($this->session->userdata('login_persona')=="fisica"){
		  $this->db->where('dni',$dni);
		  return $this->db->get('personas_fisicas')->result_array();
		}else{
		  $this->db->where('cuit',$dni);
		  return $this->db->get('personas_juridicas')->result_array();
		}
	}

	// CHEQUEA LA EXISTENCIA DEL EMAIL, USADO PARA EL REGISTRO ## Se puede borrar esta funcion, reemplazada por "ExisteUsuario"
	function Check_Cuil($cuil)
	{
		$query = $this->db->query('SELECT cuil FROM personas WHERE cuil = "' . trim($cuil) . '"');
		// chequeo la cantidad de registros con ese email en la tabla de usuarios
		return $query->num_rows();
	}
	// ESTA FUNCION CHEQEA QUE EL PASSWORD SEA DE EL USUARIO INDICADO
	function Check_pass($password)
	{
		if ( $this->session->userdata('login_persona')=="fisica"){
		  $query = $this->db->query('SELECT contrasenia FROM personas_fisicas WHERE id = ' . $this->session->userdata('login_id'));
		  // chequeo la cantidad de registros con ese email en la tabla de usuarios
		  return($query->row_array());
		  }else{
		    $query = $this->db->query('SELECT contrasenia FROM personas_juridicas WHERE id = ' . $this->session->userdata('login_id'));
		    // chequeo la cantidad de registros con ese email en la tabla de usuarios
		    return($query->row_array());
		  }
	}
	//Actualizar password
	function Update_pass($password)
	{
	      if ( $this->session->userdata('login_persona')=="fisica"){
		$this->db->where('id',$this->session->userdata('login_id'));
		$this->db->set('contrasenia', $password);
		$this->db->update("personas_fisicas");
		return $this->db->_error_number();
		}else{
		$this->db->where('id',$this->session->userdata('login_id'));
		$this->db->set('contrasenia', $password);
		$this->db->update("personas_juridicas");
		return $this->db->_error_number();


		}
	}
	function Obt_proyectos_By_Int($id_int)
	{
            return $this->db->query('SELECT * FROM proyectos WHERE id_director='.$id_int.' or id_co_director='.$id_int.' or id_int_1='.$id_int.' or id_int_2='.$id_int.' or id_int_3='.$id_int.' or id_int_4='.$id_int)->result_array();
	}
	function Obt_proyectos_All()
	{
            return $this->db->query('SELECT * FROM proyectos WHERE 1')->result_array();
	}
	function Agregar_eval($id_eval){
	  $this->db->query('UPDATE personas_fisicas SET evaluador=1 WHERE id='.$id_eval);
	}
	function Quitar_eval($id_eval){
	  $this->db->query('UPDATE personas_fisicas SET evaluador=0 WHERE id='.$id_eval);
	} */
 }
 ?>
