require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe "Courses", type: :request do
  include_context "with authenticated requests"
  let(:student) { create(:user) }
  let(:teacher) { create(:user, :teacher) }
  let!(:course) { create(:course) }

  describe "GET /api/courses" do
    it "returns the Course as JSON for students" do
      authenticate(student)

      get "/api/courses/#{course.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(course.to_json)
    end
  end

  describe "GET /api/courses/visible" do
    it "returns the Courses that the student is enrolled in as JSON" do
      authenticate(student)

      # ensure arbitrary courses are not being returned
      get "/api/courses/visible"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to eq([])

      # enroll the student
      course.students << student

      # ensure courses are being returned
      get "/api/courses/visible"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed.size).to eq(1)
      c = parsed[0]
      expect(c['id']).to eq(course.id)
      expect(c['course_code']).to eq(course.course_code)
      expect(c['title']).to eq(course.title)
      expect(c['description']).to eq(course.description)
      expect(c['teacher_id']).to eq(course.teacher_id)
    end

    it "returns the Courses that the teacher teaches as JSON" do
      authenticate(teacher)

      # ensure arbitrary courses are not being returned
      get "/api/courses/visible"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to eq([])

      # enroll the student
      course.teacher = teacher
      course.save

      # ensure courses are being returned
      get "/api/courses/visible"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed.size).to eq(1)
      c = parsed[0]
      expect(c['id']).to eq(course.id)
      expect(c['course_code']).to eq(course.course_code)
      expect(c['title']).to eq(course.title)
      expect(c['description']).to eq(course.description)
      expect(c['teacher_id']).to eq(course.teacher_id)
    end
  end
end
