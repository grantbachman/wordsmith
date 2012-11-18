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
#  difficulty :integer
#  word_bank  :string(255)
#  responded  :boolean         default(FALSE)
#  score      :integer
#

require 'spec_helper'

describe Quiz do

	let(:user) { FactoryGirl.create(:user) } 

	before(:all) do
		#words = %w(grant david bachman paradox conquer hero drive)
		#words.each do |word|
		#	x = user.words.create(name: word)
		#	x.definitions.create(text: 'sample definition')
		#end
	end

	after(:all) do
		user.destroy
	end

	before(:all) do
	end

	before(:each) do
		user.words.build(name: "grant")
		@quiz = user.quizzes.create
	end

	describe "Quiz attributes" do

		it "should respond to attributes" do
			@quiz.should respond_to(:questions)
			@quiz.should respond_to(:user)
			@quiz.should respond_to(:user_id)
			@quiz.should respond_to(:auth_hash)
			@quiz.user.should == user
		end

		it "should have the right number of questions" do	
			#@quiz.should have(1).question
		end

	end

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
