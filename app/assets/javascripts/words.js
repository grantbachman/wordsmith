$(document).ready(function(){

if($('#findWord').length > 0){ // Make sure the js only executes on the add_word page
	var searchedWord = getWord();
	var open = false; // if the form isn't in it's original state

	function getWord(){
		return $.trim($('input#word_name').val());
	}

	function progressButtons(){
		$('button#findDefinitions').hide();
		$('input[type=submit]').show();
	}	

	function revertButtons(){
		$('input[type=submit]').hide();
		$('button#findDefinitions').show();
	}

	function clearFlash(){
		$('.single_error').remove();
	}

	function rollUp(){
		$('#addDefinitionContainer').slideUp('slow');
		$('div#addDefinitionContainer li').remove();	
		open = false;
	}
	function isSubmittable(){
		if($('#addDefinitionContainer input:checked').length > 0){
			return true;
		}else{
			return false;
		}
	}
	// They are changing their searched word
	$('input#word_name').keyup(function(e){
		if(open && e.keyCode != 13) {
			rollUp();
			clearFlash();
			revertButtons();
		}
	});
	$('button#findDefinitions').click(function(){
		if(getWord() != ''){
			clearFlash(); // Predominantly for the Success flash
			ajaxCall(getWord());	
			searchedWord = getWord();
		}
	})
	$('input[type="submit"]').click(function(e){
		if(isSubmittable()){
			$('form').serialize();
			$('form').submit();
			rollUp();
			revertButtons();
			var data = { 'success': "\'" + getWord() + "\' successfully saved." };
			printFlash(data);
			$("input#word_name").val('');
		}	
		e.preventDefault();
		return false;
	})

	$(window).keydown(function(e){
		if(e.keyCode == 13){
			// If they are hitting 'find definitions' button (with enter key)
			if(!isSubmittable()){
					if(open){ rollUp(); }	
					clearFlash();
					ajaxCall(getWord());
					searchedWord = getWord();	
			}else{ // They are submitting the form
				$('form').serialize();
				$('form').submit();
				rollup();
				revertbuttons();
				var data = { 'success': "\'" + getword() + "\' successfully saved." };
				printflash(data);			
				$("input#word_name").val('');
			}
			// Regardless, prevent the default submission of the form since
			// I'm doing an ajax submit
			e.preventDefault();
			return false;
		}
	});


	function addDefsToForm(data){
		$.each(data, function(index,item){
			if(index > 4){ return false; }
			var checkbox = $('<input />', { id: 'word_definition_'+index,
											class: 'checkbox',
											name: 'word_definition[]',
											type: 'checkbox',
											value: item['text'],
										}).wrap('<label />').parent().appendTo("#addDefinitionContainer ul")
			$('label').last().wrap('<li />')
			$('label').last().append(item['text']);
		});
		$('#addDefinitionContainer').slideDown('slow');
		searchedWord = getWord();
		open = true;	
	}

	function printFlash(data){
		if(data['error']){
			var error = $('<div />', {	class: "alert alert-error",
										text: data['error'],
									 }).wrap('<div class="single_error" />').parent().appendTo("#fieldAndErrorsContainer");
		}
		else if (data['notice']){
			var notice = $('<div />', {	class: "alert alert-notice",
										text: data['notice'],
									 }).wrap('<div class="single_error" />').parent().appendTo("#fieldAndErrorsContainer");
		}
		else if (data['success']){
			var success = $('<div />', {	class: "alert alert-success",
										text: data['success'],
									 }).wrap('<div class="single_error" />').parent().appendTo("#fieldAndErrorsContainer");
		}
		open = true;
		$('#fieldAndErrorsContainer').slideDown('slow');
	}

	function checkResults(data){
		if(data['error'] || data['notice']){
			printFlash(data);
		}else{	
			addDefsToForm(data);
			progressButtons();
		}
	}

	function ajaxCall(word){
		$.ajax({
				url: 'words/get_definition',
				data: 'word='+word,
				dataType: 'json',
				success: checkResults,
		});
	};
	$('body').change(function(event){ // Use event bubbling because these elements were dynamically generated
		if($(event.target).is('input[name^="word_definition"][type="checkbox"]')){
			if($(event.target).is(":checked")){
				$(event.target).parent().parent().addClass("greenBackground");
			} else {
				$(event.target).parent().parent().removeClass("greenBackground");
			}
		}
	})

}
})