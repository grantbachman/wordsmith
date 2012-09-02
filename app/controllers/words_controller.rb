class WordsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@words = Word.where(user_id: current_user)
		@word = current_user.words.new
		@defs = Array.new
	end

	def new
	end

	def create
		@words = Word.where(user_id: current_user)
		@word = current_user.words.build
		@word.name = params['word_name']
		@word.definition = params['word_definition']
		@word.name.downcase!
		#@defs = Wordnik.word.get_definitions(@word.name)
		#if @defs.blank? # change this to handle nonwords with "did you mean..." 
		#	flash.now[:error] = "That isn't a real word to our knowledge..."
#		else
			if @word.save
				flash.now[:success] = "Word added. You'll be quizzed on it soon."
				#QuizMailer.quiz_email(current_user).deliver
			else
				flash.now[:error] = @word.errors.full_messages[0]
			end

		#end
		render nothing: true
	end

	def show
		render nothing: true
	end

	def get_definition
		@defs = Wordnik.word.get_definitions(params['word'])
		wordTaken = Word.where(user_id: current_user, name: params['word']).present?

		if @defs.empty?
			render json: { "error" => 'I don\'t think this is a real word...' }.to_json
		elsif wordTaken
			render json: { "notice" => 'You already have this word in your list' }.to_json
		elsif @defs 
			render json: @defs
		end
		#@returnValues = @defs.map { |x| x['text'] }
		#render text: @returnValues

	end

end
