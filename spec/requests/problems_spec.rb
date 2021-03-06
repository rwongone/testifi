# frozen_string_literal: true

require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe 'Problems', type: :request do
  include_context 'with authenticated requests'
  include_context 'with JSON responses'

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:solution_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }

  context 'when a teacher is authenticated' do
    before(:each) do
      authenticate(teacher)
    end

    context 'and the teacher teaches the course' do
      let(:course) { create(:course, teacher: teacher) }

      describe 'GET /api/problems/:id' do
        it 'returns the Problem as JSON' do
          get "/api/problems/#{problem.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(problem.to_json)
        end
      end

      describe 'GET /api/assignments/:assignment_id/problems' do
        it 'returns the all Problems of an Assignment as JSON' do
          get "/api/assignments/#{assignment.id}/problems"
          expect(response).to have_http_status(200)
          expect(response.body).to include(problem.to_json)
        end
      end

      describe 'POST /api/assignments/:assignment_id/problems' do
        let(:problem_params) do
          {
            name: 'Sum array',
            description: 'Return the sum of an array of integers'
          }
        end

        it 'creates a problem' do
          post "/api/assignments/#{assignment.id}/problems", params: problem_params
          expect(response).to have_http_status(201)
          expect(response.body).to include_json(problem_params.merge(assignment_id: assignment.id))
        end

        let(:problem_params_with_file) do
          problem_params.merge(file: solution_file)
        end

        it 'creates a problem with a solution if a solution file is provided' do
          post "/api/assignments/#{assignment.id}/problems", params: problem_params_with_file
          expect(response).to have_http_status(201)
          expect(response.body).to include_json(problem_params.merge(assignment_id: assignment.id))
          solution_id = ActiveSupport::JSON.decode(response.body)['solution_id']
          problem_id = ActiveSupport::JSON.decode(response.body)['id']
          expect(Submission.find(solution_id).db_file.contents).to eq(solution_file.read)

          get "/api/problems/#{problem_id}/solution"
          expect(response).to have_http_status(200)
          solution_file.rewind
          expect(response.body).to eq(solution_file.read)
        end
      end

      describe 'GET /api/problems/:id/solution' do
        it 'returns the Solution as a file' do
        end
      end

    end

    context 'and the teacher does not teach the course' do
      let(:course) { create(:course) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}",
          "/api/assignments/#{assignment.id}/problems"
        ]
      end

      describe 'restricted Problem endpoints' do
        it 'are inaccessible' do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
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

    context 'and the student is enrolled' do
      let(:course) { create(:course, students: [student]) }

      describe 'GET /api/problems/:id' do
        it 'returns the Problem as JSON' do
          get "/api/problems/#{problem.id}"
          expect(response).to have_http_status(200)
          expect(response.body).to eq(problem.to_json)
        end
      end

      describe 'GET /api/assignments/:assignment_id/problems' do
        it 'returns the all Problems of an Assignment as JSON' do
          get "/api/assignments/#{assignment.id}/problems"
          expect(response).to have_http_status(200)
          expect(response.body).to include(problem.to_json)
        end
      end
    end # student is enrolled

    context 'and the student is not enrolled' do
      let(:course) { create(:course) }
      let(:restricted_get_endpoints) do
        [
          "/api/problems/#{problem.id}",
          "/api/assignments/#{assignment.id}/problems"
        ]
      end

      describe 'restricted Problem endpoints' do
        it 'are inaccessible' do
          restricted_get_endpoints.each do |endpoint|
            get endpoint
            expect(response).to be_forbidden
          end
        end
      end
    end
  end
end
