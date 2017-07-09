require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe "Courses", type: :request do
  include_context "with authenticated requests"
  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let!(:course) { create(:course) }

  describe "POST /api/courses" do
    it_behaves_like "an admin-only POST endpoint", "/api/courses"

    it "allows teachers to create a course" do
      authenticate(teacher)

      params = {
        "course_code" => "CS348",
        "title" => "Introduction to Databases",
        "description" => "This course introduces students to databases"
      }

      post "/api/courses", params: params, headers: headers
      expect(response).to have_http_status(201)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to include(
        "course_code" => params["course_code"],
        "title" => params["title"],
        "description" => params["description"],
        "teacher_id" => teacher.id
      )
    end
  end

  describe "GET /api/courses" do
    it "returns the Course as JSON for students" do
      authenticate(student)

      get "/api/courses/#{course.id}"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      validate_course(parsed, course)
    end
  end

  describe "GET /api/courses/visible" do
    it "returns no courses when a student is not enrolled" do
      authenticate(student)

      get "/api/courses/visible"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to eq([])
    end

    context "when a student is enrolled in courses" do
      let(:course) { create(:course, students: [student]) }

      it "returns those Courses that the student is enrolled in as JSON" do
        authenticate(student)

        get "/api/courses/visible"
        expect(response).to have_http_status(200)
        parsed = ActiveSupport::JSON.decode(response.body)
        expect(parsed.size).to eq(1)
        validate_course(parsed[0], course)
      end
    end


    it "returns no courses when the teacher is not teaching" do
      authenticate(teacher)

      get "/api/courses/visible"
      expect(response).to have_http_status(200)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to eq([])
    end

    context "when the teacher teaches the course" do
      let(:course) { create(:course, teacher: teacher) }

      it "returns those Courses that the teacher teaches as JSON" do
        authenticate(teacher)

        get "/api/courses/visible"
        expect(response).to have_http_status(200)
        parsed = ActiveSupport::JSON.decode(response.body)
        expect(parsed.size).to eq(1)
        validate_course(parsed[0], course)
      end
    end
  end

  def validate_course(actual, expected)
    expect(actual).to include(
      "id" => expected.id,
      "course_code" => expected.course_code,
      "title" => expected.title,
      "description" => expected.description,
      "teacher_id" => expected.teacher_id
    )
  end
end
