FactoryGirl.define do

	factory :user, class: User do
		email "grant@grantbachman.com"
		password "foobar"
		password_confirmation "foobar"
	end

end
