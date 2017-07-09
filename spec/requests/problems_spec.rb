require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "Problems", type: :request do
  include_context "with authenticated requests"

  let(:student) { create(:student) }
  let(:course) { create(:course, students: [student]) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }

  before(:each) do
    authenticate(student)
  end

  describe "GET /api/problems/:id" do
    it "returns the Problem as JSON" do
      get "/api/problems/#{problem.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(problem.to_json)
    end
  end

  describe "GET /api/assignments/:assignment_id/problems" do
    it "returns the all Problems of an Assignment as JSON" do
      get "/api/assignments/#{assignment.id}/problems"
      expect(response).to have_http_status(200)
      expect(response.body).to include(problem.to_json)
    end
  end
end
