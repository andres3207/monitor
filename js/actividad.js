$(document).ready(function(){

$('#actividades').hide();
$('#objetivos_eo').hide();
$('#resultados_codirector').hide();
$('#btn_agregar_codir').hide(); 
		$('#btn_agregar_integrante').hide();
		$('#btn_agregar_aval').hide();
		$('#crono_act').hide();
		$('#Cuantitativos').hide();
		$('#ICualitativosP').hide();
		$('#objetivos_proyecto').hide();
				
		$("#btn_agregar_integrante").bind("click",agrega_integrante);// 
		$("#btn_agregar_aval").bind("click",agregarAval);	 
		$("#btn_agregar_codir").bind("click",addField3);
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
$newClone.children("input").eq(0).attr("id",'nombre_'+cantidad);
$newClone.children("input").eq(1).attr("id",'apellido_'+cantidad);
$newClone.children("input").eq(0).attr("name",'nombre_'+cantidad);
$newClone.children("input").eq(1).attr("name",'apellido_'+cantidad);
$newClone.children("input").eq(2).attr("name",'dependencia_'+cantidad);
$newClone.children("input").eq(3).attr("name",'id_integrante[]');

$newClone.insertAfter($('#integrantes'));


 //$('#div_integrante_'+cantidad).append("<input name=dedicacion[] placeholder=dedicacion >");
 $('#div_integrante_'+cantidad).append("<input name=horas[] placeholder=horas >");
 $('#div_integrante_'+cantidad).append("<input name=honorarios_integrantes[] placeholder=honorarios ><br>");
 $('#div_integrante_'+cantidad).append("<div id='btn_quitar_integ_"+cantidad+"' value='eliminar' class='btn btn-primary'> Quitar </div><br><br>");
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_quitar_integ_"+cantidad).bind("click",delRow);			

//finalmente vacio los div de busqueda y resultado 
 $('#busqueda').val('');
  $('#resultados').html('');
		
}

function addField3(){ 							//codirector

$('#btn_agregar_codir').hide();
$('#div_busqueda_codir').hide();

$newClone = $('#resultados_codirector').clone(true);
$newClone.attr("id",'div_codir');

$newClone.children("input").eq(0).attr("name",'nombre_codirector');
$newClone.children("input").eq(1).attr("name",'apellido_codirector');
$newClone.children("input").eq(3).attr("name",'codirector'); // ultimo por estar hidden
$newClone.children("input").eq(3).attr("id",'codirector'); // ultimo por estar hidden
$newClone.children("input").eq(2).attr("name",'dependencia_codirector');

$newClone.insertAfter($('#resultados_codirector'));
//$('#div_codir').append("<input name=dedicacion_codirector placeholder=dedicacion >");
$('#div_codir').append("<input name=horas_codirector placeholder=horas >");
$('#div_codir').append("<input name=honorarios_codirector placeholder=honorarios >");
$('#div_codir').append("<br><div id='btn_eliminar_codir' value='eliminar' class='btn btn-primary'> Cambiar </div><br>");
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_eliminar_codir").bind("click",delRow2);			
/**/	
//finalmente vacio los div de busqueda y resultado 
 $('#buscar-co-director').val('');
  $('#resultados_codirector').html('');
	
}

var can = 0 ;

function agregarAval(){     		// avales de organizaciones
 can = (can+1);
$('#btn_agregar_aval').hide();
// Creo un clon del elemento div que contiene los campos de texto
$newClone = $('#resultados_aval').clone(true);
 
//Le asigno el nuevo numero id
$newClone.attr("id",'div'+can);
$newClone.children("input").eq(0).attr("name",'razon'+can);
$newClone.children("input").eq(1).attr("name",'mail'+can);
$newClone.children("input").eq(2).attr("name",'calle'+can);
$newClone.children("input").eq(3).attr("name",'nro'+can);
$newClone.children("input").eq(4).attr("name",'id_aval[]');

$newClone.insertAfter($('#resultados_aval'));
$('#div'+can).append("<h4>  COMPROMISO DE LAS ORGANIZACIONES </h4> <br>	<textarea name=\'compromiso_avales[]\' rows=\'4\' cols=\'120\'> </textarea> ");

$('#div'+can).append("<div id='btn_"+can+"' value='eliminar Aval' class='btn btn-primary'> Quitar </div><br><br>");
 
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_"+can).bind("click",delRow);			

//finalmente vacio los div de busqueda y resultado 
 $('#busqueda_aval').val('');
  $('#resultados_aval').html('');
		
}
/*
var cant1 = 0 ;

function agregarDiaCronoActividad(){     		// detalles del crono del form de nueva actividad
 cant1 = (cant1+1);
$newClone = $('#crono_act').clone(true);

//Le asigno el nuevo numero id
$newClone.attr("id",'div'+cant1);

//$newClone.children("input").eq(0).attr("name",'nombre_act[]');
$newClone.children("input").eq(0).attr("name",'dia_act[]');
$newClone.children("input").eq(0).attr("id",'datepic'+cant1);
$newClone.children("input").eq(1).attr("name",'horario_act[]');
$newClone.children("input").eq(2).attr("name",'descripcion_act[]');
//$newClone.children("input").eq(4).attr("name",'duracion_act[]');
//$newClone.children("input").eq(5).attr("name",'presupuesto_act[]');

$newClone.children("div").eq(0).attr("id",'btn_quitar_'+cant1);
$("<br>").insertAfter($('#crono_act'));
$newClone.insertAfter($('#crono_act'));
//$('#div'+cant1).append("<div id='btn_"+cant1+"'  class='btn_quitar'> Quitar </div>");
 $('#div'+cant1).show();

//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_quitar_"+cant1).bind("click",delRow);			

//$('#div'+cant1).show();
 $(function() {
    $("#datepic"+cant1).datepicker();
  });

}

*/
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
 /*	var atLeastOneIsChecked = $('input:checkbox').is(':checked');
	if (!($("#codirector").length > 0 ))
		alert('seleccione un co director');

	else if ($("#denominacion").val().length < 7 )
		alert('complete el nombre o denominacion del proyecto');
	
	else if ($("#resumen").val().length < 10) 
		alert('complete un resumen');
	/*
	else if (!(atLeastOneIsChecked))
		alert('seleccione al menos un destinatario');
						
	else if ($("#pvcia").val() === "") 
		alert('seleccione una provincia');
		
	else if ($("#localidad").val() === "") 
		alert('seleccione una localidad');
	
	else if ($("#duracion").val() === "") 
		alert('complete duracion');
		//$("#duracion").onfocus();
		
	/*else if ($("#presupuesto").val() == "") 
		alert('complete presupuesto');
*//*
	else if ($("#problematica").val().length < 10) 
		{alert('complete la problematica');
		$("#problematica").focus();
	}
	else if ($("#funda_proyecto").val().length < 10) 
		alert('fundamente el proyecto');

	else if ($("#funda_destina").val().length < 10) 
		alert('fundamente los destinatarios');
 /*
	else if ($("#objetivos").val().length < 10) 
		alert('Añada objetivos');

	else if ($("#IndicadoresCuantitativos").val().length < 10) 
		alert('agrege Indicadores Cuantitativos');

	else if ($("#IndicadoresCualitativos").val().length < 10) 
		alert(' agrege Indicadores Cualitativos');

	else if ($("#antecedentes").val().length < 10) 
		alert('complete antecedentes');
/*
	else if ($("#localidad").val() === "") 
		alert('seleccione una localidad');



	else if ($("#localidad").val() === "")  
		alert('seleccione una localidad');
	else */
	//	alert('faltan completar datos !!');
		$('#form_proyecto').submit();	

	
}

function validarFormActividad(){
	/*var atLeastOneIsChecked = $('input:checkbox').is(':checked');
	if ($("#denominacion").val().length < 7 )
		alert('complete el nombre o denominacion ');
	/*
	else if ($("#resumen").val().length < 10) 
		alert('complete un resumen');
	
	else if (!(atLeastOneIsChecked))
		alert('seleccione al menos un destinatario');
						
	else if ($("#duracion").val() === "") 
		alert('complete duracion');
		//$("#duracion").onfocus();
		
	else if ($("#presupuesto").val() == "") 
		alert('complete presupuesto');

	
 /*
	else if ($("#objetivos").val().length < 10) 
		alert('Añada objetivos');

	else if ($("#IndicadoresCuantitativos").val().length < 10) 
		alert('agrege Indicadores Cuantitativos');

	else if ($("#IndicadoresCualitativos").val().length < 10) 
		alert(' agrege Indicadores Cualitativos');

	else if ($("#antecedentes").val().length < 10) 
		alert('complete antecedentes');
/*
	else if ($("#localidad").val() === "") 
		alert('seleccione una localidad');



	else if ($("#localidad").val() === "")  
		alert('seleccione una localidad');
	alert('faltan completar datos !!');
	*/	$('#form_actividad').submit();	

	
}
	
	
