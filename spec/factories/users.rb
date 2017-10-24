# frozen_string_literal: true

FactoryGirl.define do
  factory :user, aliases: [:student] do
    name { 'Larry Learner' }
    sequence(:email) { |n| "larry#{n}@downtolearn.com" }
    sequence(:google_id) { |n| "google_id#{n}" }
    admin { false }
  end

  factory :teacher, class: User do
    name { 'P B' }
    sequence(:email) { |n| "pb#{n}@teacher.com" }
    sequence(:google_id) { |n| "t_google_id#{n}" }
    admin { true }
  end

  trait :github do
    sequence(:github_id) { |n| "github_id#{n}" }
  end
end
