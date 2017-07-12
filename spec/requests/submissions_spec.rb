require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'
require 'mimemagic'

RSpec.describe "Submissions", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:db_file) { create(:submission_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read, content_type: 'text/plain') }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id) }

  # TODO(rwongone): Currently, we only check if a user is in a course's
  # list of enrolled students to decide whether the resource is accessible.
  # We will want to handle Submissions differently for teachers. How will
  # a teacher submit a canon solution?
  context "when a teacher is authenticated" do
    before(:each) do
      authenticate(teacher)
    end

    let(:submission_params) do
      {
        user_id: teacher.id,
        problem_id: problem.id,
        language: 'java',
        file: uploaded_file,
      }
    end
  end

  context "when a student is authenticated" do
    before(:each) do
      authenticate(student)
    end

    let(:submission_params) do
      {
        user_id: student.id,
        problem_id: problem.id,
        language: 'java',
        file: uploaded_file,
      }
    end

    context "and the student requests a file they own" do
      describe "GET /api/submissions/:id/file" do
        it "returns the file" do
          get "/api/submissions/#{submission.id}/file"
          expect(response).to have_http_status(200)
          expect(response.header['Content-Type']).to eq(db_file.content_type)
          uploaded_file.rewind
          expect(response.body).to eq(uploaded_file.read)
        end
      end
    end

    context "and the student requests a file they do not own" do
      describe "GET /api/submissions/:id/file" do
        let(:student2) { create(:student) }
        it "prevents access" do
          authenticate(student2)

          get "/api/submissions/#{submission.id}/file"
          expect(response).to have_http_status(403)
        end
      end
    end

    context "and the student is enrolled" do
      let(:course) { create(:course, students: [student]) }

      describe "GET /api/problems/:problem_id/submissions" do
        let!(:submission2) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id) }
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
        let(:expected_properties) do
          {
            user_id: student.id,
            problem_id: problem.id,
            language: 'java',
          }
        end

        it "creates a Submission with the right attributes" do
          post "/api/problems/#{problem.id}/submissions", params: submission_params
          expect(response).to have_http_status(201)
          expect(response.body).to include_json(**expected_properties)
        end
      end

      describe "POST /api/exec" do
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

    context "and the student is not enrolled" do
      let(:course) { create(:course) }
      let(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}/submissions",
        ]
      end
      let(:restricted_post_endpoints) do
        {
          "/api/problems/#{problem.id}/submissions" => submission_params,
        }
      end

      describe "restricted Submission endpoints" do
        it "are inaccessible" do
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
