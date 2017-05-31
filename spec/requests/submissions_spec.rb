require 'rails_helper'
require 'rspec/json_expectations'

RSpec.describe "Submissions", type: :request do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let(:problem) { create(:problem, assignment_id: assignment.id) }
  let!(:submission) { create(:submission, user_id: user.id, problem_id: problem.id) }
  let(:headers) { {} }
  let(:auth_header) { {'HTTP_AUTHORIZATION': 'Bearer X'} }

  before do
    allow(Auth).to receive(:decode).and_return({ 'user_id' => user.id })
  end

  describe "GET /submissions" do
    let!(:submission2) { create(:submission, user_id: user.id, problem_id: problem.id) }
    it "returns a list of all Submissions" do
      get "/submissions", headers: headers.merge(auth_header)
      expect(response).to have_http_status(200)
      expect(response.body).to eq([submission, submission2].to_json)
    end
  end

  describe "GET /submissions/:id" do
    it "returns the Submission as JSON" do
      get "/submissions/#{submission.id}", headers: headers.merge(auth_header)
      expect(response).to have_http_status(200)
      expect(response.body).to eq(submission.to_json)
    end
  end

  describe "POST /submissions" do
    let (:params) do
      {
        user_id: user.id,
        problem_id: problem.id,
        language: 'cpp',
        filepath: 'var/submission/solution.cpp',
      }
    end

    it "creates a Submission with the right attributes" do
      post "/submissions", params: params, headers: headers.merge(auth_header)
      expect(response).to have_http_status(201)
      expect(response.body).to include_json(**params)
    end
  end

  describe "POST /submissions/exec" do
    let(:params) do
      {
        id: submission.id,
      }
    end

    it "synchronously executes the test case and returns the result" do
      post "/exec", params: params, headers: headers.merge(auth_header)
      File.open('spec_output', 'w') { |f| f.write(response.body) }
      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        result: /.*/,
      )
    end
  end
end
