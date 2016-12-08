<?php
 class data_model extends CI_Model
 {

 	function Datos(){
 		$consulta="SELECT * From datos WHERE 1";
 		$query = $this->db->query($consulta);
 		return $query->result_array();
 	}

 	function DatosFiltrados($desde,$hasta){
 		$consulta="SELECT * From datos WHERE (date(cuando)>='".$desde."' and date(cuando) <= '".$hasta."')";
 		//echo $consulta;
 		//exit();
 		$query = $this->db->query($consulta);
 		return $query->result_array();
 	}
 	function Alertas(){
 		$consulta="SELECT * from alertas WHERE 1";
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
	
 }
 ?>
