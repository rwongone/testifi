FactoryGirl.define do
  factory :execution do
    sequence(:output) { |n| "random output #{n}" }
    association :submission, factory: :submission
    association :test, factory: :test
  end
end
