class Definition < ActiveRecord::Base
  attr_accessible :text, :word_id

	belongs_to :word
	
	validates :word_id, presence: true
	validates :text, presence: true
end
