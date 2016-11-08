// autocomplet : this function will be executed every time we change the text
function autocomplet(nro) {
	var min_length = 0; // min caracters to display the autocomplete
	var keyword = $('#int_'+nro).val();
	var ajax_data = {
				keyword:keyword ,
				nro:nro 
				};
	if (keyword.length >= min_length) {
		$.ajax({
			url: "http://10.0.23.12/nuevo_sistema_2/index.php/filtro",
			type: 'POST',
			//data: {keyword:keyword},
			data: ajax_data,
			success:function(data){
				$('#integrantes_list_id').show();
				$('#integrantes_list_id').html(data);
			}
		});
	} else {
		$('#integrantes_list_id').hide();
	}
}

// set_item : this function will be executed when we select an item
function set_item(item,nro,nom,ape) {
	// change input value
	//$('#integrantes_id').val(item);
	// hide proposition list
	$('#integrantes_list_id').hide();
	$('#int_'+nro).val(item);
	$('#nom_'+nro).val(nom);
	$('#ape_'+nro).val(ape);
	
}
