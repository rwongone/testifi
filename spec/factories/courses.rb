FactoryGirl.define do
  factory :course do
    association :teacher, factory: [:user, :teacher], email: "somerandomemail@r.com", google_id: "google_id32948392482"
    course_code "SE 101"
    title "Introduction to Software Engineering"
    description "Taught by P.L. in the Fall of 2016."
  end
end
