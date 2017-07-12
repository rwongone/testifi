require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "DbFiles", type: :request do
  include_context "with authenticated requests"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher_id: teacher.id) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:student) { create(:student) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:db_file) { create(:submission_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read, content_type: 'text/plain') }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id, language: FileHelper.filename_to_language(uploaded_file.original_filename)) }

  context "when a teacher is authenticated" do
    before(:each) do
      authenticate(teacher)
    end

    context "and the teacher requests a file" do
      describe "GET /api/files/:id" do
        it "returns a text file" do
          get "/api/files/#{db_file.id}"
          expect(response).to have_http_status(200)
          expect(response.header['Content-Type']).to eq('text/plain')
          uploaded_file.rewind
          expect(response.body).to eq(uploaded_file.read)
        end
      end
    end

  end

  context "when a student is authenticated" do
    before(:each) do
      authenticate(student)
    end

    context "and the student requests a file" do
      describe "GET /api/files/:id" do
        it "prevents access" do
          get "/api/files/#{db_file.id}"
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
