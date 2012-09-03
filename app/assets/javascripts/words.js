$(document).ready(function(){

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
		$('.single_definition').remove();	
		open = false;
	}
	function isSubmittable(){
		if($('#addDefinitionContainer input:checked').length > 0){
			return true;
		}else{
			return false;
		}
	}

	$('input#word_name').keyup(function(e){
		if(open && e.keyCode != 13) {
			rollUp();
			clearFlash();
			revertButtons();
		}
	});
	$('button#findDefinitions').click(function(){
		if(getWord() != ''){
			clearFlash();
			ajaxCall(getWord());	
			searchedWord = getWord();
		}
	})
	$('input[type=submit]').click(function(e){
		if(!isSubmittable()){
			e.preventDefault();
			return false;
		}else{
			$('form').serialize();
			$('form').submit();
			rollUp();
			revertButtons();
			var data = { 'success': "Word successfully saved." };
			printFlash(data);
		}	
	})

	$(window).keydown(function(e){
		if(e.keyCode == 13){	
			if(!isSubmittable()){
				searchedWord = getWord();
				if(!open){
					if(getWord() != ''){
						clearFlash();
						open = false;
						ajaxCall(getWord());	
					}	
				}else{ // it's open
					if(getWord() != searchedWord){
						clearFlash();
						open = false;
						ajaxCall(getWord());	
					}	
				}
				e.preventDefault();
				return false;
			}else{
				$('form').serialize();
				$('form').submit();
				rollUp();
				revertButtons();
				var data = { 'success': "Word successfully saved." };
				printFlash(data);			
			}
		}
	});


	function addDefsToForm(data){
		$.each(data, function(index,item){
			var radio = $('<input />', { 	id: 'word_definition_'+index,
											class: 'checkbox',
											name: 'word_definition[]',
											type: 'checkbox',
											value: item['text'],
										}).wrap('<label />').parent().appendTo("#addDefinitionContainer")
			$('label').last().wrap('<div class="single_definition" />')
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
})