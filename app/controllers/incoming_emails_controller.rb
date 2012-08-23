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
		questions = quiz.questions 

		# get the answer_key_array into the form [['palindrome', 'a'], ['paradox', 'b'], ['psycho', 'c']] 
		# => If I let the user answer with the word a two-dimensional array will be easier to navigate than a hash
		answer_key_array = quiz.answer_key.split(',')
		answer_key_array.each_with_index { |x, index| answer_key_array[index] = x.split(':') } 

		# answers array will be in the form of ['a','b','c','d']
		received_answers_array = parse_email(body, questions.count)

		received_answers_array.each_with_index do |x, index|
			question = questions.find_by_word_id(quiz.user.words.find_by_name(answer_key_array[index][0]))	
			question.correct = x.in?(answer_key_array[index]) ? true : false
			answer_key_array.each { |y| question.answer = y[0] if x.in?(y) }
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
