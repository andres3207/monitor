<?php
class lista_sensores extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {

   	$datos["sensores"]=$this->data_model->CargarSensores();
    $datos["camaras"]=$this->data_model->CargarCamaras();
   	//print_r($datos);exit();

   	$data['section_title']='Lista de Sensores del Sistema';

		$data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

		$data['layout_body']=$this->load->view('lista_sensores',array("datos"=>$datos),TRUE);

		$this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	//exit();
	
    }

    function guardar(){
      $cant_sensores=$this->input->post('cant_sensores');
       //exit();
      for ($i=0; $i < $cant_sensores ; $i++) { 
        $id=$this->input->post('id_sensor-'.$i);
        $nombre=$this->input->post('nombre_sensor-'.$i);
        $estado=$this->input->post('estado_sensor-'.$i);
        $this->data_model->ActualizarSensor($id,$nombre,$estado);
      }

      $cant_camaras=$this->input->post('cant_camaras');
      for ($i=0; $i < $cant_camaras ; $i++) { 
        $id=$this->input->post('id_cam-'.$i);
        $nombre=$this->input->post('nombre_cam-'.$i);
        $this->data_model->ActualizarCamara($id,$nombre);
      }
    	
    	redirect('/lista_sensores', 'refresh');

    }


   

    }
?>
