class IncomingEmailsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def create

		auth_hash_pattern = 'auth_hash:\h{64}:'

		body = params["body-plain"] + params["auth_hash"]

		# find the auth_hash
		if (match = body[/#{auth_hash_pattern}/])
			auth_hash = match[-65..-2]
			body.sub!(/#{auth_hash_pattern}/, '')
		end
		quiz = Quiz.find_by_auth_hash(auth_hash)

		# get array of questions
		questions = quiz.questions
		num_questions = questions.count

		# received_hash will be in the form of { question number => question answer }
		received_hash = parse_email(body, num_questions)
		
		received_hash.each do |key, value|
			if question = questions.find_by_number(key)
				answer = question.answer
				answer.correct = (value.in?([answer.full_value, answer.alpha_value]) ? true : false )	 	
				if answer.correct?
					answer.response = answer.full_value
				else
					found = false
					quiz.questions.each do |find_q|
						if value.in?([find_q.answer.full_value, find_q.answer.alpha_value])
							answer.response = find_q.answer.full_value
							found = true
						end
					end
					answer.response = value unless found == true
				end
				answer.save
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
		# 1 or 2 digits, 0 or more non-word characters, 0 or more characters, 0 or more non-word characters, repeated num_questions times
		body_pattern = '(\d{1,2}\W?[a-zA-Z]+\W?){num_questions}'
		# 1 or 2 digits, 0 or more non-word characters, 1 or more characters, 0 or more non-word characters, repeated num_questions times
		match = body[/(\d{1,2}\W?[a-zA-Z]+\W?){#{num_questions}}/]	
		#match = body[/(\d{1,2}\W*[a-zA-Z]+\W+){#{num_questions}}/]
		match.gsub!(/\W/,'')
		answers = match.scan(/\d+([a-zA-Z]+)/).flatten
		numbers = match.scan(/(\d+)[^\d]/).flatten.map{ |x| x.to_i }
		return Hash[numbers.zip(answers)]
	end		

end
