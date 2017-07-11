require 'helpers/api_helper'
require 'helpers/rails_helper'
require 'rspec/json_expectations'

RSpec.describe "Tests", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher_id: teacher.id) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/input.txt") }
  let(:db_file) { create(:test_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read) }
  let!(:test) { create(:test, user_id: teacher.id, problem_id: problem.id, db_file_id: db_file.id) }

  context "when a teacher is authenticated" do
    before(:each) do
      authenticate(teacher)
    end

    let(:test_params) do
      {
        user_id: teacher.id,
        problem_id: problem.id,
        file: uploaded_file,
      }
    end

    context "and the teacher made the course" do
      describe "GET /api/problems/:problem_id/tests" do
        let!(:test2) { create(:test, user_id: teacher.id, problem_id: problem.id, db_file_id: db_file.id) }
        it "returns a list of all of teachers's Tests for a Problem" do
          get "/api/problems/#{problem.id}/tests"
          expect(response).to have_http_status(200)
          expect(response.body).to eq([test, test2].to_json)
        end
      end

      describe "GET /api/test/:id" do
        it "returns the test as JSON" do
          get "/api/tests/#{test.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(test.to_json)
        end
      end

      describe "POST /api/problems/:problem_id/tests" do
        let(:expected_properties) do
          {
            user_id: teacher.id,
            problem_id: problem.id,
          }
        end

        it "creates a Test with the right attributes" do
          post "/api/problems/#{problem.id}/tests", params: test_params
          expect(response).to have_http_status(201)
          expect(response.body).to include_json(**expected_properties)
        end
      end
    end

    context "and the teacher did not create the course" do
      let(:teacher2) { create(:teacher) }
      let(:course) { create(:course, teacher_id: teacher2.id) }
      let(:test) { create(:test, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}/tests",
        ]
      end
      let(:restricted_post_endpoints) do
        {
          "/api/problems/#{problem.id}/tests" => test_params,
        }
      end

      describe "restricted Test endpoints" do
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