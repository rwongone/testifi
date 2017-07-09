require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "Assignments", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let!(:assignment) { create(:assignment, course_id: course.id) }

  context "when a teacher is authenticated" do
    before(:each) do
      authenticate(teacher)
    end

    context "and the teacher teaches the course" do
      let(:course) { create(:course, teacher: teacher) }

      describe "GET /api/courses/:course_id/assignments" do
        it "returns all assignments in a course as JSON" do
          get "/api/courses/#{course.id}/assignments"
          expect(response).to have_http_status(200)
          expect(response.body).to include(assignment.to_json)
        end
      end

      describe "GET /api/assignments/:id" do
        it "returns the Assignment as JSON" do
          get "/api/assignments/#{assignment.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(assignment.to_json)
        end
      end
    end # teacher teaches course

    context "and the teacher does not teach the course" do
      let(:course) { create(:course) }
      let(:restricted_get_endpoints) do
        [
          "/api/assignments/#{assignment.id}",
        ]
      end

      describe "GET /api/courses/:course_id/assignments" do
        it "returns all assignments in a course as JSON" do
          get "/api/courses/#{course.id}/assignments"
          expect(response).to have_http_status(200)
          expect(response.body).to include(assignment.to_json)
        end
      end

      # TODO(rwongone): Would we want teachers not to be able to look
      # at assignments that don't belong to their courses?
      describe "restricted Assignment endpoints" do
        it "are inaccessible" do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end
        end
      end
    end # teacher does not teach course
  end

  context "when a student is authenticated" do
    before(:each) do
      authenticate(student)
    end

    context "and the student is enrolled" do
      let(:course) { create(:course, students: [student]) }

      describe "GET /api/courses/:course_id/assignments" do
        it "returns all assignments in a course as JSON" do
          get "/api/courses/#{course.id}/assignments"
          expect(response).to have_http_status(200)
          expect(response.body).to include(assignment.to_json)
        end
      end

      describe "GET /api/assignments/:id" do
        context "when the student is enrolled" do
          it "returns the Assignment as JSON" do
            get "/api/assignments/#{assignment.id}"
            expect(response).to have_http_status(200)
            expect(response.body).to eq(assignment.to_json)
          end
        end
      end
    end # enrolled

    context "and the student is not enrolled" do
      let(:course) { create(:course, students: []) }
      let(:restricted_get_endpoints) do
        [
          "/api/assignments/#{assignment.id}",
        ]
      end

      # TODO(rwongone): Require enrollment for a student to view assignments?
      describe "GET /api/courses/:course_id/assignments" do
        it "returns all assignments in a course as JSON" do
          get "/api/courses/#{course.id}/assignments"
          expect(response).to have_http_status(200)
          expect(response.body).to include(assignment.to_json)
        end
      end

      describe "restricted Assignment endpoints" do
        it "are inaccessible" do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end
        end
      end
    end # not enrolled
  end

  describe "POST /api/courses/:id/assignments" do
    it "allows teachers to post assignments" do
      authenticate(teacher)

      params = {
        "name" => "Assignment 1",
        "description" => "This course introduces students to databases"
      }

      post "/api/courses/#{course.id}/assignments", params: params, headers: headers
      expect(response).to have_http_status(201)
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed).to include(
        "name" => params["name"],
        "description" => params["description"],
        "course_id" => course.id
      )
    end
  end
end
