$(document).ready(function(){

	// add a confirmation box if there are any unanswered questions	
	$('.new_quiz form').submit(function(){
			var blank = 0;

		$('.choices').children().map(function(){
			if(!$.trim($(this).val())){
				blank = blank + 1;
			}
		})
		if(blank > 0){
			var pluralize = ['', 'it']	
			if(blank > 1){
				pluralize = ['s', 'they']
			}	
			return confirm("You have " + blank + " unanswered question" + 
				pluralize[0] + ".. Submit now and " + 
				pluralize[1] + " will be marked wrong. Are you sure?");
		}
	});
});