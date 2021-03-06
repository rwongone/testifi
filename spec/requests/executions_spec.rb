# frozen_string_literal: true

require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'

RSpec.describe 'Executions', type: :request do
  include_context 'with authenticated requests'
  include_context 'with JSON responses'

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
  let(:expected_output) { "1\n" }
  let!(:test) { create(:test, user: teacher, problem: problem, db_file_id: db_test_file.id, expected_output: expected_output, hint: 'IF YOU SEE THIS, SOMETHING IS WRONG') }
  let!(:test2) { create(:test, user: teacher, problem: problem, db_file_id: db_test_file.id, expected_output: expected_output, hint: 'the output was wrong') }
  let!(:test3) { create(:test, user: teacher, problem: problem, db_file_id: db_test_file.id, expected_output: expected_output, hint: 'there was an error') }

  let!(:execution) { create(:execution, submission: submission, test: test, output: expected_output, return_code: 0) }
  let!(:execution2) { create(:execution, submission: submission, test: test2, output: 'wrong_output', return_code: 0) }
  let!(:execution3) { create(:execution, submission: submission, test: test3, output: nil, std_error: 'compilation error', return_code: 1) }

  before(:each) do
    authenticate(student)
  end

  describe 'GET /api/submissions/:submission_id/results' do
    it 'should return the number of correct executions' do
      get "/api/submissions/#{submission.id}/results"
      expect(response).to have_http_status(200)
      expect(json_response).to include({
        total_tests: 3,
      }.with_indifferent_access)
      expect(json_response[:executions][0]).to include({
        output: execution.output,
        std_error: execution.std_error,
        return_code: execution.return_code,
        test_name: execution.test.name,
        status: 'passed',
        hint: test.hint,
      })
      expect(json_response[:executions][1]).to include({
        output: execution2.output,
        std_error: execution2.std_error,
        return_code: execution2.return_code,
        test_name: execution2.test.name,
        status: 'failed',
        hint: test2.hint,
      })
      expect(json_response[:executions][2]).to include({
        output: execution3.output,
        std_error: execution3.std_error,
        return_code: execution3.return_code,
        test_name: execution3.test.name,
        status: 'errored',
        hint: test3.hint,
      })
    end
  end
end
