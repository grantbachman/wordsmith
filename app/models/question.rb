# == Schema Information
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  quiz_id    :integer
#  word_id    :integer
#  style      :string(255)
#  response   :string(255)
#  correct    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  number     :integer
#

class Question < ActiveRecord::Base

	# Allow access to :word_id and :quiz_id so that a question can belong to both words and quizzes
	attr_accessible :number, :response, :correct, :style, :word_id, :quiz_id

	belongs_to :word
	belongs_to :quiz

	validates :number, presence: true
	validates :quiz_id, presence: true
	validates :word_id, presence: true
	validates :style, presence: true


end
