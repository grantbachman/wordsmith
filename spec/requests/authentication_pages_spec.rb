require 'spec_helper'

describe "Authentication" do

	#subject { page }  # Why is 'it' an undefined method? Nothing on the internet about it. At all. Compared it to sample_app which works fine. Nothing different. Hours wasted: 2.5. Fuck. This. Shit.

		describe "links when logged out" do

			before { visit root_path }

			it "should have correct links" do
			 	#it { should have_link('Log in', href: new_user_session_path) }
			 	page.should have_link('Log in', href: new_user_session_path)
				page.should have_link('Sign up', href: new_user_registration_path)
			end
		end
		
		describe "links when logged in" do

			let(:user) { FactoryGirl.create(:user) }

			it "should have correct links" do
				login(user)
				page.should have_link('Log out', href: destroy_user_session_path)
			end		
		end

	describe "signup" do

		before { visit new_user_registration_path }

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
			visit new_user_session_path	
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

	describe "correct roots" do

		let(:user) { FactoryGirl.create(:user) }
	
		it "should root to static_pages#index when not logged in" do
			get root_path
			response.should render_template('static_pages/index')
		end

		it "should root to words#new when logged in" do
			login(user) # function in spec/support/utilities.rb 
			get root_path
			response.should render_template('words/new')
		end
	end

end
