require 'rails_helper'

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
    it "returns the Submission as JSON" do
      get "/submissions/#{submission.id}", headers: headers.merge(auth_header)
      expect(response).to have_http_status(200)
      expect(response.body).to eq(submission.to_json)
    end
  end
end
