# == Schema Information
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  quiz_id    :integer
#  word_id    :integer
#  type       :string(255)
#  answer     :string(255)
#  correct    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Question < ActiveRecord::Base

	# Allow access to :word_id and :quiz_id so that a question can belong to both words and quizzes
	attr_accessible :answer, :correct, :type, :word_id, :quiz_id

	belongs_to :word
	belongs_to :quiz

	validates :quiz_id, presence: true
	validates :word_id, presence: true
	validates :type, presence: true


end
