function printCalendar(date){
	// remove table rows currently showing
	$('#calendar').find("tr:gt(0)").remove();

	var month = ['January','February','March','April','May','June','July','August','September','October','November','December']

	date = typeof date !== 'undefined' ? date : new Date();

	// handle calendar
	$('#calendar_nav .title').text(month[date.getMonth()] + " " + date.getFullYear());

	var numDays = new Date(date.getFullYear(),date.getMonth()+1,0).getDate(); 
	var shift = new Date(date.getFullYear(),date.getMonth(),1).getDay();

	var dayCounter = 1;
	var row = 2;
	var col = 1;
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
	var current_date = new Date();

	printCalendar(current_date);


	$('#next_month').click(function(){
		$('#calendar td').text('');
		x = new Date(current_date.getFullYear(), current_date.getMonth()+1)
		printCalendar(x);
		current_date = x;
	});

	$('#last_month').click(function(){
		$('#calendar td').text('');
		x = new Date(current_date.getFullYear(), current_date.getMonth()-1)
		printCalendar(x);
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
});