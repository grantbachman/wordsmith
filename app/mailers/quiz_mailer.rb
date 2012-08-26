class QuizMailer < ActionMailer::Base
  default from: "grantbachman@wordsmith.mailgun.org"

	def welcome_email(user)
		mail(to: user.email, subject: "Welcome to Wordsmith!")
	end

	def quiz_email(user)

		@answer_key_array = Array.new
		@definitions_array = Array.new
		@shuffled_words_array = Array.new
		@quiz = user.quizzes.create

		num_user_words = user.words.length
		num_questions = (num_user_words < 7 ? num_user_words : 7)

		create_quiz_questions(user, num_questions)

		fetch_definitions
		
		@shuffled_words_array = @answer_key_array.shuffle

		add_alpha_indices

		@quiz.update_attributes(answer_key: @answer_key_array.join(","))

		mail(to: user.email, subject: "Quiz #{user.quizzes.count} has arrived.")
	end

	private

		def create_quiz_questions(user, num)
			num.times do |counter|
				begin
					word = user.words.sample
				end while @answer_key_array.include?(word.name)
				@answer_key_array.push(word.name)
				@quiz.questions.create(number: counter+1, word_id: word.id, style: "matching")
			end
		end

		def fetch_definitions
			@answer_key_array.each do |word|
				@definitions_array.push(Wordnik.word.get_definitions(word)[0]['text'])
			end
		end

		# appends the correct alphabetical answer to the answer key array
		# => before: ['jubilate', 'apostacy', 'bellwether', 'ubiquitous']
		# => after: ['jubilate:c', 'apostacy:a', 'bellwether:d', 'ubiquitous:b']
		def add_alpha_indices
			@shuffled_words_array.each_with_index do |word, index|
				alpha_index = (97+index).chr
				add_alpha_index(word, alpha_index)
			end
		end

		def add_alpha_index(word, alpha_index)
			index = @answer_key_array.index(word)
			@answer_key_array[index] = "#{word}:#{alpha_index}"
		end
end
