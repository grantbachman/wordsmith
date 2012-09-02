$(document).ready(function(){

	function getWord(){
		return $.trim($('input#word_name').val());
	};

	var prevWord = getWord();

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
		progressButtons();
		$('#addDefinitionContainer').slideDown('slow');
	};

	function removeDefsAndSlideUp(){
		$('#addDefinitionContainer').slideUp('slow');
		$('.single_definition').remove();
		$('.single_error').remove();
	}

	function cleanUpAfterSave(){
		revertButtons();
		//$('input#word_name').val('');
		removeDefsAndSlideUp();

		var data = { 'success': "Word successfully saved." };
		printErrors(data);
	}
	function progressButtons(){
		$('form button#findDefinitions').hide();
		$('input[type=submit]').show();
	}
	function revertButtons(){
		$('input[type=submit]').hide();
		$('form button#findDefinitions').show();
	}

	$('form').submit(function(){
		if(isSubmittable()){
			$(this).serialize();
			$('input#word_name').val(prevWord);
			cleanUpAfterSave();
//			$('input#word_name').val('');
			return true;
		}else{ return false; }
	});

	$('input#word_name').keypress(function(event){
		if(event.which == 13){
			if(prevWord != getWord()){
				prevWord = getWord();
				removeDefsAndSlideUp();
				if(!$.trim(prevWord) == ''){
					fetchDefinitions();
				}else{ revertButtons(); }
			}
		}
	});
	$('form button#findDefinitions').click(function(){
		prevWord = getWord();
		removeDefsAndSlideUp();
		if(!$.trim(prevWord) == ''){
			fetchDefinitions();
		}else{ revertButtons(); }
	})

	function fetchDefinitions(){
		ajaxCall(getWord());
	}

	function checkResults(data){
		// if there are errors (unknown word, word already added), print them out
		// otherwise, add the results to the form
		if(data['error'] || data['notice']){
			printErrors(data);
		}else{	
			addDefsToForm(data);
		}
	}

	function printErrors(data){
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
		$('#fieldAndErrorsContainer').slideDown('slow');
	}
	function ajaxCall(word){
		$.ajax({
				url: 'words/get_definition',
				data: 'word='+word,
				dataType: 'json',
				success: checkResults,
		});
	};
	function isSubmittable(){
		if($('#addDefinitionContainer input:checked').length > 0){
			return true;
		}else{ return false; }
	}
});