FactoryGirl.define do
  factory :test do
    name { 'My Favourite Test' }

    association :db_file, factory: :test_db_file
  end
end
