<?php
class inicio extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {

   	$datos["datos"]=$this->data_model->Datos();
   	$datos["limites"]=$this->data_model->CargarLimites();
   	//print_r($datos);exit();

   	$data['section_title']='Sistema de Monitoreo';

		$data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

		$data['layout_body']=$this->load->view('inicio',array("datos"=>$datos),TRUE);

		$this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	//exit();
	
    }

   

    }
?>
