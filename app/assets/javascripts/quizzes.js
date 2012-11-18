var monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December']

function printCalendar(date,quizzes){

	// remove table rows currently showing starting at row 1
	$('#quiz_calendar table').find("tr:gt(0)").remove();

	date = typeof date !== 'undefined' ? date : new Date();

	// print Calendar head
	$('#quiz_calendar #nav .title').text(monthNames[date.getUTCMonth()] + " " + date.getUTCFullYear());

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
			$('<tr />').appendTo('table');	
			for(var i=0;i<7;i++)
			{
				$('<td />').appendTo('table tr:last-child');
			}
		};
		if(row == 2 && col <= shift)
		{
			col = shift + 1;
		};
		$('<div />', {
						class: 'day',
						text: dayCounter,
						}).appendTo('table tr:nth-child('+row+') td:nth-child('+col+')');
		
		$.each(monthQuizzes, function(index, obj){
			if(dayCounter == obj.created_at.getUTCDate())
			{
				if (obj.responded == true){
					$('table tr:nth-child('+row+') td:nth-child('+col+') div.day').wrap('<a href="/quizzes/' + obj.id + '" />');
					$('<div />', { class: 'responded', text: obj.score + "%" }).appendTo('table tr:nth-child('+row+') td:nth-child('+col+') a');
				}else{
					$('table tr:nth-child('+row+') td:nth-child('+col+') div.day').wrap('<a href="/quizzes/' + obj.id + '/respond" />');
					$('<div />', { class: 'not_responded' }).appendTo('table tr:nth-child('+row+') td:nth-child('+col+') a');
					$('<span />', { text: 'take quiz' }).appendTo('tr:nth-child('+row+') td:nth-child('+col+') div.not_responded');
				}
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
			$('table td').text('');
			x = new Date(current_date.getUTCFullYear(), current_date.getUTCMonth()+1)
			printCalendar(x,quizzes);
			current_date = x;
		});

		$('#last_month').click(function(){
			$('table td').text('');
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