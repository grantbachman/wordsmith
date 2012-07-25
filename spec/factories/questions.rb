# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
  	user
  	quiz
    type ""
    answer "MyString"
    correct false
  end
end
