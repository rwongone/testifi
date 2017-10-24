# frozen_string_literal: true

require './app/lib/test_executor.rb'
require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe TestExecutor do
  include ActionDispatch::TestProcess

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:assignment) { create(:assignment, course: course) }
  let!(:problem) { create(:problem, assignment: assignment) }
  let(:solution_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let!(:solution) { create(:submission, user: teacher, problem: problem, file: solution_file) }

  subject { described_class }

  describe '.create_testing_image' do
    # All expectations in one test, so we only actually create the image once.
    it 'creates a singleton Docker::Image for the Submission' do
      subject.instance_variable_set(:@images, {})
      expect(Docker::Image).to receive(:build_from_dir).once.and_call_original

      image = subject.create_testing_image(solution)
      subject.create_testing_image(solution)

      expect(image).to be_instance_of(Docker::Image)
      expect(subject.images[solution.language]).to eq(image)
    end
  end

  context 'when executing tests with an existing image' do
    let(:consec_3) { create(:consec, n: 3) }
    let(:consec_5) { create(:consec, n: 5) }
    let(:test_consec_3) { create(:test, user: teacher, problem: problem, db_file_id: consec_3.id) }
    let(:test_consec_5) { create(:test, user: teacher, problem: problem, db_file_id: consec_5.id) }
    let(:bad_submission_file) { fixture_file_upload("#{fixture_path}/files/BadSolution.java") }
    let!(:bad_submission) { create(:submission, user: student, problem: problem, file: bad_submission_file) }

    before do
      subject.create_testing_image(solution)

      # solution_id needs to be set after both objects have been created
      problem.update(solution_id: solution.id)

      FillExpectedOutputJob.perform_now(test_consec_3.id, test_consec_5.id)
      test_consec_3.reload
      test_consec_5.reload
    end
  end
end
