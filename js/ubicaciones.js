$(document).ready(function(){

$("#btn_agregar_establecimiento").hide();
$('#btn_agregar_establecimiento').bind("click",agregar_establecimiento);

/*//////////////////AGREGAR PROYECTOS EXT A ACTIVIDADES///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

$('#btn_agregar_proyecto_extension').bind("click",function(){
	 var id_barrio = $("#proyecto_extension option:selected").val();
	 var barrio = $("#proyecto_extension option:selected").text();
	 if(id_barrio != "0"){
	 	
	 	$("<tr id='proyecto_extension"+id_barrio+"' > </tr>").insertAfter("#lista_proyecto_extension");
	 	//$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly value='"+provincia+"'>");
	 	$("#proyecto_extension"+id_barrio).append("<td ><input class='form-control 'readonly name=proyecto_extension[] value='"+barrio+"'>");
	 	$("#proyecto_extension"+id_barrio).append("<input hidden name=id_proyecto_extension[] value="+id_barrio+"></td>");
	 	$("#proyecto_extension"+id_barrio).append("<td class='btn_quitar '> </td>");
	 	
	 }

});

/*//////////////////BARRIOS DE MAR DEL PLATA////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

$('#btn_agregar_barrio_mdp').bind("click",function(){
	 var id_barrio = $("#barrios_mdp option:selected").val();
	 var barrio = $("#barrios_mdp option:selected").text();
	 if(id_barrio != "0"){
	 	
	 	$("<tr id='barrio_proyecto"+id_barrio+"' > </tr>").insertAfter("#lista_barrios_mdp");
	 	//$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly value='"+provincia+"'>");
	 	$("#barrio_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly name=barrio_mdp[] value='"+barrio+"'>");
	 	$("#barrio_proyecto"+id_barrio).append("<input hidden name=id_barrio_mdp[] value="+id_barrio+"></td>");
	 	$("#barrio_proyecto"+id_barrio).append("<td class='btn_quitar '> </td>");
	 	
	 }

});
/*//////////////////OTRAS LOCALIDADES EN PROVINCIA DE BUENOS AIRES/////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////*/
$('#btn_agregar_localidad_pvcia').bind("click",function(){
	 var id_barrio = $("#localidades_pvcia option:selected").val();
	// var barrio = $("#localidades_pvcia option:selected").text();
	var barrio = $('#localidades_pvcia').find("option:selected").text();

 	if(id_barrio != "0"){
	 	$("<tr id='localidad_proyecto"+id_barrio+"' > </tr>").insertAfter("#lista_localidad_pvcia");
	 	//$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly value='"+provincia+"'>");
	 	$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly name=localidades[] value='"+barrio+"'>");
	 	$("#localidad_proyecto"+id_barrio).append("<input hidden name=id_localidades[] value="+id_barrio+"></td>");
	 	$("#localidad_proyecto"+id_barrio).append("<td class='btn_quitar '> </td>");
	 }

});

/* ///////////////////RESTO DEL PAIS/////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////*/

$('#btn_agregar_localidad_resto').bind("click",function(){
	 var id_barrio = $("#localidad option:selected").val();
	 var barrio = $("#localidad option:selected").text();
	 var provincia = $('#pvcia option:selected').text();
	 if(id_barrio != "0"){
	 	
	 	$("<tr id='localidad_proyecto"+id_barrio+"' > </tr>").insertAfter("#lista_localidad_resto");
	 	$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly value='"+provincia+"'>");
	 	$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly name=localidades[] value='"+barrio+"'>");
	 	$("#localidad_proyecto"+id_barrio).append("<input hidden name=id_localidades[] value="+id_barrio+"></td>");
	 	$("#localidad_proyecto"+id_barrio).append("<td class='btn_quitar '> </td>");
	 	
	 }
});


	});


var cane = 0 ;

function agregar_establecimiento(){     		// avales de organizaciones
 cane = (cane+1);
$('#btn_agregar_establecimiento').hide();
// Creo un clon del elemento div que contiene los campos de texto
$newClone = $('#resultados_establecimiento').clone(true);
 
//Le asigno el nuevo numero id
$newClone.attr("id",'div_estable'+cane);
$newClone.children("input").eq(0).attr("name",'razon'+cane);
$newClone.children("input").eq(1).attr("name",'mail'+cane);
$newClone.children("input").eq(2).attr("name",'calle'+cane);
$newClone.children("input").eq(3).attr("name",'nro'+cane);
$newClone.children("input").eq(4).attr("name",'id_establecimiento[]');

$newClone.insertAfter($('#resultados_establecimiento'));

$('#div_estable'+cane).append("<div id='btn_quitar_establecimiento"+cane+"' value='' class='btn_quitar'>  </div><br>");
////$('#div_estable'+cane).append('<input hidden name=id_localidades_pvcia[] value='+id_barrio+'>');
//Ahora le asigno el evento delRow para que borre la fila en caso de hacer click
$("#btn_quitar_establecimiento"+cane).bind("click",delRow);			

//finalmente vacio los div de busqueda y resultado 
 $('#busqueda_establecimiento').val('');
  $('#resultados_establecimiento').html('');
		
}

function agrega_programa(id_programa,nombre_programa)
{

	$("#lista_programas").append("<div id='programa_proyecto"+id_programa+"'> </div>");
	$("#programa_proyecto"+id_programa).append('<input readonly name=programa_proyecto[] value='+nombre_programa+'>');
	$("#programa_proyecto"+id_programa).append('<input hidden name=id_programa_proyecto[] value='+id_programa+'>');
	$("#programa_proyecto"+id_programa).append("<div id=btn_quitar_programa_"+id_programa+" class='btn_quitar'>   </div>");
	$("#btn_quitar_programa_"+id_programa).bind("click",delRow);		
	$("#programa_"+id_programa).hide();	

}
function agrega_centro(id_programa,nombre_programa)
{

	$("#lista_centros").append("<div id='centro_proyecto"+id_programa+"'> </div>");
	$("#centro_proyecto"+id_programa).append('<input readonly name=centro_proyecto[] value='+nombre_programa+'>');
	$("#centro_proyecto"+id_programa).append('<input hidden name=id_centro_proyecto[] value='+id_programa+'>');
	$("#centro_proyecto"+id_programa).append("<div id=btn_quitar_centro_"+id_programa+" class='btn_quitar'>   </div>");
	$("#btn_quitar_centro_"+id_programa).bind("click",delRow);		
	$("#centro_"+id_programa).hide();	

}
function agrega_grupo(id_programa,nombre_programa)
{

	$("#lista_grupos").append("<div id='grupos_proyecto"+id_programa+"'> </div>");
	$("#grupos_proyecto"+id_programa).append('<input readonly name=grupos_proyecto[] value='+nombre_programa+'>');
	$("#grupos_proyecto"+id_programa).append('<input hidden name=id_grupos_proyecto[] value='+id_programa+'>');
	$("#grupos_proyecto"+id_programa).append("<div id=btn_quitar_programa_"+id_programa+" class='btn_quitar'>   </div>");
	$("#btn_quitar_grupo_"+id_programa).bind("click",delRow);		
	$("#grupo_"+id_programa).hide();	

}
