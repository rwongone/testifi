require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'

RSpec.describe "Submissions", type: :request do
  include_context "with authenticated requests"

  let(:student) { create(:student) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id) }

  before(:each) do
    authenticate(student)
    course.students << student
  end

  describe "GET /api/problems/:problem_id/submissions" do
    let!(:submission2) { create(:submission, user_id: student.id, problem_id: problem.id) }
    it "returns a list of all of user's Submissions for a Problem" do
      get "/api/problems/#{problem.id}/submissions"
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

  describe "POST /api/problems/:problem_id/submissions" do
    let (:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
    let (:params) do
      {
        user_id: student.id,
        problem_id: problem.id,
        language: 'java',
        file: uploaded_file,
      }
    end
    let (:expected_properties) do
      {
        user_id: student.id,
        problem_id: problem.id,
        language: 'java',
        filename: 'Solution.java',
      }
    end

    it "creates a Submission with the right attributes" do
      post "/api/problems/#{problem.id}/submissions", params: params
      expect(response).to have_http_status(201)
      expect(response.body).to include_json(**expected_properties)
    end
  end

  describe "POST /api/exec" do
    let (:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
    let (:submission_params) do
      {
        user_id: student.id,
        problem_id: problem.id,
        language: 'java',
        file: uploaded_file,
      }
    end

    it "synchronously executes the test case and returns the result" do
      post "/api/problems/#{problem.id}/submissions", params: submission_params
      post "/api/exec", params: { id: JSON.parse(response.body)['id'] }

      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        result: /.*/,
      )
    end
  end
end
