FactoryGirl.define do
  factory :execution do
    passed { true }
    sequence(:output) { |n| "random output #{n}" }
    association :submission, factory: :submission
    association :test, factory: :test
  end
end
