# == Schema Information
#
# Table name: quizzes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  auth_hash  :string(255)
#  answer_key :string(255)
#  difficulty :integer
#  word_bank  :string(255)
#  responded  :boolean
#

class Quiz < ActiveRecord::Base

	attr_accessible :answer_key, :difficulty, :responded
	before_create :generate_hash
	after_create :create_quiz_questions, :generate_word_bank, :match_answers

	belongs_to :user
	has_many :questions, dependent: :destroy

	validates :user_id, presence: true


		def generate_hash	
			self.auth_hash = SecureRandom.hex(32)
		end

		def match_answers
			return false if difficulty == 3

			questions.each do |question|
				question.answer.update_attributes(alpha_value: ((word_bank.split(',').index(question.word.name).to_i)+97).chr)
			end
		end

		def generate_word_bank
			word_bank = []

			unless difficulty == 3 then
				questions.each { |question| word_bank.push(question.word.name) }	
				if difficulty == 2 
					num_total_words = user.words.count
					num_extra_words = ((num_total_words - @num_questions) < @num_questions ? num_total_words - @num_questions : @num_questions)
					num_extra_words.times do
						begin
							word = user.words.sample
						end	while word.in?(word_bank)							
						word_bank.push(word.name)	
					end
				end
			end
			self.word_bank = word_bank.shuffle.join(',')
			# Does after_create hook occur before the object is saved? i.e. Do I need the 'save' in these methods?
			save
		end

		def create_quiz_questions
			choose_difficulty	

			word_bank = []	
			num_words = user.words.where(difficulty: difficulty).count
			@num_questions = (num_words < user.num_quiz_questions ? num_words : user.num_quiz_questions)

			@num_questions.times do |counter|
				begin
					word = user.words.where(difficulty: difficulty).sample
				end while word.in?(word_bank)
				word_bank.push(word)
				question = self.questions.create(number: counter+1, word_id: word.id)
				question.create_answer(full_value: question.word.name)
			end
			return self.questions.count
		end	

		def choose_difficulty
			diff_hash = { 1 => 0, 2 => 0, 3 => 0, 4 => 0 }
			user.words.each { |word| diff_hash[word.difficulty] += 1 }
			diff_hash[4] = 0 # I don't have a quiz for Level 4 difficulty...yet.
			self.update_attributes(difficulty: diff_hash.sort_by { |difficulty, num| num }.last[0])
		end


end
