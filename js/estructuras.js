$(document).ready(function(){

/*//////////////////BARRIOS DE MAR DEL PLATA////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

$('#btn_agregar_centro').bind("click",function(){
	//$("#prueba").html('entra');

	 var id_barrio = $("#buscar_centro option:selected").val();
	 var barrio = $("#buscar_centro option:selected").text();
	// if(id_barrio != "0"){
	  	$("<tr id='centro_proyecto"+id_barrio+"' > </tr>").insertAfter("#lista_centro_proyecto");
	  	$("#centro_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly name=centro_proyecto[] value='"+barrio+"'>");
	 	$("#centro_proyecto"+id_barrio).append("<input hidden name=id_centro_proyecto[] value="+id_barrio+"></td>");
	 	$("#centro_proyecto"+id_barrio).append("<td class='btn_quitar '> </td>");
	 //	 }

});
/*//////////////////BARRIOS DE MAR DEL PLATA////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

$('#btn_agregar_programa').bind("click",function(){
	 var id_barrio = $("#buscar_programa option:selected").val();
	 var barrio = $("#buscar_programa option:selected").text();
 	
	 	$("<tr id='programa_proyecto"+id_barrio+"' > </tr>").insertAfter("#lista_programa_proyecto");
	 	//$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly value='"+provincia+"'>");
	 	$("#programa_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly name=programa_proyecto[] value='"+barrio+"'>");
	 	$("#programa_proyecto"+id_barrio).append("<input hidden name=id_programa_proyecto[] value="+id_barrio+"></td>");
	 	$("#programa_proyecto"+id_barrio).append("<td class='btn_quitar '> </td>");

});

/*//////////////////BARRIOS DE MAR DEL PLATA////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

$('#btn_agregar_grupo').bind("click",function(){
	 var id_barrio = $("#buscar_grupo option:selected").val();
	 var barrio = $("#buscar_grupo option:selected").text();
	 	 	
	 	$("<tr id='grupo_proyecto"+id_barrio+"' > </tr>").insertAfter("#lista_grupo_proyecto");
	 	//$("#localidad_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly value='"+provincia+"'>");
	 	$("#grupo_proyecto"+id_barrio).append("<td ><input class='form-control 'readonly name=grupo_proyecto[] value='"+barrio+"'>");
	 	$("#grupo_proyecto"+id_barrio).append("<input hidden name=id_grupo_proyecto[] value="+id_barrio+"></td>");
	 	$("#grupo_proyecto"+id_barrio).append("<td class='btn_quitar '> </td>");
	 
});

});