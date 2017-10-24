# frozen_string_literal: true

FactoryGirl.define do
  factory :invite do
    transient do
      student { create(:student) }
      course { create(:course) }
      teacher { create(:teacher) }
    end

    email { student.email }
    course_id { course.id }
    inviter_id { teacher.id }
    redeemer { nil }
  end
end
