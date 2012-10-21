require 'spec_helper'

describe User do

	before do
		@user = User.new(email: "taken@example.com", password: "foobar",
										 password_confirmation: "foobar")
	end

	describe "User attributes" do
		before(:each) do
			@word = @user.words.build(name: "grant")
		end
		
		it "should respond to attributes" do
			@user.should respond_to(:words)
			@user.should respond_to(:quizzes)
		end

		it "should have a word" do
			@user.should have(1).word
		end

	end

end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  num_quiz_questions     :integer
#

