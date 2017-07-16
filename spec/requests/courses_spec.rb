require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe "Courses", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let!(:course) { create(:course) }
  let(:default_params) do
    {
      "/api/courses" => {
        "course_code" => "CS348",
        "title" => "Introduction to Databases",
        "description" => "This course introduces students to databases",
      }
    }
  end
  let(:course_properties) do
    {
      "id" => course.id,
      "course_code" => course.course_code,
      "title" => course.title,
      "description" => course.description,
      "teacher_id" => course.teacher_id,
    }
  end

  context "when a teacher is authenticated" do
    before { authenticate(teacher) }

    describe "POST /api/courses" do
      let(:params) { default_params["/api/courses"] }
      let(:expected_properties) do
        {
          "course_code" => params["course_code"],
          "title" => params["title"],
          "description" => params["description"],
          "teacher_id" => teacher.id,
        }
      end

      it "creates a course" do
        post "/api/courses", params: params

        expect(response).to be_created
        expect(json_response).to include(expected_properties)
      end
    end

    describe "GET /api/courses/visible" do
      it "returns no courses when the teacher is not teaching" do
        get "/api/courses/visible"
        expect(response).to be_ok
        expect(json_response).to eq([])
      end

      context "when the teacher teaches the course" do
        let(:course) { create(:course, teacher: teacher) }

        it "returns those Courses that the teacher teaches as JSON" do
          get "/api/courses/visible"
          expect(response).to be_ok
          expect(json_response.size).to eq(1)
          expect(json_response.first).to include(course_properties)
        end
      end
    end

    describe "GET /api/courses/:id/students" do
      let(:course) { create(:course, students: [student]) }

      it "returns the students enrolled in the class" do
        get "/api/courses/#{course.id}/students"
        expect(response).to be_ok
        expect(json_response.size).to eq(1)
        expect(json_response.first).to include(student.attributes.except("created_at", "updated_at"))
      end
    end
  end

  context "when a student is authenticated" do
    before { authenticate(student) }

    describe "POST /api/courses" do
      let(:params) { default_params["/api/courses"] }

      it "is inaccessible" do
        post "/api/courses"
        expect(response).to be_forbidden
      end
    end

    describe "GET /api/courses/visible" do
      it "returns no courses when the student is not enrolled in any" do
        get "/api/courses/visible"
        expect(response).to be_ok
        expect(json_response).to eq([])
      end

      context "when the student is enrolled in a course" do
        let(:course) { create(:course, students: [student]) }

        it "returns the Courses that the student is enrolled in" do
          get "/api/courses/visible"
          expect(response).to be_ok
          expect(json_response.size).to eq(1)
          expect(json_response.first).to include(course_properties)
        end
      end
    end

    describe "GET /api/courses/:id/students" do
      it "is inaccessible" do
        get "/api/courses/#{course.id}/students"
        expect(response).to be_forbidden
      end
    end
  end
end
