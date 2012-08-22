class IncomingEmailsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def create

		body = params["body-plain"]

		# find the auth_hash
		if (match = body[/auth_hash:\h{64}:/])
			auth_hash = match[-65..-2]
		end
		quiz = Quiz.find_by_auth_hash(auth_hash)

		# get array of questions
		questions = Question.where(quiz_id: quiz.id)

		# get the answer_key_array into the form [['a', 'palindrome'], ['b', 'paradox'], ['c', 'psycho']] 
		# => If I let the user answer with the word a two-dimensional array will be easier to navigate than a hash
		answer_key_array = quiz.answer_key.split(',')
		answer_key_array.each_with_index do |x, index|
			answer_key_array[index] = x.split(':')
		end

		# answers array with be in the form of ['a','b','c','d']
		received_answers_array = parse_email(body, questions.count)
		# get the received_answers_array into the form [['a', 'palindrome'], ['b', 'paradox'], ['c', 'psycho']] 
		# => for the same reason as above
		received_answers_array.each_with_index do |x, index|
			answer_key_array.each { |y| received_answers_array[index] = y if y[0] == x } 
		end

		# Save results
		answer_key_array.each_with_index do |arr, index|
			question = questions.where(word_id: Word.find_by_name(arr[1]).id).first
			question.answer = received_answers_array[index][1]
			if received_answers_array[index][1] == arr[1]
				question.correct = true
			else
				question.correct = false
			end
			question.save
		end

		render nothing: true	
	end

	def index
		#render text: "This is text. I have spoken."
		render nothing: true
	end

	def parse_email(body, num_questions)
		#find the answer text in the form of [digit][period][letter][comma], and format the string
		if (match = body[/(\d\s?\.?\s?[a-zA-Z]\s?,\s?){#{num_questions-1}}(\d\s?\.?\s?[a-zA-Z]\s?){1}/])
			match.gsub!('.','')
			match.gsub!(' ','')
			match.gsub!('/\d/','')
			returned_answers = match.split(',')	
			return returned_answers
		end
	end		

end
