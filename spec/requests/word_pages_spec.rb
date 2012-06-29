require 'spec_helper'

describe "Word Pages" do

	let(:user) { FactoryGirl.create(:user) }
	before(:each) { login(user) }

	it "should add a word" do
		fill_in "word_name", with: "paradox"
		click_button "Add"
		page.should have_content("Word added")
	end		

	it "should show all words in their list" do
		
	end
end
