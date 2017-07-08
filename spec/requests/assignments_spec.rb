require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "Assignments", type: :request do
  include_context "with authenticated requests"

  let(:student) { create(:student) }
  let(:course) { create(:course) }
  let!(:assignment) { create(:assignment, course_id: course.id) }

  before(:each) do
    authenticate(student)
    course.students << student
  end

  describe "GET /api/assignments/:id" do
    it "returns the Assignment as JSON" do
      get "/api/assignments/#{assignment.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(assignment.to_json)
    end
  end
end
