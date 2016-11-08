<?php
 class Login extends CI_Controller {

   public function index()
    {


	   //   $this->config->set_item('language', 'spanish');      //   Setear dinámicamente el idioma que deseamos que ejecute nuestra aplicación
       if(!isset($_POST['cuillogin']))
	   {   //   Si no recibimos ningún valor proveniente del formulario, significa que el usuario recién ingresa.
	   //echo "hola";exit();
	  $this->session->sess_destroy();
          $this->load->view('portada');      //   Por lo tanto le presentamos la pantalla del formulario de ingreso.
       }
       else
	/*   {
	   	                //   Si el usuario ya pasó por la pantalla inicial y presionó el botón "Ingresar"
          $this->form_validation->set_rules('dnilogin','dni','required|numeric');      //   Configuramos las validaciones ayudandonos con la librería form_validation del Framework Codeigniter
          $this->form_validation->set_rules('passwordlogin','password','required');
          if(($this->form_validation->run()==FALSE))
		  {            //   Verificamos si el usuario superó la validación
             $this->load->view('portada');                     //   En caso que no, volvemos a presentar la pantalla de login
          }
          else */
		  {	 //   Si ambos campos fueron correctamente rellanados por el usuario,
	     // echo "HOLA";exit();
             //$this->load->model('usuarios_model');

          //   if(isset($_POST['cuillogin'])){
             //Usuario Normal

             //$ExisteUsuarioyPassword=$this->data_model->ValidarUsuario($_POST['cuillogin'],$_POST['passwordlogin']);   //   comprobamos que el usuario exista en la base de datos y la password ingresada sea correcta
             //print_r($ExisteUsuarioyPassword); exit();
             //if($ExisteUsuarioyPassword)
             	$msg_login=$this->data_model->Login($_POST['cuillogin'],$_POST['passwordlogin']);
             	if($msg_login=="Usuario logueado correctamente")
			   {   // La variable $ExisteUsuarioyPassoword recibe valor TRUE si el usuario existe y FALSE en caso que no. Este valor lo determina el modelo.
			      //$this->data_model->PersonaAdmin(15);
			      $datos_user=$this->data_model->DatosUsuario($_POST['cuillogin']);
			      //$nivel_user=$this->data_model->NivelUsuario($datos_user['id']);
				     //exit();
			      //print_r($datos_user);exit();
			      /*	if($this->data_model->PersonaAdmin($datos_user['id'])){
			      		$session_login = array(
                 'login_persona' =>'admin',
                 'login_id' => $datos_user['id'],
                 'login_nombre' => $datos_user['nombre'],
                 'login_apellido' => $datos_user['apellido'],
                 'login_depend' => $datos_user['id_dependencia'],
                 'login_activo' => True,
                 );
			      	}else{ */
                 $session_login = array(
                 'login_persona' =>'user',
                 'login_id' => $datos_user['id'],
                 'login_nombre' => $datos_user['nombre'],
                 'login_apellido' => $datos_user['apellido'],
                 'login_cuil' => $datos_user['cuil'],
                 'login_depend' => $datos_user['id_dependencia'],
                 'login_activo' => True,
                 'login_email' => $datos_user['email'],
            );
              //}

				$this->session->set_userdata($session_login);
				redirect('login_ok', 'refresh');
            }
             elseif($msg_login=="Organizacion logueada correctamente"){
             	$datos_user=$this->data_model->DatosOrganizacion($_POST['cuillogin']);
             	$session_login = array(
                 'login_persona' =>'organizacion',
                 'login_id' => $datos_user['id'],
                 'login_cuit' => $datos_user['cuit'],
                 'login_nombre' => $datos_user['razon'],
                 'rep_apellido' => $datos_user['rep_apellido'],
                 'rep_nombre' => $datos_user['rep_nombre'],
                 'login_activo' => True,
            );
             	$this->session->set_userdata($session_login);
				redirect('login_ok', 'refresh');

             }
             elseif ($msg_login=="Usuario deshabilitado"){
			 			$session_login2 = array(
                 'cuil' =>$_POST['cuillogin'],
            		);
            		$this->session->set_userdata($session_login2);
			 			$datos['persona']=$this->data_model->DatosUsuario($_POST['cuillogin']);
			 			$datos['universidades']=$this->data_model->Universidades();
                        $datos['organizaciones']=$this->data_model->organizaciones();
						$data['layout_body']=$this->load->view('edit_fisica',array('datos'=>$datos),TRUE);
						$data['layout_navigation']='';
						$data['section_title']='Edicion de informacion personal (Usuario Deshabilitado)';
      				$this->load->view('layout_sin_sidebar',array('data'=>$data),FALSE);
			 		}elseif ($msg_login=="Organizacion deshabilitada"){
         $session_login2 = array(
              'cuit' =>$_POST['cuillogin'],
             );
             $this->session->set_userdata($session_login2);
         $datos['persona']=$this->data_model->DatosOrganizacion($_POST['cuillogin']);
         $data['layout_body']=$this->load->view('edit_juridica',array('datos'=>$datos),TRUE);
         $data['layout_navigation']='';
         $data['section_title']='Edicion de informacion personal (Usuario Deshabilitado)';
           $this->load->view('layout_sin_sidebar',array('data'=>$data),FALSE);
       }else{
			 		$data['error']="Usuario y/o Contraseña incorectos";
                	$this->load->view('portada',array('data'=>$data));   //   Lo regresamos a la pantalla de login y pasamos como parámetro el mensaje de error a presentar en pantalla
                }
          //  }
          /*  elseif (isset($_POST['adminlogin'])){
            //Administrador
            $ExisteAdminyPassword=$this->data_model->ValidarAdmin($_POST['adminlogin'],$_POST['adminpassword']);
            if($ExisteAdminyPassword){
	      $session_login = array(
					  'login_persona' =>'admin',
					  'login_id' => $ExisteAdminyPassword['id'],
					  'login_nombre' => $ExisteAdminyPassword['nombre'],
					  'login_nivel' => $ExisteAdminyPassword['nivel'],
					  'login_activo' => True,
				);
				$this->session->set_userdata($session_login);
				redirect('login_ok', 'refresh');
            }
            else
			 {   //   Si no logró validar
                $data['error']="ADMIN o password incorrecta, por favor vuelva a intentar";
                $this->load->view('portada',array('data'=>$data));   //   Lo regresamos a la pantalla de login y pasamos como parámetro el mensaje de error a presentar en pantalla
             }
            } */
          }
       //}
    }
	function registro1 ()
	{

		$data['section_title']='REGISTRO DE NUEVO USUARIO';
		$data['universidades']=$this->data_model->Universidades();
		$data['organizaciones']=$this->data_model->Organizaciones();
		$data['layout_navigation']='';
		$data['layout_body']=$this->load->view('registro',array('data'=>$data),TRUE);
		$this->load->view('layout_sin_sidebar',array('data'=>$data),FALSE);
	}
	function registro2 ()
	{
		$data['section_title']='REGISTRO DE NUEVA ORGANIZACIÓN';
		$data['layout_navigation']='';
		$data['layout_body']=$this->load->view('registro2',array('data'=>$data),TRUE);
		$this->load->view('layout_sin_sidebar',array('data'=>$data),FALSE);
	}

	function registrar ()
	{
	//echo $this->input->post('login_cat_s');exit();
		if($this->data_model->ExisteUsuario($this->input->post('login_cuil'))==0)
		{
      if($this->input->post('login_cat_s')=='1'){
        $cargo=$this->input->post('cargo');
        $dedicacion=$this->input->post('dedicacion');
        $condicion=$this->input->post('condicion');
        $estado=$this->input->post('estado');
      }else{
        $cargo="";
        $dedicacion="";
        $condicion="";
        $estado="";
      }
		  $datos=array(
		  'dni' =>$this->input->post('cv_dni'),
		  'apellido'=>$this->input->post('cv_apellido'),
		  'nombre'=>$this->input->post('cv_nombre'),
		  'contrasenia'=>$this->input->post('login_contrasenia'),
		  'email'=>$this->input->post('login_email'),
		  'titulo'=>$this->input->post('titulo'),
		  'categoria'=>$this->input->post('login_cat_s'),
		  'tipo'=>$this->input->post('depend_tipo_s'),
		  'dependencia'=>$this->input->post('dependencia'),
		  'otra_dependencia'=>$this->input->post('otra_dependencia'),
      'cargo'=>$cargo,
      'dedicacion'=>$dedicacion,
      'condicion'=>$condicion,
      'estado'=>$estado,
		  'fecha_nac'=>$this->input->post('cv_fecha_nac'),
		  'lugar_nac'=>$this->input->post('cv_lug_nac'),
		  'nacionalidad'=>$this->input->post('cv_nac'),
		  'cuil'=>$this->input->post('login_cuil'),
		  'estado_civil'=>$this->input->post('cv_est_civil'),
		  'cant_hijos'=>$this->input->post('cv_hijos'),
		  'calle_res'=>$this->input->post('cv_calle'),
		  'nro_res'=>$this->input->post('cv_nro'),
		  'piso_res'=>$this->input->post('cv_piso'),
		  'dto_res'=>$this->input->post('cv_dto'),
		  'localidad_res'=>$this->input->post('cv_localidad'),
		  'provincia_res'=>$this->input->post('cv_provincia'),
		  'cp_res'=>$this->input->post('cv_cp'),
		  'calle_lab'=>$this->input->post('cv_calle_2'),
		  'nro_lab'=>$this->input->post('cv_nro_2'),
		  'piso_lab'=>$this->input->post('cv_piso_2'),
		  'dto_lab'=>$this->input->post('cv_dto_2'),
		  'localidad_lab'=>$this->input->post('cv_localidad_2'),
		  'provincia_lab'=>$this->input->post('cv_provincia_2'),
		  'cp_lab'=>$this->input->post('cv_cp_2'),
		  'area_per'=>$this->input->post('area1'),
		  'tel_per'=>$this->input->post('numero1'),
		  'area_lab'=>$this->input->post('area2'),
		  'tel_lab'=>$this->input->post('numero2'),
		  'int_lab'=>$this->input->post('int2'),
		  'area_movil'=>$this->input->post('area3'),
		  'tel_movil'=>$this->input->post('numero3'),
		  'email_per'=>$this->input->post('cv_email1'),
		  'email_lab'=>$this->input->post('cv_email2'),
		  'sitio_web'=>$this->input->post('cv_web'),
		  'cv_cuil'=>$this->input->post('cv_cuil'),
		  //'foto'=>$this->input->post('foto_per'),
		  //'cv'=>$this->input->post('cv_per'),
		  );
		/*	$tipo = $this->input->post('login_cat');

			$UA = $this->input->post('login_UA');

			$dni = $this->input->post('login_dni');

			$email=$this->input->post('login_email');

			$contrasenia = $this->input->post('login_contrasenia');

			$apellido= $this->input->post('cv_apellido');

			$nombre= $this->input->post('cv_nombre');

			$fecha_nac= $this->input->post('cv_fecha_nac');

			$lugar_nac= $this->input->post('cv_lug_nac');

			$domicilio= $this->input->post('cv_domicilio');

			$telefono= $this->input->post('cv_telefono');

			$celular= $this->input->post('cv_celular');

			$cuil= $this->input->post('cv_cuil');
			*/
			$data = $this->data_model->NuevoUsuario($datos);

			//print_r($data);exit();
			if($data == "Creacion de Usuario Persona:OK")
			{
				$datos['mensaje'] = 'El usuario se ha registrado correctamente, aguarde a que su Unidad Academica lo habilite';

				$datos['url'] = '../';

				$datos['ir_a'] = 'inicio';

				$this->load->view('registro_ok',array('datos'=>$datos),FALSE);
			}
			else
			{
				echo 'error';
			}
		}
		else
		{
			//if ($this->data_model->UsuarioHabilitado($this->input->post('cv_cuil'))==0)
			$datos['mensaje'] = 'El usuario ya existe, ingrese con sus datos';

			$datos['url'] = '../';

			$datos['ir_a'] = 'inicio';

			$this->load->view('registro_ok',array('datos'=>$datos),FALSE);
		}
	}
	function registrar2 ()
	{
		if($this->data_model->Existeorganizacion($this->input->post('login_cuit'))==0)
		{
		$datos=array(
		'cuit' =>$this->input->post('login_cuit'),
		'razon' =>$this->input->post('cv_nombre'),
		'email_login' =>$this->input->post('login_email'),
		'contrasenia' =>$this->input->post('login_contrasenia'),
		'categoria' =>$this->input->post('login_cat_s'),
		'calle' =>$this->input->post('cv_calle'),
		'nro' =>$this->input->post('cv_nro'),
		'piso' =>$this->input->post('cv_piso'),
		'dto' =>$this->input->post('cv_dto'),
		'localidad' =>$this->input->post('cv_localidad'),
		'provincia' =>$this->input->post('cv_provincia'),
		'cp' =>$this->input->post('cv_cp'),
		'area_fijo' =>$this->input->post('area1'),
		'tel_fijo' =>$this->input->post('numero1'),
		'area_movil' =>$this->input->post('area3'),
		'tel_movil' =>$this->input->post('numero3'),
		'email' =>$this->input->post('cv_email1'),
		'sitio_web' =>$this->input->post('cv_web'),
		'rep_apellido' =>$this->input->post('rep_apellido'),
		'rep_nombre' =>$this->input->post('rep_nombre'),
		'rep_dni' =>$this->input->post('rep_dni'),
		'rep_calle' =>$this->input->post('rep_calle'),
		'rep_nro' =>$this->input->post('rep_nro'),
		'rep_piso' =>$this->input->post('rep_piso'),
		'rep_dto' =>$this->input->post('rep_dto'),
		'rep_localidad' =>$this->input->post('rep_localidad'),
		'rep_provincia' =>$this->input->post('rep_provincia'),
		'rep_cp' =>$this->input->post('rep_cp'),
		'rep_tel_lab_area' =>$this->input->post('area2'),
		'rep_tel_lab_nro' =>$this->input->post('numero2'),
		'rep_tel_lab_int' =>$this->input->post('int2'),
		'rep_movil_area' =>$this->input->post('rep_area3'),
		'rep_movil_numero' =>$this->input->post('rep_numero3'),
		'rep_email' =>$this->input->post('rep_email1'),



		);
		/*$tipo = $this->input->post('login_cat');

			$UA = $this->input->post('login_UA');

			$dni = $this->input->post('login_dni');

			$email=$this->input->post('login_email');

			$contrasenia = $this->input->post('login_contrasenia');

			$apellido= $this->input->post('cv_apellido');

			$nombre= $this->input->post('cv_nombre');

			$fecha_nac= $this->input->post('cv_fecha_nac');

			$lugar_nac= $this->input->post('cv_lug_nac');

			$domicilio= $this->input->post('cv_domicilio');

			$telefono= $this->input->post('cv_telefono');

			$celular= $this->input->post('cv_celular');

			$cuil= $this->input->post('cv_cuil'); */

			$data = $this->data_model->NuevaOrganizacion($datos);

			if($data == "Creacion de Usuario Organizacion:OK")
			{
				$datos['mensaje'] = 'El usuario se ha registrado correctamente';

				$datos['url'] = '../';

				$datos['ir_a'] = 'inicio';

				$this->load->view('registro_ok',array('datos'=>$datos),FALSE);
			}
			else
			{
				echo 'error';
			}
		}
		else
		{
			//if ($this->data_model->UsuarioHabilitado($this->input->post('cv_cuil'))==0)
			$datos['mensaje'] = 'El usuario ya existe, ingrese con sus datos';

			$datos['url'] = '../';

			$datos['ir_a'] = 'inicio';

			$this->load->view('registro_ok',array('datos'=>$datos),FALSE);
		}
	}
	function recordar ()

	{
			/*echo $_POST['dnilogin'];exit();
			$datos['mensaje'] = 'Si ud estaba registrado con anterioridad, utilize su email y contraseña.<br />En caso de no recordarlos, envie un correo con su email a <a href="mailto:prado@rec.unicen.edu.ar">esta dirección</a> para blanquear su clave';

			$datos['url'] = '../';

			$datos['ir_a'] = 'inicio';		*/

			$this->load->view('recordar');
	}
	function subirfoto($archivo,$dni) //creo que borrar
	{
		$config['upload_path'] = '/var/www/nuevo_sistema_2/uploads/imagenes/';

		$config['allowed_types'] = 'jpg';

	/*	$config['max_size'] = '20736000000'; //$config['max_size'] = '100';

		$config['max_width'] = '20736000000';//$config['max_width'] = '1024';

		$config['max_height'] = '20736000000';//$config['max_height'] = '768'; */

		$config['overwrite'] = 'TRUE';
		//echo $dni;echo $archivo;exit();
		$config['file_name'] = 'foto'.$dni.substr($archivo,-4,strlen($archivo));
		//print_r($config);exit()
		$this->load->helper('file');

		$this->load->library('upload',$config);
		$this->upload->initialize($config);
		//print_r($config);
		if($this->upload->do_upload('foto_per'))
                {
                    $data = array('upload_data' => $this->upload->data());
                    //echo "bien";exit();
                }
                else
                {
                    $error = array('error' => $this->upload->display_errors());
                    //print_r($error);exit();
                }

	}
	function subircv($archivo,$dni) //creo que borrar
	{

		$config['upload_path'] = '/var/www/nuevo_sistema_2/uploads/cvs/';

		$config['allowed_types'] = 'pdf';

	/*	$config['max_size'] = '20736000000'; //$config['max_size'] = '100';

		$config['max_width'] = '20736000000';//$config['max_width'] = '1024';

		$config['max_height'] = '20736000000';//$config['max_height'] = '768'; */

		$config['overwrite'] = 'TRUE';

		$config['file_name'] = 'cv'.$dni.substr($archivo,-4,strlen($archivo));

		$this->load->helper('file');

		$this->load->library('upload',$config);
		$this->upload->initialize($config);

		if($this->upload->do_upload('cv_per'))
                {
                    $data = array('upload_data' => $this->upload->data());
                    //echo "bien";exit();
                }
                else
                {
                    $error = array('error' => $this->upload->display_errors());
                    //print_r($error);exit();
                }
	}
	function logout(){
		if ($this->session->userdata('login_persona')=="user"){
		$this->data_model->LogOut($this->session->userdata('login_cuil'));
		}elseif ($this->session->userdata('login_persona')=="organizacion") {
			$this->data_model->LogOut($this->session->userdata('login_cuit'));
		}else{
			$this->data_model->LogOutAdmin($this->session->userdata('login_usuario'));
			$this->session->sess_destroy();
		 redirect('/login_admin', 'refresh');
		}
		 $this->session->sess_destroy();
		 redirect('/login', 'refresh');

	}
 }
 ?>
