<?php
class inicio extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {
   	$data['section_title']='REDACCIÓN DE NOTICIAS';

		$data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

		$data['layout_body']=$this->load->view('inicio',array("data"=>$data),TRUE);

		$this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	//exit();
	
    }

   

    }
?>
