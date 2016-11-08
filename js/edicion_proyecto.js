$(document).ready(function(){
$('#actividades').hide();
$('#objetivos_eo').hide();

$('#btn_agregar_establecimiento').hide();
$('#btn_agregar_codir').hide(); 
//$('#btn_agregar_responsable').hide(); 
$('#btn_mostrar_busqueda_codir').hide(); 

//$('#btn_agregar_coordinador').hide(); 
//$('#btn_agregar_integrante').hide();//
//$('#btn_agregar_aval').hide();
$("#btn_agregar_integrante").bind("click",agrega_integrante);// 
$("#btn_agregar_aval").bind("click",agregarAval);

		$('#btn_agregar2').hide();

$('#resultados_codirector').hide();
$('#resultados_codirector').hide();

/*	$("#btn_agregar_coordinador").bind("click",agregarCoordinador);
				$('#descartar_2').bind('click',function(){
					//$this().remove();
					$('#resultados_coordinador').html('');
					$('#descartar_2').hide();
					$('#btn_agregar_coordinador').hide();

				});

*/

		$('#crono_act').hide();
		$('#Cuantitativos').hide();
		$('#ICualitativosP').hide();
		$('#objetivos_proyecto').hide();

		$("#btn_mostrar_busqueda_codir").bind("click",muestra);// 		
		//$("#btn_mostrar_busqueda_coordinador").bind("click",muestra_busqueda_coordinador);// 		
		//$("#btn_mostrar_busqueda_responsable").bind("click",muestra_busqueda_responsable);// 		
		
		$("#btn_agregar_codir").bind("click",agregar_codirector);
		

		//$("#btn_agregar_dia_crono_actividad").bind("click",agregarDiaCronoActividad);
		$("#btn_agregar_actividad").bind("click",agregarActividad);
		//$("#btn_agregar_objetivo").bind("click",agregarObjetivo);
		$("#btn_agregar_objetivo_pro").bind("click",agregarObjetivoProyecto);
		$("#btn_agregar_ICP").bind("click",agregarICP);
		
		
	
	$(".buttonxx").each(function (el){
			$(this).bind("click",addField);
									 }); 
	}); 

$("#btn_agregar_responsable").bind("click",agregarResponsable);
$("#btn_agregar_coordinador").bind("click",agregarCoordinador);

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
 $("#btn"+clickID).bind("click",borraFila);					
 
}
 
function borraFila() {
// Funcion que destruye el elemento actual una vez echo el click
//$(this).parent('div').remove();
$(this).parent('tr').remove();
 
}

function cancelar_borrar_participante(id,id_div){
$('#mje'+id_div).remove();
$('#borrar'+id).remove();
$('#btn_cancelar'+id).remove();
$('#btn_delete_participante'+id_div).show();
}

function muestra(){
	$('#div_busqueda_codir').show();
	$('#btn_mostrar_busqueda_codir').hide();
	var id_codir=$('#id_codirector_actual').val();
	$('#borrar_Codirector_pro').append('<input hidden name=borrar_Codirector_pro value='+id_codir+'>');
	$('#codirector').html('');
	$('#fila_codirector').remove();

}
function muestra_busqueda_responsable(){
	$('#div_busqueda_responsable').show();
	//$('#btn_mostrar_busqueda_responsable').hide();
	var id_responsable=$('#id_responsable_actual').val();
	$('#borrar_responsable').append('<input hidden name=borrar_responsable value='+id_responsable+'>');
	$('#responsable').html('');
	$('#resultados #fila_responsable').remove();
}

function muestra_busqueda_coordinador(){
	$('#div_busqueda_coordinador').show();
	//$('#btn_mostrar_busqueda_coordinador').hide();
	var id_coordinador=$('#id_coordinador_actual').val();
	$('#borrar_coordinador').append('<input hidden name=borrar_coordinador value='+id_coordinador+'>');
	$('#coordinador').html('');
	$('#resultados #fila_coordinador').remove();
}


function delRow2() {
// Funcion que destruye el elemento actual una vez echo el click
$(this).parent('div').remove();
$('#div_busqueda_codir').show();
}
function delParticipante(id_par,id_div,rol) {
$('#btn_delete_participante'+id_div).hide();
$('#lista_a_borrar').append("<input id='borrar"+id_par+"' hidden name=borrar_participante[] value='"+id_par+"'>");
$('#lista_a_borrar').append("<input id='borrar_rol"+id_par+"' hidden name=rol_participante_a_borrar[] value='"+rol+"'>");
//$("<h2>  Se desvinculara del proyecto !!! </h2>").insertAfter('#participante'+id_div);
$('#participante'+id_div).append("<h4 id='mje"+id_div+"'>  Se desvinculara del proyecto</h4>");
$('#participante'+id_div).append("<div id='btn_cancelar"+id_par+"' class='btn_deshacer' >  </div> ");
$('#btn_cancelar'+id_par).click(function(){cancelar_borrar_participante(id_par,id_div);});	
//$('#div_busqueda_codir').show();
}
function delAvalProyecto(id_par,id_div) {
//$('#btn_delete_participante'+id_div).hide();
$('#lista_a_borrar_aval').append("<input id='borrar_aval"+id_par+"' hidden name=borrar_aval[] value='"+id_par+"'>");

}
function delProyectoExt(id_par,id_div) {
//$('#btn_delete_participante'+id_div).hide();
$('#lista_a_borrar_proyecto_extension').append("<input id='borrar_proyecto_extension"+id_par+"' hidden name=borrar_proyecto_extension[] value='"+id_par+"'>");

}


 var cantidad = 0 ;
 
function addField2(){					 // integrantes
	
//var cantidad = parseInt($(this).closest('div').attr('id').replace('div_',''));
 cantidad = (cantidad+1);
$('#btn_agregar2').hide();
// Creo un clon del elemento div que contiene los campos de texto
$newClone = $('#resultados').clone(true);
 
//Le asigno el nuevo numero id
$newClone.attr("id",'div__'+cantidad);
$newClone.children("input").eq(0).attr("name",'id_integrante_'+cantidad);

$newClone.insertAfter($('#integrantes'));

$('#div__'+cantidad).append("<div id='btn_"+cantidad+"' value='eliminar' class='btn btn-primary'> Quitar </div><br>");
 
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_"+cantidad).bind("click",delRow);			

//finalmente vacio los div de busqueda y resultado 
 $('#busqueda').val('');
  $('#resultados').html('');
		
}

function agregar_codirector(){ 							//codirector nuevo en reemplazo del anterior

$('#btn_agregar_codir').hide();
//$('#div_busqueda_codir').hide();
//$('#btn_mostrar_busqueda_codir').attr("class","btn btn-warning disabled");
//$('#btn_mostrar_busqueda_codir').show();
$newClone = $('#resultados_codirector').clone(true);
$newClone.attr("id",'div_codir');
$newClone.children("input").eq(0).attr("id",'nuevo_codirector'); // ultimo por estar hidden
$newClone.children("input").eq(0).attr("name",'nuevo_codirector'); // ultimo por estar hidden
$('#codirector_actual').hide();
$('#codirector').html('');
$newClone.appendTo('#codirector');
$('#buscar-co-director').val('');
$('#resultados_codirector').html('');
$('#descartar').remove();

$('#fila_codirector').remove(); // si existe , la elmino antes de poner una nueva.
var nom =  $("#tabla_resultados_1 tr td")[1].innerHTML;
var cate =  $("#tabla_resultados_1 tr td")[0].innerHTML;
var depe =  $("#tabla_resultados_1 tr td")[0].innerHTML;
var email=  $("#tabla_resultados_2 tr td")[2].innerHTML;
$("<tr id='fila_codirector'><td>"+nom+"</td><td>"+cate+"</td><td>"+depe+"</td><td></td><td><input class='form-control' name=horas_codir></td><td><input class='form-control' name=honorarios_codir></td><td>Codirector</td><td>"+email+"</td><td></td></tr>").appendTo('#resultados');

}

var can = 0 ;

function agregarAval(){     		// avales de organizaciones
$newClone = $('#resultados_aval').clone(true);
 can = (can+1);
$('#btn_agregar_aval').hide();
$newClone = $('#resultados_aval').clone(true);
$('#resultados_aval').html('');
$newClone.children("input").eq(0).attr("name",'id_aval[]');
$('#nuevos_avales').append($newClone);
//$("#btn_quitar_integ_"+cantidad).bind("click",delRow);			
$('#busqueda_avales').val('');
$('#resultados_aval').html('');
		
}

var cantidad = 0 ;
 
function agrega_integrante(){					 // integrantes
	
 cantidad = (cantidad+1);
$('#btn_agregar_integrante').hide();
$newClone = $('#resultados').clone(true);
$('#resultados').html('');
$newClone.children("input").eq(0).attr("name",'id_integrante[]');
$('#nuevos_integrantes').append($newClone);
$("#btn_quitar_integ_"+cantidad).bind("click",delRow);			
$('#busqueda').val('');
$('#resultados').html('');
	
}

function agregarResponsable(){ 							//responsable actividad

$('#btn_agregar_responsable').hide();
//$('#div_busqueda_responsable').hide();
$newClone = $('#resultados_responsable').clone(true);
$newClone.attr("id",'div_responsable');
$newClone.children("input").eq(0).attr("name",'responsable');
$('#responsable').html('');
//$newClone.appendTo('#responsable');//no anda
$('#responsable').html($newClone);
$('#buscar_responsable').val('');
$('#resultados_responsable').html('');
$('#btn_mostrar_busqueda_responsable').show();
$('#descartar').hide();
$('#fila_responsable').remove(); // si existe , la elmino antes de poner una nueva.
var nom =  $("#tabla_resultados_1 tr td")[1].innerHTML;
var cate =  $("#tabla_resultados_1 tr td")[0].innerHTML;
var depe =  $("#tabla_resultados_1 tr td")[0].innerHTML;
var email=  $("#tabla_resultados_2 tr td")[2].innerHTML;
$("<tr id='fila_responsable'><td>"+nom+"</td><td>"+cate+"</td><td>"+depe+"</td><td>Responsable</td><td>"+email+"</td><td></td></tr>").appendTo('#resultados');

}

function agregarCoordinador(){ 							// actividad

$('#btn_agregar_coordinador').hide();
//$('#div_busqueda_coordinador').hide();

$newClone = $('#resultados_coordinador').clone(true);
$newClone.attr("id",'div_coordinador');   // SIEMPRE CAMBIAR EL ID DE LA COPIA !!
$newClone.children("input").eq(0).attr("name",'coordinador');
$('#coordinador').html('');
//$newClone.appendTo('#responsable');//no anda
$('#coordinador').html($newClone);
//$('#coordinador').append('<input type=button id=descartar value=Descargar class=btn-primary>');
//$('#descartar').bind('click',function(){});

$('#buscar_coordinador').val('');
$('#resultados_coordinador').html('');
$('#btn_mostrar_busqueda_coordinador').show();

$('#descartar_2').remove();
$('#fila_coordinador').remove(); // si existe , la elmino antes de poner una nueva.
var nom2 =  $("#div_coordinador #tabla_resultados_1 tr td")[1].innerHTML;
var cate2 =  $("#div_coordinador #tabla_resultados_1 tr td")[0].innerHTML;
var depe2=  $("#div_coordinador #tabla_resultados_1 tr td")[0].innerHTML;
var email2=  $("#div_coordinador #tabla_resultados_2 tr td")[2].innerHTML;
$("<tr id='fila_coordinador'><td>"+nom2+"</td><td>"+cate2+"</td><td>"+depe2+"</td><td>Coordinador</td><td>"+email2+"</td><td></td></tr>").appendTo('#resultados');


}



var cant = 0 ;

function agregarActividad(){     		// actividades
 cant = (cant+1);
$newClone = $('#actividades').clone(true);
//Le asigno el nuevo numero id
$newClone.attr("id",'div_n'+cant);

$newClone.children("input").eq(0).attr("name",'nombre_actividad'+cant);
$newClone.children("input").eq(1).attr("name",'datepicker'+cant);
$newClone.children("input").eq(1).attr("id",'datepicker'+cant);
$newClone.children("input").eq(2).attr("name",'duracion_tarea'+cant);
$newClone.children("input").eq(3).attr("name",'presupuesto_tarea'+cant);
$newClone.children("textarea").eq(0).attr("name",'des_actividad'+cant);

$newClone.insertAfter($('#btn_agregar_actividad'));
$('#div'+cant).append("<br><div id='btn_"+cant+"' value='eliminar actividad' class='btn btn-primary'> Eliminar </div>");
 
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_"+cant).bind("click",delRow);			

$('#div_n'+cant).show();
 $(function() {
    $( "#datepicker"+cant).datepicker();
  });

}

var k2 = 0 ;
function agregarICP(){					// indicador CuaLitativos proyecto
k2= (k2+1);
//$('#objetivos_eo').html('hace algo !!');
$newClone = $('#ICualitativosP').clone(true);

$newClone.attr("id",'div_'+k2);
//$newClone.children("select").eq(0).attr("name",'tipo_eo_'+k2);
$newClone.children("textarea").eq(0).attr("name",'cualitativo[]');
$newClone.insertAfter($('#btn_agregar_ICP'));

$('#div_'+k2).append("<div id='btn"+k2+"' value='Sacar Indicador Cualitativo' class='btn_quitar'>   </div>");
 $('#div_'+k2).show();
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn"+k2).bind("click",delRow);		
$('#div'+k2).show();
}


var m = 0 ;
function agregarObjetivoProyecto(){					// objetivos proyectos
m= (m+1);
$newClone = $('#objetivos_proyecto').clone(true);

$newClone.attr("id",'div'+m);
//$newClone.children("select").eq(0).attr("name",'tipo_eo_'+m);
$newClone.children("textarea").eq(0).attr("name",'objetivo[]');
$newClone.insertAfter($('#btn_agregar_objetivo_pro'));

$('#div'+m).append("<div id='btn_"+m+"' value='eliminar objetivo' class='btn_quitar'>   </div>");
 $('#div'+m).show();
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_"+m).bind("click",delRow);		
$('#div'+m).show();
	

}


function validarForm(){
	var atLeastOneIsChecked = $('input:checkbox').is(':checked');
		$('#form_proyecto').submit();	

	
}


	
	
