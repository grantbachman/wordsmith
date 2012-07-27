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

require 'spec_helper'

describe Quiz do

	let(:user) { FactoryGirl.create(:user) } 
	before(:each) { @quiz = user.quizzes.build() }

	subject { @quiz } 

	it { should respond_to(:user) }
	it { should respond_to(:user_id) }
	it { should respond_to(:auth_hash) }
	its(:user) { should == user }
	it { should be_valid }

	describe "When user_id is not present" do
		before(:each) { @quiz.user_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
			Quiz.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
