require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'

RSpec.describe "Executions", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:db_file) { create(:submission_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read, content_type: 'text/plain') }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }
  let(:uploaded_test_file) { fixture_file_upload("#{fixture_path}/files/input.txt") }
  let(:db_test_file) { create(:test_db_file, name: uploaded_test_file.original_filename, contents: uploaded_test_file.read, content_type: 'text/plain') }
  let!(:test) { create(:test, user_id: teacher.id, problem_id: problem.id, db_file_id: db_test_file.id, expected_output: "1\n") }
  let!(:test2) { create(:test, user_id: teacher.id, problem_id: problem.id, db_file_id: db_test_file.id, expected_output: "1\n", hint: "Test hint") }

  let!(:execution) { create(:execution, submission_id: submission.id, test_id: test.id, passed: true) }
  let!(:execution2) { create(:execution, submission_id: submission.id, test_id: test2.id, passed: false) }

  before(:each) do
    authenticate(student)
  end

  describe "GET /api/submissions/:submission_id/results" do
    it "should return the number of correct executions" do
      get "/api/submissions/#{submission.id}/results"
      expect(response).to have_http_status(200)
      expect(response.body).to eq({total_tests: 2, num_passed: 1, failed_test_hints: [test2.hint]}.to_json)
    end
  end

end
