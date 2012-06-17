require 'spec_helper'

describe "AuthorizationPages" do
	
	describe "links" do
		before { visit root_path }
		
		it "should have correct links" do
			page.should have_link('Log in', href: login_path)
		end
	end

	describe "signup" do

		before { visit register_path }

		it "should not register users with invalid info" do
			fill_in "Email",											:with => "blah.com"
			fill_in "Password", 									:with => "short"
			fill_in "user_password_confirmation", :with => "short" # Why won't "Again" work?
			expect { click_button "Sign up" }.not_to change(User, :count)
			page.should have_selector('div#error_explanation') # because Devise handles registration errors different from session errors...why?
		end

		it "should register users with valid info" do
			fill_in "Email",											:with => "example@example.com"
			fill_in "Password", 									:with => "foobar"
			fill_in "user_password_confirmation",	:with => "foobar" # Why won't "Again" work?
			expect { click_button "Sign up" }.to change(User, :count).by(1)
		end
	end

	describe "login" do
		
		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			visit login_path	
		end

		it "should not login users with invalid data" do
			click_button "Log in"
			page.should have_selector('div.alert.alert-alert')
		end

		it "should login users with valid data" do
			fill_in "Email", 		with: user.email
			fill_in "Password", with: user.password
			click_button "Log in"
			page.should have_content("Signed in successfully")
		end
	
	end

end
