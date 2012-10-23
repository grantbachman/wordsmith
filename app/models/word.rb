# == Schema Information
#
# Table name: words
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  user_id    :integer
#  deleted    :boolean
#  level      :integer
#  difficulty :integer
#

class Word < ActiveRecord::Base

  	attr_accessible :name, :definition, :deleted
  	default_scope where(deleted: false)
	
	belongs_to :user
	has_many :questions
	has_many :definitions, :dependent => :destroy

	validates :user_id, presence: true
	validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }

	def increment_level(quiz_id)
		# if they are responding to past quizzes, it shouldn't affect the word's levels
		unless self.difficulty > Quiz.find(quiz_id).difficulty then 
			if self.level == 3
				self.difficulty += 1
				self.level = 1
			else
				self.level += 1
			end
		end
	end	

	def decrement_level(quiz_id)
		# if they are responding to past quizzes, it shouldn't affect the word's levels
		self.level = 1 unless self.difficulty > Quiz.find(quiz_id).difficulty
	end

end
