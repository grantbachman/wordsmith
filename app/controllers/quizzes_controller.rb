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
		@quiz = Quiz.find(params[:id])
		@quiz.questions.each do |question|
			question.answer.response = params["question_#{question.number}"].downcase.strip
			question.answer.correct = (question.answer.full_value == question.answer.response ? true : false )
			question.answer.save
		end	
		@quiz.update_attributes(responded: true)
		redirect_to quiz_path(@quiz.id)
	end

	private

		def correct_user
			redirect_to root_path, notice: "That quiz doesn't belong to you." if Quiz.find(params[:id]).user != current_user 
		end

end
