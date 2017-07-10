FactoryGirl.define do
  factory :submission do
    language { :java }

    association :db_file, factory: :submission_db_file
  end
end
