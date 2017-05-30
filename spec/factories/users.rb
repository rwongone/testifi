FactoryGirl.define do
  factory :user do
    name { "Larry Learner" }
    email { "larry@downtolearn.com" }
    password { '12345678' }
    admin { false }
  end
end
