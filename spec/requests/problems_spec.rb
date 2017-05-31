require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "Problems", type: :request do
  include_context "with authenticated requests"

  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let(:problem) { create(:problem, assignment_id: assignment.id) }

  describe "GET /api/problems" do
    it "returns the Problem as JSON" do
      get "/api/problems/#{problem.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(problem.to_json)
    end
  end
end
