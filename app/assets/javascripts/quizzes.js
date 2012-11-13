var monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December']

function printCalendar(date,quizzes){

	// remove table rows currently showing
	$('#calendar').find("tr:gt(0)").remove();

	date = typeof date !== 'undefined' ? date : new Date();

	// handle calendar
	$('#calendar_nav .title').text(monthNames[date.getUTCMonth()] + " " + date.getUTCFullYear());

	var numDays = new Date(date.getUTCFullYear(),date.getUTCMonth()+1,0).getUTCDate(); 
	var shift = new Date(date.getUTCFullYear(),date.getUTCMonth(),1).getDay();

	var dayCounter = 1;
	var row = 2;
	var col = 1;

	var monthQuizzes = [];

	$.each(quizzes, function(index,obj){
		if((obj.created_at.getUTCFullYear() == date.getUTCFullYear()) && (obj.created_at.getUTCMonth() == date.getUTCMonth())){
			monthQuizzes.push(obj);
		}
	});


	while(dayCounter<=numDays)
	{
		// add a new week
		if(col == 1)
		{
			$('<tr />').appendTo('#calendar');	
			for(var i=0;i<7;i++)
			{
				$('<td />').appendTo('#calendar tr:last-child');
			}
		};
		if(row == 2 && col < shift)
		{
			col = shift + 1;
		};
		$('#calendar tr:nth-child('+row+') td:nth-child('+col+')').text(dayCounter);	

		
		$.each(monthQuizzes, function(index, obj){
			if(dayCounter == obj.created_at.getUTCDate())
			{
				$('#calendar tr:nth-child('+row+') td:nth-child('+col+')').append("<br /><a href=\'/quizzes/" + obj.id + "\'>" + obj.id + "</a>");
			};
		});
		// increment
		dayCounter++;
		col++;
		if(col > 7)
		{
			row++;
			col = 1;
		};	
	};

};

$(document).ready(function(){
	if($('#quiz_calendar').length > 0)
	{

		var quizzes = $('#quiz_data').data('quizzes');
		$.each(quizzes, function(index, obj){
			obj.created_at = new Date(Number(obj.created_at));	
		});

		var current_date = new Date();

		printCalendar(current_date, quizzes);


		$('#next_month').click(function(){
			$('#calendar td').text('');
			x = new Date(current_date.getUTCFullYear(), current_date.getUTCMonth()+1)
			printCalendar(x,quizzes);
			current_date = x;
		});

		$('#last_month').click(function(){
			$('#calendar td').text('');
			x = new Date(current_date.getUTCFullYear(), current_date.getUTCMonth()-1)
			printCalendar(x,quizzes);
			current_date = x;
		});

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
	}
});