# == Schema Information
#
# Table name: answers
#
#  id          :integer         not null, primary key
#  question_id :integer
#  alpha_value :string(255)
#  full_value  :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  response    :string(255)
#  correct     :boolean
#

class Answer < ActiveRecord::Base
  attr_accessible :alpha_value, :full_value, :question_id

	belongs_to :question

end