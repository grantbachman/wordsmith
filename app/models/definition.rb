class Definition < ActiveRecord::Base
  attr_accessible :text, :word_id

	belongs_to :word
	
	validates :word_id, presence: true
	validates :text, presence: true
end
# == Schema Information
#
# Table name: definitions
#
#  id         :integer         not null, primary key
#  word_id    :integer
#  text       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

