<?php
class graficos extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {


   	

    $ahora = strtotime("Now");
    $anterior = strtotime("-1 month", $ahora);


    $hasta_actual= date("Y-m-31",$ahora);
    $desde_actual= date("Y-m-01",$ahora);

    $datos["desde_actual"]=$desde_actual;
    $datos["hasta_actual"]=$hasta_actual;

    $hasta_anterior= date("Y-m-31",$anterior);
    $desde_anterior= date("Y-m-01",$anterior);

    $datos["desde_anterior"]=$desde_anterior;
    $datos["hasta_anterior"]=$hasta_anterior;

    $datos["sensores"]=$this->data_model->CargarSensores();
    $datos["cant_sensores"]=count($datos["sensores"]);
    for ($i=0; $i <  $datos["cant_sensores"]; $i++) { 
      $datos["datos_actual"][$i]=$this->data_model->DatosFiltrados3($datos["sensores"][$i]["id"],$desde_actual,$hasta_actual);
      $datos["datos_anterior"][$i]=$this->data_model->DatosFiltrados3($datos["sensores"][$i]["id"],$desde_anterior,$hasta_anterior);
      $datos["nombre_codigo"][$i]=$this->data_model->NombreCodigo($datos["sensores"][$i]["id"]);
      //print_r($this->data_model->DatosFiltrados3($datos["sensores"][$i]["id"],$desde_actual,$hasta_actual));
    }
   	//print_r($datos["datos_actual"][1]);exit();

    $data['section_title']='Sistema de Monitoreo';

    $data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

    $data['layout_body']=$this->load->view('graficos',array("datos"=>$datos),TRUE);

    $this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	
    }

   

    }
?>
