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
#

class Quiz < ActiveRecord::Base

	attr_accessible :answer_key
	before_create :generate_hash

	belongs_to :user
	has_many :questions

	validates :user_id, presence: true


	private

		def generate_hash	
			self.auth_hash = SecureRandom.hex(32)
		end

end
