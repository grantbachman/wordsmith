# == Schema Information
#
# Table name: quizzes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Quiz < ActiveRecord::Base


  belongs_to :user
  has_many :questions

  validates :user_id, presence: true
end
