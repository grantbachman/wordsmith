var open = false;
var searchedWord;
function revertButtons(){
			$('input[type=submit]').hide();
			$('button#findDefinitions').show();
		}
function rollUp(){
			$('#addDefinitionContainer').slideUp();	
			$('.single_error').slideUp();
			$('.single_error').remove();		
			$('#addDefinitionContainer li').remove();
			open = false;
		}
$(document).ready(function(){
	if($('#findWord').length > 0){

		//var searchedWord
		/* var open is declared in application.js
		var open = false;
		*/

		function getWord(){
			return $.trim($('input#word_name').val());
		}
		function isSubmittable(){
			if($('#addDefinitionContainer input:checked').length > 0){
				return true;
			} else { return false; }
		};
		function progressButtons(){
			$('button#findDefinitions').hide();
			$('input[type=submit]').show();
		}	

		/* moved function to application.js
		function revertButtons(){
			$('input[type=submit]').hide();
			$('button#findDefinitions').show();
		}
		*/
		function submitForm(){
			if(isSubmittable()){
				$('#findWord form').serialize();
				$('#findWord form').submit();
			}
		}
		function canFindWord(){
			if(!isSubmittable() &&
				getWord() != '' &&
				(searchedWord != getWord() || !open))
			{
				return true;
			} else { return false;}
		}
		function printFlash(data){
			if (data['notice']){
				var notice = $('<div />', {	class: "alert alert-notice",
											text: data['notice'],
										 }).wrap('<div class="single_error" />').parent().appendTo("#fieldAndErrorsContainer");
			}
			if (data['error']){
				var notice = $('<div />', {	class: "alert alert-error",
											text: data['error'],
										 }).wrap('<div class="single_error" />').parent().appendTo("#fieldAndErrorsContainer");
			}
		}
		function rollUp(){
			$('#addDefinitionContainer').slideUp();	
			$('.single_error').slideUp();
			$('.single_error').remove();		
			$('#addDefinitionContainer li').remove();
			open = false;
		}
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
				$('label').last().prepend('<div class="checkmark" />');
				$('label').last().append('<div class="checkmarkText" />');
				$('.checkmarkText').last().html(item['text']);
			});
			$('#addDefinitionContainer').slideDown('slow');
		}	
		function results(data){
			if(data['error'] || data['notice']){
				printFlash(data);
			}else{
				addDefsToForm(data);
				progressButtons();
			}
			searchedWord = getWord();
			open = true;
		}

		$('input#word_name').keyup(function(e){
			if(e.which != 13 && open){
				rollUp();	
				revertButtons();
			}
		})
		$('button#findDefinitions').click(function(){
			if(canFindWord()){
				ajaxCall(getWord());
			}
		});			
		$(window).keydown(function(e){
			if(e.which == 13){
				if(canFindWord()){
					ajaxCall(getWord());
				}else{
					submitForm();
				}
			}
		});
		$('#findWord form').submit(function(){
			submitForm();
			return false;
		});

	
		function ajaxCall(word){
			$.ajax({
					url: 'words/get_definition',
					data: 'word='+word,
					dataType: 'json',
					success: results,
			});
		};
		

	};
	if($('#editWord').length > 0){
		$('input[id="word_definition"]').each(function(){
			if($(this).is(":checked")){
				$(this).prev().addClass('checkmark-check');		
			}
		})
	};
	$('body').change(function(event){ // Use event bubbling because these elements were dynamically generated
		if($(event.target).is('input[name^="word_definition"][type="checkbox"]')){
			if($(event.target).is(":checked")){
				$(event.target).prev().addClass('checkmark-check')
				//$(event.target).parent().parent().addClass("greenBackground");
			} else {
				$(event.target).prev().removeClass('checkmark-check')
				//$(event.target).parent().parent().removeClass("greenBackground");
			}
		}
	})	
});



/*
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
				searchedWord == '';
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
				open = true;
				//var data = { 'success': "\'" + getWord() + "\' successfully saved." };

				//printFlash(data);
				$("input#word_name").val('');
			}	
			e.preventDefault();
			return false;
		})

		$('form').keydown(function(e){
			if(e.keyCode == 13){
				// If they are hitting 'find definitions' button (with enter key)
				if(!isSubmittable()){
					if((searchedWord != getWord()) || !open){
						if(open){ rollUp(); }
						clearFlash();
						ajaxCall(getWord());
						searchedWord = getWord();
					}
				}else{ // They are submitting the form
					$('form').serialize();
					//$('form').submit();
					rollup();
					alert("world");
					revertbuttons();
					open = true;
					//var data = { 'success': "\'" + getword() + "\' successfully saved." };
					//printflash(data);			
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
				$('label').last().prepend('<div class="checkmark" />');
				$('label').last().append('<div class="checkmarkText" />');
				$('.checkmarkText').last().html(item['text']);
			});
			$('#addDefinitionContainer').slideDown('slow');
			searchedWord = getWord();
			open = true;	
		}

		function printFlash(data){
			if (data['notice']){
				var notice = $('<div />', {	class: "alert alert-notice",
											text: data['notice'],
										 }).wrap('<div class="single_error" />').parent().appendTo("#fieldAndErrorsContainer");
			}
			open = true;
			//$('#fieldAndErrorsContainer').slideDown('slow');
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
	};

	if($('#editWord').length > 0){
		$('input[id="word_definition"]').each(function(){
			if($(this).is(":checked")){
				$(this).prev().addClass('checkmark-check');		
			}
		})
	};

	$('body').change(function(event){ // Use event bubbling because these elements were dynamically generated
		if($(event.target).is('input[name^="word_definition"][type="checkbox"]')){
			if($(event.target).is(":checked")){
				$(event.target).prev().addClass('checkmark-check')
				//$(event.target).parent().parent().addClass("greenBackground");
			} else {
				$(event.target).prev().removeClass('checkmark-check')
				//$(event.target).parent().parent().removeClass("greenBackground");
			}
		}
	})

})

*/