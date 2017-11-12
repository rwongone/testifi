# frozen_string_literal: true

require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'

RSpec.describe 'Submissions', type: :request do
  include ActiveJob::TestHelper
  include_context 'with authenticated requests'
  include_context 'with JSON responses'

  let(:student) { create(:student) }
  let(:other_student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:db_file) { create(:submission_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read, content_type: 'text/plain') }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }
  let!(:submission2) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }
  let!(:submission3) { create(:submission, user_id: other_student.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }

  context 'when a teacher is authenticated' do
    before(:each) do
      authenticate(teacher)
    end

    let(:submission_params) do
      {
        user_id: teacher.id,
        problem_id: problem.id,
        language: FileHelper.filename_to_language(uploaded_file.original_filename),
        file: uploaded_file
      }
    end

    context 'and the teacher teaches the course' do
      let(:course) { create(:course, teacher: teacher) }
      describe 'POST /api/problems/:problem_id/submissions' do
        subject do
          post "/api/problems/#{problem.id}/submissions", params: submission_params
        end
        let(:expected_properties) do
          {
            user_id: teacher.id,
            problem_id: problem.id,
            language: 'java'
          }
        end

        it 'creates a Submission with the right attributes' do
          expect { subject }.to enqueue_job(RunSubmissionsJob)
          expect(response).to have_http_status(201)
          expect(response.body).to include_json(**expected_properties)
        end

        it 'the Submission is actually the solution to the problem' do
          expect(problem.solution_id).to be_nil
          subject
          expect(Problem.find(problem.id).solution_id).to eq(Submission.last.id)
        end
      end

      describe 'GET /api/problems/:problem_id/submissions' do
        subject do
          get "/api/problems/#{problem.id}/submissions"
        end

        it 'shows all Submissions for the Problem' do
          subject
          expect(response).to have_http_status(200)
          expect(response.body).to eq([submission, submission2, submission3].to_json)
        end
      end
    end

    context 'and the teacher does not teach the course' do
      let(:course) { create(:course) }
      let(:submission) { create(:submission, user_id: teacher.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}/submissions"
        ]
      end
      let(:restricted_post_endpoints) do
        {
          "/api/problems/#{problem.id}/submissions" => submission_params
        }
      end

      describe 'restricted Submission endpoints' do
        it 'are inaccessible' do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end

          restricted_post_endpoints.each do |endpoint, params|
            post endpoint, params: params
            expect(response).to be_forbidden
          end
        end
      end
    end
  end

  context 'when a student is authenticated' do
    before(:each) do
      authenticate(student)
    end

    let(:submission_params) do
      {
        user_id: student.id,
        problem_id: problem.id,
        language: FileHelper.filename_to_language(uploaded_file.original_filename),
        file: uploaded_file
      }
    end

    describe 'GET /api/submissions/:id/file' do
      it 'returns their own file' do
        get "/api/submissions/#{submission.id}/file"
        expect(response).to have_http_status(200)
        expect(response.header['Content-Type']).to eq(db_file.content_type)
        uploaded_file.rewind
        expect(response.body).to eq(uploaded_file.read)
      end

      it 'prevents access to files belonging to other students' do
        get "/api/submissions/#{submission3.id}/file"
        expect(response).to have_http_status(403)
      end
    end

    context 'and the student is enrolled' do
      let(:course) { create(:course, students: [student]) }

      describe 'GET /api/problems/:problem_id/submissions' do
        it "returns a list of all of user's Submissions for a Problem" do
          get "/api/problems/#{problem.id}/submissions"
          expect(response).to have_http_status(200)
          expect(response.body).to eq([submission, submission2].to_json)
        end
      end

      describe 'GET /api/submissions/:id' do
        it 'returns the Submission as JSON' do
          get "/api/submissions/#{submission.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(submission.to_json)
        end
      end

      describe 'GET /api/problems/:problem_id/submissions' do
        subject do
          get "/api/problems/#{problem.id}/submissions"
        end

        it "shows only the student's Submissions for the Problem" do
          subject
          expect(response).to have_http_status(200)
          expect(response.body).to eq([submission, submission2].to_json)
        end
      end

      describe 'POST /api/problems/:problem_id/submissions' do
        let(:expected_properties) do
          {
            user_id: student.id,
            problem_id: problem.id,
            language: 'java'
          }
        end

        it 'creates a Submission with the right attributes' do
          expect do
            post "/api/problems/#{problem.id}/submissions", params: submission_params
          end.to enqueue_job(RunSubmissionsJob)
          expect(response).to have_http_status(201)
          expect(response.body).to include_json(**expected_properties)
        end
      end

      describe 'POST /api/exec' do
        it 'synchronously executes the test case and returns the result' do
          post "/api/problems/#{problem.id}/submissions", params: submission_params
          post '/api/exec', params: { id: JSON.parse(response.body)['id'] }
          expect(response).to have_http_status(200)
          expect(response.body).to include_json(
            result: /.*/
          )
        end
      end
    end

    context 'and the student is not enrolled' do
      let(:course) { create(:course) }
      let(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}/submissions"
        ]
      end
      let(:restricted_post_endpoints) do
        {
          "/api/problems/#{problem.id}/submissions" => submission_params
        }
      end

      describe 'restricted Submission endpoints' do
        it 'are inaccessible' do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end

          restricted_post_endpoints.each do |endpoint, params|
            post endpoint, params: params
            expect(response).to be_forbidden
          end
        end
      end
    end
  end
end
