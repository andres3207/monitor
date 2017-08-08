<?php
class tiemporeal extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {

   	//$datos["actuales"]=$this->data_model->CargarDatosActuales();
   	//print_r($datos);exit();

    /*
    $fp1 = fopen("/var/www/web/monitor/application/third_party/scripts/temp", "r");
    $fp2 = fopen("/var/www/web/monitor/application/third_party/scripts/hum", "r");
    $datos["temp"]=fgets($fp1);
    $datos["hum"]=fgets($fp2);
    fclose($fp1);
    fclose($fp2); 

    $fp1 = fopen("/var/www/web/monitor/application/third_party/scripts/temp2", "r");
    $fp2 = fopen("/var/www/web/monitor/application/third_party/scripts/hum2", "r");
    $datos["temp2"]=fgets($fp1);
    $datos["hum2"]=fgets($fp2);
    fclose($fp1);
    fclose($fp2); */

    $datos["sensores"]=$this->data_model->CargarSensores();
    $datos["umbrales"]=$this->data_model->CargarLimites();

    $datos["tmp"]=$this->data_model->FuncionTemporal();

   	$data['section_title']='Datos en tiempo real';

		$data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

		$data['layout_body']=$this->load->view('tiemporeal',array("datos"=>$datos),TRUE);

		$this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	//exit();
	
    }

   

    }
?>
