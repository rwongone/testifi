require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "Problems", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }

  context "when a teacher is authenticated" do
    before(:each) do
      authenticate(teacher)
    end

    context "and the teacher teaches the course" do
      let(:course) { create(:course, teacher: teacher) }

      describe "GET /api/problems/:id" do
        it "returns the Problem as JSON" do
          get "/api/problems/#{problem.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(problem.to_json)
        end
      end

      describe "GET /api/assignments/:assignment_id/problems" do
        it "returns the all Problems of an Assignment as JSON" do
          get "/api/assignments/#{assignment.id}/problems"
          expect(response).to have_http_status(200)
          expect(response.body).to include(problem.to_json)
        end
      end
    end

    context "and the teacher does not teach the course" do
      let(:course) { create(:course) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}",
          "/api/assignments/#{assignment.id}/problems",
        ]
      end

      describe "restricted Problem endpoints" do
        it "are inaccessible" do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end
        end
      end
    end
  end


  context "when a student is authenticated" do
    before(:each) do
      authenticate(student)
    end

    context "and the student is enrolled" do
      let(:course) { create(:course, students: [student]) }

      describe "GET /api/problems/:id" do
        it "returns the Problem as JSON" do
          get "/api/problems/#{problem.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(problem.to_json)
        end
      end

      describe "GET /api/assignments/:assignment_id/problems" do
        it "returns the all Problems of an Assignment as JSON" do
          get "/api/assignments/#{assignment.id}/problems"
          expect(response).to have_http_status(200)
          expect(response.body).to include(problem.to_json)
        end
      end
    end # student is enrolled

    context "and the student is not enrolled" do
      let(:course) { create(:course) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}",
          "/api/assignments/#{assignment.id}/problems",
        ]
      end

      describe "restricted Problem endpoints" do
        it "are inaccessible" do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end
        end
      end
    end
  end
end
