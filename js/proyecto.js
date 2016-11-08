$(document).ready(function(){

$('#actividades').hide();
$('#objetivos_eo').hide();
$('#resultados_codirector').hide();
$('#btn_agregar_codir').hide(); 
$('#btn_agregar_responsable').hide(); 
$('#btn_agregar_coordinador').hide(); 
		$('#btn_agregar_integrante').hide();
		$('#btn_agregar_aval').hide();
		$('#crono_act').hide();
		$('#Cuantitativos').hide();
		$('#ICualitativosP').hide();
		$('#objetivos_proyecto').hide();
				
		$("#btn_agregar_integrante").bind("click",agrega_integrante);// 
		$("#btn_agregar_aval").bind("click",agregarAval);	 
		$("#btn_agregar_codir").bind("click",addField3);
		$("#btn_agregar_responsable").bind("click",agregarResponsable);
		$("#btn_agregar_coordinador").bind("click",agregarCoordinador);
	//	$("#btn_agregar_dia_crono_actividad").bind("click",agregarDiaCronoActividad);
		//$("#btn_agregar_actividad").bind("click",agregarActividad);
		$("#btn_agregar_objetivo").bind("click",agregarObjetivo);
		$("#btn_agregar_objetivo_pro").bind("click",agregarObjetivoProyecto);
		$("#btn_agregar_ICP").bind("click",agregarICP);
		$("#btn_agregar_ICuantitativo").bind("click",agregarICuantitativo);
		
	
	$(".btn btn-primary").each(function (el){
			$(this).bind("click",addField);
									 }); 
	}); 

function addField(){

var clickID = parseInt($(this).closest('div').attr('id').replace('div_',''));
// Genero el nuevo numero id
var newID = (clickID+1);
$newClone = $('#div_'+clickID).clone(true);
$newClone.attr("id",'div_'+newID);
$newClone.children("text").eq(0).val('');
for (var j=1;j<13;j++) {
	$newClone.children(":checkbox").eq(+j-1).removeAttr('checked');
	$newClone.children(":text").eq(+j).val('');
	$newClone.children(":checkbox").eq(+j-1).attr("id",+j).removeAttr('checked');
	$newClone.children(":text").eq(+j).attr("id",+j).val('');
}
$newClone.children("input").eq(25).attr("id",'btn'+newID);
//Inserto el div clonado y modificado despues del div original
$newClone.insertAfter($('#div_'+clickID));
//Cambio el signo "+" por el signo "-" y le quito el evento addfield
$("#btn"+clickID).val('-').unbind("click",addField);
 $("#btn"+clickID).bind("click",delRow);					
 
}
 
function delRow() {
// Funcion que destruye el elemento actual una vez echo el click
$(this).parent('div').remove();
 
}

function delRow2() {
// Funcion que destruye el elemento actual una vez echo el click
$(this).parent('div').remove();
$('#div_busqueda_codir').show();
}

 var cantidad = 0 ;
 
function agrega_integrante(){					 // integrantes
	
//var cantidad = parseInt($(this).closest('div').attr('id').replace('div_',''));
 cantidad = (cantidad+1);
$('#btn_agregar_integrante').hide();
// Creo un clon del elemento div que contiene los campos de texto
$newClone = $('#resultados').clone(true);
 
//Le asigno el nuevo numero id
$newClone.attr("id",'div_integrante_'+cantidad);
$newClone.children("input").eq(0).attr("name",'id_integrante[]');

$newClone.insertAfter($('#integrantes'));
/*
 $('#div_integrante_'+cantidad).append("<input name=horas[] placeholder=horas >");
 $('#div_integrante_'+cantidad).append("<input name=honorarios_integrantes[] placeholder=honorarios ><br>");
 $('#div_integrante_'+cantidad).append("<div id='btn_quitar_integ_"+cantidad+"' value='eliminar' class='btn btn-primary'> Quitar </div><br><br>");
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_quitar_integ_"+cantidad).bind("click",delRow);			
*/
//finalmente vacio los div de busqueda y resultado 
 $('#busqueda').val('');
  $('#resultados').html('');
		
}

function addField3(){ 							//codirector

$('#btn_agregar_codir').hide();
$('#div_busqueda_codir').hide();

$newClone = $('#resultados_codirector').clone(true);
$newClone.attr("id",'div_codir');

//$newClone.children("input").eq(0).attr("name",'nombre_codirector');
//$newClone.children("input").eq(1).attr("name",'apellido_codirector');
$newClone.children("input").eq(0).attr("name",'codirector'); // ultimo por estar hidden
$newClone.children("input").eq(0).attr("id",'codirector'); // ultimo por estar hidden
//$newClone.children("input").eq(2).attr("name",'dependencia_codirector');

$newClone.insertAfter($('#resultados_codirector'));
//$('#div_codir').append("<input name=dedicacion_codirector placeholder=dedicacion >");
$('#div_codir').append("<input name=horas_codirector placeholder=horas >");
$('#div_codir').append("<input name=honorarios_codirector placeholder=honorarios >");
$('#div_codir').append("<br><div id='btn_eliminar_codir' value='eliminar' class='btn btn-primary'> Cambiar </div><br>");
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_eliminar_codir").bind("click",delRow2);			
/**/	
//finalmente vacio los div de busqueda y resultado 
 $('#buscar_co_director').val('');
  $('#resultados_codirector').html('');
	
}

function agregarResponsable(){ 							//responsable actividad

$('#btn_agregar_responsable').hide();
$('#div_busqueda_responsable').hide();

$newClone = $('#resultados_responsable').clone(true);
$newClone.attr("id",'div_responsable');
$newClone.children("input").eq(0).attr("name",'responsable'); // ultimo por estar hidden
$newClone.children("input").eq(0).attr("id",'responsable'); // ultimo por estar hidden
$newClone.insertAfter($('#resultados_responsable'));
$('#div_responsable').append("<input name=horas_responsable placeholder=horas >");
$('#div_responsable').append("<input name=honorarios_responsable placeholder=honorarios >");
$('#div_responsable').append("<br><div id='btn_eliminar_responsable' value='eliminar' class='btn btn-primary'> Cambiar </div><br>");
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_eliminar_responsable").bind("click",delRow2);			
/**/	
//finalmente vacio los div de busqueda y resultado 
 $('#buscar_responsable').val('');
  $('#resultados_responsable').html('');
	
}

function agregarCoordinador(){ 							//responsable actividad

$('#btn_agregar_coordinador').hide();
$('#div_busqueda_coordinador').hide();

$newClone = $('#resultados_coordinador').clone(true);
$newClone.attr("id",'div_coordinador');
$newClone.children("input").eq(0).attr("name",'coordinador'); // ultimo por estar hidden
$newClone.children("input").eq(0).attr("id",'coordinador'); // ultimo por estar hidden
$newClone.insertAfter($('#resultados_coordinador'));
$('#div_coordinador').append("<input name=horas_coordinador placeholder=horas >");
$('#div_coordinador').append("<input name=honorarios_coordinador placeholder=honorarios >");
$('#div_coordinador').append("<br><div id='btn_eliminar_coordinador' value='eliminar' class='btn btn-primary'> Cambiar </div><br>");
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_eliminar_coordinador").bind("click",delRow2);			
/**/	
//finalmente vacio los div de busqueda y resultado 
 $('#buscar_coordinador').val('');
  $('#resultados_coordinador').html('');
	
}

var can = 0 ;

function agregarAval(){     		// avales de organizaciones
$newClone = $('#resultados_aval').clone(true);
 can = (can+1);
$('#btn_agregar_aval').hide();
$newClone = $('#resultados_aval').clone(true);
$('#resultados_aval').html('');
$newClone.children("input").eq(0).attr("name",'id_integrante[]');
$('#nuevos_avales').append($newClone);
//$("#btn_quitar_integ_"+cantidad).bind("click",delRow);			
$('#busqueda_avales').val('');
$('#resultados_aval').html('');
		
}


var k3 = 0 ;
function agregarICuantitativo(){					// indicador CuaNtitativo proyecto
k3= (k3+1);
//$('#objetivos_eo').html('hace algo !!');
$newClone = $('#Cuantitativos').clone(true);

$newClone.attr("id",'div__'+k3);
//$newClone.children("select").eq(0).attr("name",'tipo_eo_'+k2);
//$newClone.children("textarea").eq(0).attr("name",'cuantitativo'+k3);
$newClone.children("textarea").eq(0).attr("name",'cuantitativo[]');
$newClone.insertAfter($('#btn_agregar_ICuantitativo'));

$('#div__'+k3).append("<div id='btn__"+k3+"' value='eliminar objetivo' class='btn_quitar'>   </div>");
 $('#div__'+k3).show();
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn__"+k3).bind("click",delRow);		
$('#div_'+k3).show();
}


var k2 = 0 ;
function agregarICP(){					// indicador CuaLitativos proyecto
k2= (k2+1);
//$('#objetivos_eo').html('hace algo !!');
$newClone = $('#ICualitativosP').clone(true);

$newClone.attr("id",'div_'+k2);
//$newClone.children("select").eq(0).attr("name",'tipo_eo_'+k2);
//$newClone.children("textarea").eq(0).attr("name",'cualitativo'+k2);
$newClone.children("textarea").eq(0).attr("name",'cualitativo[]');
$newClone.insertAfter($('#btn_agregar_ICP'));

$('#div_'+k2).append("<div id='btn"+k2+"' value='Sacar Indicador Cualitativo' class='btn_quitar'>   </div>");
 $('#div_'+k2).show();
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn"+k2).bind("click",delRow);		
$('#div'+k2).show();
}

var k = 0 ;
function agregarObjetivo(){					// objetivos de la EO
k= (k+1);
//$('#objetivos_eo').html('hace algo !!');
$newClone = $('#objetivos_eo').clone(true);

$newClone.attr("id",'div'+k);
$newClone.children("select").eq(0).attr("name",'tipo_eo_'+k);
$newClone.children("textarea").eq(0).attr("name",'objetivo_'+k);
$newClone.insertAfter($('#btn_agregar_objetivo'));
//$('#div'+k).show();
$('#div'+k).append("<div id='btn_"+k+"' value='eliminar objetivo' class='btn_quitar'>   </div>");
 
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_"+k).bind("click",delRow);		
$('#div'+k).show();
}

var m = 0 ;
function agregarObjetivoProyecto(){					// objetivos proyectos
m= (m+1);
$newClone = $('#objetivos_proyecto').clone(true);

$newClone.attr("id",'div'+m);
$newClone.children("input").eq(0).attr("name",'objetivo[]');
$newClone.insertAfter($('#btn_agregar_objetivo_pro'));

$('#div'+m).append("<div id='btn_"+m+"' value='eliminar objetivo' class='btn_quitar'>   </div>");
 $('#div'+m).show();
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_"+m).bind("click",delRow);		
$('#div'+m).show();
	

}


function validarForm(){
 
		$('#form_proyecto').submit();	

	
}

function validarFormActividad(){
		$('#form_actividad').submit();	

	
}
	
	
