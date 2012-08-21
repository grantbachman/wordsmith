class IncomingEmailsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def create

		body = params(['stripped-text'])

		#find the auth_hash
		if (match = body[/auth_hash:\h{64}:/])
			auth_hash = match[-65..-2]
		end
		quiz = Quiz.find_by_auth_hash(auth_hash)

		#find number of questions in the quiz
		num_questions = quiz.answer_key.split(',').count

		#find the answer text in the form of [digit][period][letter][comma], and format the string
		if (match = body[/(\d\s?\.?\s?[a-zA-Z]\s?,\s?){#{num_questions-1}}(\d\s?\.?\s?[a-zA-Z]\s?){1}/])
			match.gsub!('.','')
			match.gsub!(' ','')
			match.gsub!('/\d/','')
			returned_answers = match.split(',')	
		end
			
	end

	def index
		render text: "This is text. I have spoken."
	end

end
