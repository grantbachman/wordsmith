# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    question_id 1
    alpha_value "MyString"
    full_value "MyString"
  end
end
