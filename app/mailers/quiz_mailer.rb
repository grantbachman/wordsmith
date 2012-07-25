class QuizMailer < ActionMailer::Base
  default from: "grantbachman@getwordsmith.com"

	def welcome_email(user)
		mail(to: user.email, subject: "Welcome to Wordsmith!")
	end

	def quiz_email(user)
		words_array = Array.new
		@quiz_hash = Hash.new 

		user.words.each do |word|
			words_array.push(word.name)
		end

		if words_array.length > 5
			5.times do
				begin
					word = words_array.sample
				end while @quiz_hash[word]
				definition = Wordnik.word.get_definitions(word)[0]['text']
				@quiz_hash[word] = definition
			end
			mail(to: user.email, subject: "Your quiz, sir.")
		end
	end
end
