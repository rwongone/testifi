require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'

RSpec.describe "Submissions", type: :request do
  include_context "with authenticated requests"

  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let(:problem) { create(:problem, assignment_id: assignment.id) }
  let!(:submission) { create(:submission, user_id: user.id, problem_id: problem.id) }

  describe "GET /api/submissions" do
    let!(:submission2) { create(:submission, user_id: user.id, problem_id: problem.id) }
    it "returns a list of all Submissions" do
      get "/api/submissions"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([submission, submission2].to_json)
    end
  end

  describe "GET /api/submissions/:id" do
    it "returns the Submission as JSON" do
      get "/api/submissions/#{submission.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(submission.to_json)
    end
  end

  describe "POST /api/submissions" do
    let (:params) do
      {
        user_id: user.id,
        problem_id: problem.id,
        language: 'cpp',
        filepath: 'var/submission/solution.cpp',
      }
    end

    it "creates a Submission with the right attributes" do
      post "/api/submissions", params: params
      expect(response).to have_http_status(201)
      expect(response.body).to include_json(**params)
    end
  end

  describe "POST /api/exec" do
    let(:params) do
      {
        id: submission.id,
      }
    end

    it "synchronously executes the test case and returns the result" do
      post "/api/exec", params: params
      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        result: /.*/,
      )
    end
  end
end
