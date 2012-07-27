class QuizMailer < ActionMailer::Base
  default from: "grantbachman@getwordsmith.com"

	def welcome_email(user)
		mail(to: user.email, subject: "Welcome to Wordsmith!")
	end

	def quiz_email(user)
		@quiz = user.quizzes.create

		#better way to write this?
		user_words = user.words.length
		num_questions = (user_words < 5 ? user_words : 5)

		@words_array = Array.new
		@defs_array = Array.new

		num_questions.times do
			begin
				word = user.words.sample
			end while @words_array.include?(word.name)
			@words_array.push(word.name)
			@quiz.questions.create(word_id: word.id, style: "matching")
		end


		@words_array.each do |word|
			@defs_array.push(Wordnik.word.get_definitions(word)[0]['text'])
		end

		@quiz.update_attributes(answer_key: @words_array.join(","))

		@words_array.shuffle!

		mail(to: user.email, subject: "Your quiz has arrived.")

		# put the above logic in the quiz model	



		#words_array = Array.new
		#@quiz_hash = Hash.new 

		#user.words.each do |word|
		#	words_array.push(word.name)
		#end

		#if words_array.length > 5
		#	5.times do
		#		begin
		#			word = words_array.sample
		#		end while @quiz_hash[word]
		#		definition = Wordnik.word.get_definitions(word)[0]['text']
		#		@quiz_hash[word] = definition
		#	end
		#	mail(to: user.email, subject: "Your quiz, sir.")
		#end
	end
end
