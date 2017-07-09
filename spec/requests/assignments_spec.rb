require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "Assignments", type: :request do
  include_context "with authenticated requests"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, students: [student]) }

  before(:each) do
    authenticate(student)
  end

  # TODO(rwongone): Does anything different happen when a student is not
  # enrolled in the course? Should a similar restriction apply to teachers?

  describe "GET /api/courses/:course_id/assignments" do
    let!(:assignment) { create(:assignment, course_id: course.id) }
    it "returns all assignments in a course as JSON" do
      get "/api/courses/#{course.id}/assignments"
      expect(response).to have_http_status(200)
      expect(response.body).to include(assignment.to_json)
    end
  end

  describe "GET /api/assignments/:id" do
    let!(:assignment) { create(:assignment, course_id: course.id) }
    it "returns the Assignment as JSON" do
      get "/api/assignments/#{assignment.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(assignment.to_json)
    end
  end

  describe "POST /api/courses/:id/assignments" do
    it "allows teachers to post assignments" do
      authenticate(teacher)

      params = {
        "name" => "Assignment 1",
        "description" => "This course introduces students to databases"
      }

      post "/api/courses/#{course.id}/assignments", params: params, headers: headers
      expect(response).to have_http_status(201)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to include(
        "name" => params["name"],
        "description" => params["description"],
        "course_id" => course.id
      )
    end
  end
end
