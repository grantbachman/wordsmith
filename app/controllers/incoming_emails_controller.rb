class IncomingEmailsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def create

		auth_hash_pattern = 'auth_hash:\h{64}:'

		body = params["body-plain"]

		# find the auth_hash
		if (match = body[/#{auth_hash_pattern}/])
			auth_hash = match[-65..-2]
			body.sub!(/#{auth_hash_pattern}/, '')
		end
		quiz = Quiz.find_by_auth_hash(auth_hash)

		# get array of questions
		questions = quiz.questions
		num_questions = questions.count

		# get the answer_key_array into the form [['palindrome', 'a'], ['paradox', 'b'], ['psycho', 'c']] 
		# => If I let the user answer with the word a two-dimensional array will be easier to navigate than a hash
		answer_key_array = quiz.answer_key.split(',')
		answer_key_array.map! { |x| x.split(':') }


		# received_hash will be in the form of { question number => question answer }
		received_hash = parse_email(body, num_questions)


		received_hash.each do |key, value|
			if question = questions.find_by_number(key)	
				question.correct = value.in?(answer_key_array[key - 1]) ? true : false
				question.answer = value
				question.save!
			end
		end

		render nothing: true
	end

	def new	
	end

	def index
		render nothing: true
	end

	def parse_email(body, num_questions)

		body.squish!
		body_pattern = '(\d{1,2}\W*[a-zA-Z]*\W*){#{num_questions}}'	
		match = body[/(\d{1,2}\W*[a-zA-Z]*\W*){#{num_questions}}/]
		match.gsub!(/\W/,' ').squish!
		answers = match.scan(/\d+([a-zA-Z\s]+)/).flatten.map { |x| x.gsub(' ','') }
		numbers = match.scan(/(\d+)[^\d]/).flatten.map{ |x| x.to_i }
		return Hash[numbers.zip(answers)]
	end		

end
