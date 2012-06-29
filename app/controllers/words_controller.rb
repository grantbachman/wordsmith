
class WordsController < ApplicationController

	before_filter :authenticate_user!

	def new
		@word = current_user.words.new
		@words = current_user.words.all
	end

	def create
		@words = current_user.words.all
		@word = current_user.words.build(params[:word])
		if @word.save
			flash[:success] = "Word added"
			redirect_to root_path
		else
			render 'new'
		end
	end
end
