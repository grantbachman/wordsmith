class WordsController < ApplicationController
	before_filter :authenticate_user!

	def show
		@word = current_user.words.find_by_id(params[:id])
	end

	def index
		@words = Word.where(user_id: current_user)
		@word = current_user.words.new
		@defs = Array.new
	end

	def new
		@words = Word.where(user_id: current_user)
		@word = current_user.words.new
		@defs = Array.new
	end

	def create
		@words = Word.where(user_id: current_user)

		deleted = Word.where(user_id: current_user, deleted: true)
		alreadyDeleted = deleted.select { |word| word.name == params['word_name'] }
		unless alreadyDeleted.blank?
			word = alreadyDeleted[0]
			word.deleted = false
			word.save
			if save_definitions(word.id)	
				respond_to do |format|
					format.js { render action: "success" }
				end
			end
		else
			@word = current_user.words.build
			@word.name = params['word_name']
			@word.name.downcase!
			if @word.save!
				if save_definitions(@word.id)	
					respond_to do |format|
						format.js { render action: "success" }
					end
				else
					respond_to do |format|
						format.js { render action: "failure" }
					end
				end
			#QuizMailer.quiz_email(current_user).deliver
			else
				respond_to do |format|
					format.js { render action: "failure" }
				end
			end
		end
	end

	def edit
		@word = current_user.words.find_by_id(params[:id])
		@defs = Wordnik.word.get_definitions(@word.name) 
		@myDefs = @word.definitions.map { |x| x.text }
	end

	def update
		@word = current_user.words.find_by_id(params[:id])
		if params['word_definition'].blank?
			flash[:error] = "A word must have at least one definition." 
			redirect_to edit_word_path(@word.id)
		else
			#@word.definitions.destroy_all	
			#params['word_definition'].each do |definition|
			#	@word.definitions.create(text: definition)
			#end
			#if @word.save
			if save_definitions(@word.id)
				flash[:success] = "'#{@word.name}' has been updated."
				redirect_to word_path(@word.id)
			end
		end

		#@@word = Word.find_by_id(params['word_id'])
		#@word.update_attributes(definition: params['word_definition'])
	end

	def destroy
		@word = current_user.words.find_by_id(params[:id])
		@word.update_attributes(deleted: true)
		flash[:success] = "Word deleted."
		redirect_to words_path
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

	private
		def save_definitions(word_id)
			word = current_user.words.find_by_id(word_id)
			word.definitions.destroy_all
			params['word_definition'].each do |definition|
				word.definitions.create(text: definition)
			end
			return word.save
		end	


end
