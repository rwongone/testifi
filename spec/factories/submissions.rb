FactoryGirl.define do
  factory :submission do
    language { :cpp }
    filepath { 'var/submission/solution.cpp' }
  end
end
