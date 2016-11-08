$(document).ready(function(){
$("#pvcia").change(function () {
		
		$("#pvcia option:selected").each(function () {
		var id_category = $(this).val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/localidad",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/localidad",
			type: 'POST',
			data: {id_category:id_category},
			success:function(data){
				$('#localidad').show();
				$('#localidad').html(data);
					}
			 })	 ;    
		}); } )
		
$("#btn_busqueda").on('click', function () {// funcion para  buscar por dni integrantes 
	var dni = $('#busqueda').val();
		$.ajax({
		url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_dni",
		//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_dni",
			type: 'POST',
			data: {dni:dni},
			success:function(data){
				$('#resultados').show();
				$('#btn_agregar_integrante').show();
				$('#resultados').html(data);
				}
				}); 
		} );
		

$("#btn_busqueda_integrante_actividad").on('click', function () { //  buscar por dni integrantes de la ACTIVIDAD
	var dni = $('#busqueda').val();
		$.ajax({
		url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_dni_actividad",
		//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_dni",
			type: 'POST',
			data: {dni:dni,rol:"rol"},
			success:function(data)
			{
				if (data!='')
				{
					$('#resultados').show();
					$('#btn_agregar_integrante').show();
					$('#resultados').append(data);
					$('#mje').html('');
				}
					else 
				{
					$('#mje').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				});
		} );

$("#btn_busqueda_integrante_con_rol").on('click', function () {// funcion para  buscar por dni integrantes PROYECTO
	var dni = $('#busqueda').val();
		$.ajax({
		url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_dni",
		//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_dni",
			type: 'POST',
			data: {dni:dni,rol:"rol"},
			success:function(data)
			{
				if (data!='')
				{
					$('#resultados').show();
					$('#btn_agregar_integrante').show();
					$('#resultados').append(data);
					$('#mje').html('');
				}
					else 
				{
					$('#mje').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				});
		} );

$("#btn_busqueda_aval").on('click', function () {// funcion para  buscar por dni integrantes 
	var cuit = $('#busqueda_aval').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_cuit_proyecto",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit},
			success:function(data)
			{
				if (data!='')
				{
					$('#resultados_aval').show();
					$('#btn_agregar_aval').show();
					$('#resultados_aval').append(data);
					$('#mje_2').html('');
					//s$('#datos_ajax').append("<td class='btn_quitar'></td>");
				}
				else 
				{
					$('#mje_2').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				}); 
		} );
	
$("#btn_busqueda_organizacion_actividad").on('click', function () {// funcion para  buscar por dni integrantes 
	var cuit = $('#busqueda_aval').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit},
			success:function(data)
			{
				if (data!='')
				{
					$('#resultados_aval').show();
					$('#btn_agregar_aval').show();
					$('#resultados_aval').append(data);
					$('#mje_2').html('');
					//s$('#datos_ajax').append("<td class='btn_quitar'></td>");
				}
				else 
				{
					$('#mje_2').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				}); 
		} );

$("#btn_buscar_codir").on('click',function(){
	var dni = $('#buscar_co_director').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_dni",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_dni",
			type: 'POST',
			data: {dni:dni},
			success:function(data){
			if (data!='')
				{	
				$('#resultados_codirector').show();
				//$('#btn_agregar_codir').show();
				$('#resultados_codirector').html(data);

				$('#resultados_codirector').append("<table><tr><td><input type='button'  id = 'btn_agregar_codir' class='btn btn-primary'  value='Confirmar' ></td><td style='padding:13px;'><input type=button id=descartar value=Descartar class='btn btn-warning'></td></tr></table>");
				//$('#resultados_codirector').append("<input type=button id=descartar value=Descartar class='btn btn-primary'>");
				
				$("#btn_agregar_codir").bind("click",agregar_codirector);
				$('#descartar').bind('click',function(){
					//$this().remove();
					$('#resultados_codirector').html('');
					$('#descartar').remove();
					$('#btn_agregar_codir').remove();

				});
				}
				else 
				{
					$('#mje').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				}); 
		} );
$("#btn_buscar_responsable").on('click',function(){
	var dni = $('#buscar_responsable').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_dni",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_dni",
			type: 'POST',
			data: {dni:dni},
			success:function(data){
				if (data!='')
				{
				$('#resultados_responsable').show();
			//	$('#btn_agregar_responsable').show();
				$('#resultados_responsable').html(data);
				$('#resultados_responsable').append("<table><tr><td><input type='button'  id = 'btn_agregar_responsable' class='btn btn-primary'  value='Confirmar' ></td><td style='padding:13px;'><input type=button id=descartar value=Descartar class='btn btn-warning'></td></tr></table>");
				//$('#resultados_responsable').append("<input type='button'  id = 'btn_agregar_responsable' class='btn btn-primary'  value='Confirmar' >");
				//$('#resultados_responsable').append("<input type=button id=descartar value=Descartar class='btn btn-primary'>");
				
				$("#btn_agregar_responsable").bind("click",agregarResponsable);
				$('#descartar').bind('click',function(){
					//$this().remove();
					$('#resultados_responsable').html('');
					$('#descartar').remove();
					$('#btn_agregar_responsable').remove();

				});

				}
				else 
				{
					$('#mje').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				}); 
		} );
$("#btn_buscar_coordinador").on('click',function(){
	var dni = $('#buscar_coordinador').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_dni",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_dni",
			type: 'POST',
			data: {dni:dni},
			success:function(data){
				if (data!='')
				{
					$('#resultados_coordinador').show();
				//	$('#btn_agregar_coordinador').show();
					$('#resultados_coordinador').html(data);

				$('#resultados_coordinador').append("<table><tr><td><input type='button'  id = 'btn_agregar_coordinador' class='btn btn-primary'  value='Confirmar' ></td><td style='padding:13px;'><input type=button id=descartar value=Descartar class='btn btn-warning'></td></tr></table>");
			//	$('#resultados_coordinador').append("<input type='button'  id = 'btn_agregar_coordinador' class='btn btn-primary'  value='Confirmar' >");
			//	$('#resultados_coordinador').append("<input type=button id=descartar_2 value=Descartar class='btn btn-primary'>");
				
				$("#btn_agregar_coordinador").bind("click",agregarCoordinador);
				$('#descartar_2').bind('click',function(){
					//$this().remove();
					$('#resultados_coordinador').html('');
					$('#descartar_2').remove();
					$('#btn_agregar_coordinador').remove();

				});
			
				}
				else 
				{
					$('#mje').html('<h3> Sin resultados para la busqueda</h3><br>');
				}
			}
				}); 
		} );
$("#localidad").change(function () {
		
		$("#localidad option:selected").each(function () {
		var id_category = $(this).val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/barrio",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/barrio",
			type: 'POST',
			data: {id_category:id_category},
			success:function(data){
				$('#barrio').show();
				$('#barrio').html(data);
					}
			 })	 ;    
		}); } );
$("#btn_busqueda_establecimiento").on('click', function () {
		var cuit = $('#busqueda_establecimiento').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit},
			success:function(data){
				$('#resultados_establecimiento').show();
				$('#btn_agregar_establecimiento').show();
				$('#resultados_establecimiento').html(data);
				}
				}); 
		} );
/*
$("#btn_buscar_centro").on('click', function () {// funcion para  buscar por centros por nombre
		var cuit = $('#buscar_centro').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/buscar_centro",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit},
			success:function(data){
				$('#resultados_centro').show();
				$('#btn_agregar_centro').show();
				$('#resultados_centro').html(data);
				}
				}); 
		} );

$("#btn_buscar_programa").on('click', function () {// funcion para  buscar programas
		var cuit = $('#buscar_programa').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/buscar_programa",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit},
			success:function(data){
				$('#resultados_programa').show();
				$('#btn_agregar_programa').show();
				$('#resultados_programa').html(data);
				}
				}); 
		} );

$("#btn_buscar_grupo").on('click', function () {// funcion para  buscar grupos por nombre
		var cuit = $('#buscar_grupo').val();
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/buscar_grupo",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit},
			success:function(data){
				$('#resultados_grupo').show();
				$('#btn_agregar_grupo').show();
				$('#resultados_grupo').html(data);
				}
				}); 
		} );
*/
$("#btn_buscar_proyecto").on('click', function () {// funcion para  buscar grupos por nombre
		var cuit = $('#buscar_proyecto').val();
		var dir = $('#id_quien_lo_creo').val(); // este es el campo oculto en el form de nueva actividad (indepen.)
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/data_ajax/buscar_proyecto",
			//url: "http://localhost/nuevo_sistema_2/index.php/data_ajax/data_cuit",
			type: 'POST',
			data: {cuit:cuit,dir:dir},
			success:function(data){
				$('#resultados_proyecto').show();
				$('#btn_agregar_proyecto').show();
				$('#resultados_proyecto').html(data);
				}
				}); 
		} );


});
