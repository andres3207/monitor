<?php
class registros extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

   public function index()
   {

   	if (isset($_POST['desde'])) {
   		$desde=$_POST['desde'];
   	}else{
   		$desde="0000-00-00";
   	}
   	if (isset($_POST['hasta'])) {
   		$hasta=$_POST['hasta'];
   	}else{
   		$hasta="2099-12-31";
   	}
   	if($desde==''){
   		$desde="0000-00-00";
   	}
   	if($hasta==''){
   		$hasta="2099-12-31";
   	}
   	$datos["desde"]=$desde;
   	$datos["hasta"]=$hasta;
   	/*echo $desde;
   	echo "</br>";
   	echo $hasta;*/
   	//exit();
   	//$datos["datos"]=$this->data_model->Datos();
   	$datos["datos"]=$this->data_model->DatosFiltrados($desde,$hasta);
   	$datos["limites"]=$this->data_model->CargarLimites();
   	//print_r($datos);exit();

   	if (isset($_POST["mostrar"])) {
   		if ($_POST["mostrar"]=="Descargar"){
			set_include_path('/var/www/web/monitor/Classes');
			require_once 'PHPExcel.php';


			
			$objPHPExcel = new PHPExcel();
			$objPHPExcel->getProperties()
			->setCreator("Andres Gomez")
			->setLastModifiedBy("Andres Gomez") //Ultimo usuario que lo modificó
    		->setTitle("Datos de Termometria") // Titulo
    		->setSubject("Datos") //Asunto
    		->setDescription("Registros de Temperatura") //Descripción
    		->setKeywords("Temperatura") //Etiquetas
    		->setCategory("Reporte excel"); //Categorias

    		$tituloReporte = "Registro de Temperatura";
    		$titulosColumnas1 = array('Nº de registro', 'Temperatura', 'Fecha');

        $sensores=$this->data_model->CargarSensores();
        $cant_sensores=count($sensores);
        for ($i=0; $i <$cant_sensores ; $i++) { 
          // Se combinan las celdas A1 hasta D1, para colocar ahí el titulo del reporte
      $objPHPExcel->setActiveSheetIndex($i)
        ->mergeCells('A1:E1');
      // Se agregan los titulos del reporte
      $objPHPExcel->setActiveSheetIndex($i)
        ->setCellValue('A1',$tituloReporte." ".$this->data_model->NombreCodigo($sensores[$i]["id"])) // Titulo del reporte
        ->setCellValue('A3',  $titulosColumnas1[0])  //Titulo de las columnas
        ->setCellValue('B3',  $titulosColumnas1[1])
      ->setCellValue('C3',  $titulosColumnas1[2]);


      $registros=$this->data_model->DatosFiltrados3($sensores[$i]["id"],$desde,$hasta);
      $cant_reg=count($registros);
      for ($j=0; $j <$cant_reg ; $j++) { 
        $objPHPExcel->setActiveSheetIndex($i)
          ->setCellValue('A'.($j+4),  ($j+1))  //Titulo de las columnas
          ->setCellValue('B'.($j+4),  $registros[$j]["temperatura"])
          ->setCellValue('C'.($j+4),  $registros[$j]["cuando"]);
      }

        for($j = 'A'; $j <= 'Z'; $j++){
          $objPHPExcel->setActiveSheetIndex($i)->getColumnDimension($j)->setAutoSize(TRUE);
      }

      $objPHPExcel->getActiveSheet()->setTitle($this->data_model->NombreCodigo($sensores[$i]["id"]));


      $objPHPExcel->setActiveSheetIndex($i)->freezePaneByColumnAndRow(0,4);
      
      $myWorkSheet = new PHPExcel_Worksheet($objPHPExcel," ");
      $objPHPExcel->addSheet($myWorkSheet);
        }

        $objPHPExcel->setActiveSheetIndex(0);
    		
			// Se manda el archivo al navegador web, con el nombre que se indica, en formato 2007
			header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
			header('Content-Disposition: attachment;filename="Registros.xlsx"');
			header('Cache-Control: max-age=0');

$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
$objWriter->save('php://output');


exit();
   		}
   	}
   	$data['section_title']='Termometria Camaras';

		$data['layout_navigation']=$this->load->view('layout_navigation',NULL,TRUE);

		$data['layout_body']=$this->load->view('registros',array("datos"=>$datos),TRUE);

		$this->load->view('layout_sin_sidebar',array("data"=>$data),FALSE);
	//exit();
	
    }

   

    }
?>
