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

require 'spec_helper'

describe Question do

	let(:word) { FactoryGirl.create(:word) }
	let(:quiz) { FactoryGirl.create(:quiz) }


	before(:each) do
		@question = quiz.questions.build(number: 1, style: "matching", word_id: word)
	end

	subject { @question }

	it { should respond_to(:quiz) }
	it { should respond_to(:number) }
	it { should respond_to(:word) }
	it { should respond_to(:style) }
	it { should respond_to(:response) }
	it { should respond_to(:correct) }
	its(:quiz) { should == quiz }
	it { should be_valid }

	describe "when number is not present" do
		before(:each) { @question.number = nil }
		it { should_not be_valid }
	end

	describe "when style is not present" do
		before(:each) { @question.style = nil }
		it { should_not be_valid }
	end

	describe "when word_id is not present" do
		before(:each) { @question.word_id = nil }
		it { should_not be_valid }
	end

	describe "when quiz_id is not present" do
		before(:each) { @question.quiz_id = nil }
		it { should_not be_valid }
	end

end
