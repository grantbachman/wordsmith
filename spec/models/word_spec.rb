# == Schema Information
#
# Table name: words
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  user_id    :integer
#  deleted    :boolean
#

require 'spec_helper'

describe Word do

	let(:user) { FactoryGirl.create(:user) }	
	before(:each) { @word = user.words.build(name: "paradox") }
	
	subject { @word }
	
	it { should respond_to (:questions) }
	it { should respond_to(:name) }
	it { should respond_to(:definition)}
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }
	it { should be_valid }

	describe "when word is not present" do
		before { @word.name = ' ' }
		it { should_not be_valid }
	end

	describe "when user_id is not present" do
		before { @word.user_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
			Word.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

end

