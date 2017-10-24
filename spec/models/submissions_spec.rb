# frozen_string_literal: true

require 'helpers/rails_helper'

RSpec.describe Submission, type: :model do
  include ActionDispatch::TestProcess

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:consec_3) { create(:consec, n: 3) }
  let(:consec_5) { create(:consec, n: 5) }
  let(:test_consec_3) { create(:test, user: teacher, problem: problem, db_file_id: consec_3.id) }
  let(:test_consec_5) { create(:test, user: teacher, problem: problem, db_file_id: consec_5.id) }
  let(:solution_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let!(:solution) { create(:submission, user: teacher, problem: problem, file: solution_file) }

  let(:submission_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }

  subject { create(:submission, user: student, problem: problem, file: submission_file) }

  before do
    # solution_id needs to be set after both objects have been created
    problem.update(solution_id: solution.id)

    FillExpectedOutputJob.perform_now(test_consec_3.id, test_consec_5.id)
    test_consec_3.reload
    test_consec_5.reload
  end

  describe '#correct?' do
    it 'executes Tests if it needs to' do
      expect(subject).to receive(:run_test!).with(test_consec_3).once.and_call_original
      subject.run_test!(test_consec_3)

      expect(subject).to receive(:run_test!).with(test_consec_5, false).once.and_call_original
      subject.correct?
    end

    it 'returns True iff all related Executions have no errors and are correct' do
      expect(subject.correct?).to eq(true)
    end
  end

  describe '#run_tests!' do
    it 'executes all Tests associated with its Problem' do
      expect(subject).to receive(:run_test!).exactly(problem.tests.length).times

      subject.run_tests!
    end
  end

  describe '#run_test!' do
    it 'returns Execution output as a string if output_only' do
      expect(subject.run_test!(test_consec_3)).to eq("6\n")
    end

    it 'returns the Execution if output_only is false' do
      execution = subject.run_test!(test_consec_3, false)
      expect(execution).to eq(Execution.find_by(submission: subject, test: test_consec_3))
      expect(execution.output).to eq("6\n")
      expect(execution.std_error).to eq(nil)
      expect(execution.return_code).to eq(0)
    end
  end
end
