# == Schema Information
#
# Table name: words
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  user_id    :integer
#  definition :string(255)
#

class Word < ActiveRecord::Base

  	attr_accessible :name, :definition
	
	belongs_to :user
	has_many :questions, :dependent => :destroy
	has_many :definitions, :dependent => :destroy

	validates :user_id, presence: true
	validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
end
