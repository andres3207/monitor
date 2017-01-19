<?php
class graficos extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {


   	

    $startdate = strtotime("Now");
    $enddate = strtotime("-30 days", $startdate);


    $hasta= date("Y-m-d",$startdate);
    $desde= date("Y-m-d",$enddate);

    $datos["desde"]=$desde;
    $datos["hasta"]=$hasta;

   	/*echo $desde;
   	echo "</br>";
   	echo $hasta;*/
   	//exit();
   	//$datos["datos"]=$this->data_model->Datos();
   	$datos["datos"]=$this->data_model->DatosFiltrados2($desde,$hasta);
   	//print_r($datos);exit();

    $data['section_title']='Sistema de Monitoreo';

    $data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

    $data['layout_body']=$this->load->view('graficos',array("datos"=>$datos),TRUE);

    $this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	
    }

   

    }
?>
