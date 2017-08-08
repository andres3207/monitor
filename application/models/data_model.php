<?php
 class data_model extends CI_Model
 {

 	function Datos(){
 		$consulta="datos()";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}

 	function DatosFiltrados($desde,$hasta){
 		$consulta="datos_filtrados('".$desde."','".$hasta."')";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}
 	function DatosFiltrados2($desde,$hasta){
 		$consulta="datos_filtrados_2('".$desde."','".$hasta."')";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}
 	function Alertas(){
 		$consulta="alertas()";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}

 	function ActualizarLimites($t_min,$t_max,$h_min,$h_max){
 		$consulta="actualizar_limites('".$t_min."','".$t_max."','".$h_min."','".$h_max."')";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}
 	function CargarLimites(){
 		$consulta="cargar_limites()";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->row_array();
 	}

 	function BorrarRegistros(){
 		$consulta="borrar_registros()";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}
 	function BorrarAlertas(){
 		$consulta="borrar_alertas()";
 		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
 	}
 	function AgregarCorreo($email){
 		$consulta="Iagregar_correo('".$email."')";
 		$query = $this->db->query("select ".$consulta);
 		return $query->result_array();
 	}
 	function CargarSensores(){
		$consulta="cargar_sensores()";
		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
	}
	function ActualizarSensor($id,$nombre,$estado){
		$consulta="actualizar_sensor(".$id.",'".$nombre."','".$estado."')";
		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
	}
	function NombreCodigo($id_sensor){
		$consulta="nombre_codigo('".$id_sensor."')";
		$query = $this->db->query("select ".$consulta);
		return array_values($query->row_array())[0];
	}
	function GuardarSensor($temp,$hum,$mac){
		$consulta="guardar_sensor('".$temp."','".$hum."','".$mac."')";
		$query = $this->db->query("call ".$consulta);
		$query->next_result();
		return $query->result_array();
	}
	function DatosFiltrados3($id_sensor,$desde,$hasta){
		$consulta="datos_filtrados_3(".$id_sensor.",'".$desde."','".$hasta."')";
		$query = $this->db->query("call ".$consulta);
 		$query->next_result();
		return $query->result_array();
	}
	function FuncionTemporal(){
		$consulta="select * from temporal where id=1";
		$query=$this->db->query($consulta);
		return $query->result_array()[0];
	}
 }
 ?>
