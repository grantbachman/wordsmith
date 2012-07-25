FactoryGirl.define do

	factory :user, class: User do
		sequence(:email) { |n| "user#{n}@factory.com" } 
		password "foobar"
		password_confirmation "foobar"
	end

end
