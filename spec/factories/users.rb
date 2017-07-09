FactoryGirl.define do
  factory :user, aliases: [:student] do
    name { 'Larry Learner' }
    email { 'larry@downtolearn.com' }
    google_id { 'google_id123' }
    admin { false }
  end

  factory :teacher, class: User do
    name { 'P B' }
    email { 'pb@teacher.com' }
    google_id { 't_google_id123' }
    admin { true }
  end

  trait :github do
    github_id { 'github_id123' }
  end
end
