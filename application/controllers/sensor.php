<?php
class sensor extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {

   	$datos["limites"]=$this->data_model->CargarLimites();
   	//print_r($datos);exit();

   	$data['section_title']='Sensor';

		$data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

		$data['layout_body']=$this->load->view('sensor',array("datos"=>$datos),TRUE);

		$this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	//exit();
	
    }

    function guardar(){
    	$temp=$_GET["temp"];
    	$hum=$_GET["hum"];
    	$mac=$_GET["mac"];

	//echo("HOLA");
	//exit();

      if (($temp!="") and ($hum!="") and ($mac!="")) {
        $this->data_model->GuardarSensor($temp,$hum,$mac);
      }

    	
    	redirect('/sensor', 'refresh');

    }
   

    }
?>
