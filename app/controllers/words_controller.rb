class WordsController < ApplicationController
	before_filter :authenticate_user!

	def new
		@word = current_user.words.new
		@words = current_user.words.all
	end

	def create
		@words = current_user.words.all
		@word = current_user.words.build(params[:word])
		@word.name.downcase!
		@theWord = Wordnik.word.get_definitions(params[:word][:name])
		if @theWord.blank?
			flash[:error] = "That isn't a real word to our knowledge..."
			render 'new'
		else
			if @word.save
				flash[:success] = "Word added"
				if current_user.words.length > 5
					QuizMailer.quiz_email(current_user).deliver
				end
				redirect_to root_path
			else
				flash[:error] = @word.errors.full_messages[0]
				render 'new'
			end
		end
	end

end
