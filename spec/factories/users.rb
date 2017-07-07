FactoryGirl.define do
  factory :user do
    name { 'Larry Learner' }
    email { 'larry@downtolearn.com' }
    google_id { '3432432kdfsfds324' }
    admin { false }
  end
end
