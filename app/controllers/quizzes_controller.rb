class QuizzesController < ApplicationController

	before_filter :authenticate_user!
	before_filter :correct_user, only: [:show]

	def show
		@quiz = Quiz.find(params[:id])
		@questions = @quiz.questions.find(:all, order: "number")
	end

	def index
		@quizzes = current_user.quizzes.find(:all, order: "created_at DESC")
	end


	def correct_user
		redirect_to root_path, notice: "That quiz doesn't belong to you." if Quiz.find(params[:id]).user != current_user 
	end

end
