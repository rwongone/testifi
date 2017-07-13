FactoryGirl.define do
  factory :course do
    association :teacher, factory: :teacher
    course_code "SE 101"
    title "Introduction to Software Engineering"
    description "Taught by P.L. in the Fall of 2016."
  end
end
