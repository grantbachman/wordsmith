class QuizzesController < ApplicationController

	before_filter :authenticate_user!
	before_filter :correct_user, only: [:show]

	def new
		@quiz = current_user.quizzes.create
		redirect_to respond_quiz_path(@quiz.id)
	end

	def show
		# redirect to quizzes_path if Quiz doesn't exit
		# make it a function
		@quiz = Quiz.find(params[:id])
		@questions = @quiz.questions.find(:all, order: "number")
	end

	def index
		@quizzes = current_user.quizzes.find(:all, order: "created_at DESC")
	end

	def respond
		@quiz = Quiz.find(params[:id])
		if (@quiz.difficulty < 3)
			@options = ''
			@quiz.word_bank.split(',').each { |word| @options += '<option>' + word + '</option>' }
		end	

		redirect_to quiz_path(params[:id]) if @quiz.responded?
	end

	def check_answers
		quiz_hash = convert_to_hash
		grade_quiz(quiz_hash)
		redirect_to quiz_path(quiz_hash['quiz_id'])
	end


	# This could/should go into the model 
	def grade_quiz(quiz_hash)
		@quiz = Quiz.find(quiz_hash['quiz_id'])
		@quiz.questions.each do |question|
			answer = question.answer
			answer.response = quiz_hash["#{question.number}"].downcase.strip if quiz_hash.has_key?("#{question.number}")
			answer.correct = (answer.full_value == answer.response ? true : false )
			if answer.correct?
				question.word.increment_level(@quiz.id)
			else
				question.word.decrement_level(@quiz.id)
			end
			question.word.save
			answer.save
		end	
		@quiz.update_attributes(responded: true)
		#redirect_to quiz_path(@quiz.id)
	end

	def quiz_from_email 

		auth_hash_pattern = 'auth_hash:\h{64}:'

		body = params["body-plain"]

		# find the auth_hash
		if (match = body[/#{auth_hash_pattern}/])
			auth_hash = match[-65..-2]
			body.sub!(/#{auth_hash_pattern}/, '')
		end
		quiz = Quiz.find_by_auth_hash(auth_hash)

		# received_hash will be in the form of { question number => question answer }
		@received_hash = parse_email(body, quiz.questions.count)

		@quiz_hash = { 'quiz_id' => quiz.id }
		@received_hash.each do |key, value|
			quiz.questions.each do |question|
				if value.in?([question.answer.full_value, question.answer.alpha_value])
					@quiz_hash[key] = question.answer.full_value
				end
				@quiz_hash[key] ||= value
			end
		end

		grade_quiz(@quiz_hash)	

		#render 'create'
		#render nothing: true
	end

	private

		def grade_quiz(quiz_hash)
			@quiz = Quiz.find(quiz_hash['quiz_id'])
			@quiz.questions.each do |question|
				answer = question.answer
				answer.response = quiz_hash["#{question.number}"].downcase.strip if quiz_hash.has_key?("#{question.number}")
				answer.correct = (answer.full_value == answer.response ? true : false )
				if answer.correct?
					question.word.increment_level(@quiz.id)
				else
					question.word.decrement_level(@quiz.id)
				end
				question.word.save
				answer.save
			end	
			@quiz.update_attributes(responded: true)
			#redirect_to quiz_path(@quiz.id)
		end

		def parse_email(body, num_questions)

			hash = {}
			body.squish!
			# 1 or 2 digits, 0 or more non-word characters, 0 or more characters, 0 or more non-word characters, repeated num_questions times

			body.scan(/(\d{1,2})\W?[^a-zA-Z]?([a-zA-Z]+)\W?/) do |number,response|
				hash[number] = response
			end
			return hash
		end	

		def convert_to_hash
			quiz_hash = {}
			quiz_hash['quiz_id'] = params[:id]
			quiz = Quiz.find(params[:id])
			quiz.questions.each do |question|
				quiz_hash["#{question.number}"] = params["question_#{question.number}"]
			end
			return quiz_hash
		end

		def correct_user
			redirect_to root_path, notice: "That quiz doesn't belong to you." if Quiz.find(params[:id]).user != current_user 
		end

end
