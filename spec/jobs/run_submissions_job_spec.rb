# frozen_string_literal: true

require 'helpers/rails_helper'

RSpec.describe RunSubmissionsJob, type: :job do
  include ActiveJob::TestHelper
  include ActionDispatch::TestProcess
  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:assignment) { create(:assignment, course: course) }
  let!(:problem) { create(:problem, assignment: assignment) }
  let(:solution_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:solution_db_file) do
    create(:submission_db_file,
           name: solution_file.original_filename,
           contents: solution_file.read)
  end
  let!(:solution) do
    create(:submission,
           user: teacher,
           problem: problem,
           db_file_id: solution_db_file.id,
           language: FileHelper.filename_to_language(solution_file.original_filename))
  end
  let!(:good_submission) do
    create(:submission,
           user: student,
           problem: problem,
           db_file_id: solution_db_file.id,
           language: FileHelper.filename_to_language(solution_file.original_filename))
  end
  let(:consec_3) { create(:consec, n: 3) }
  let(:consec_5) { create(:consec, n: 5) }
  let!(:test_consec_3) { create(:test, user: teacher, problem: problem, db_file_id: consec_3.id) }
  let!(:test_consec_5) { create(:test, user: teacher, problem: problem, db_file_id: consec_5.id) }

  before do
    problem.update(solution_id: solution.id)

    FillExpectedOutputJob.perform_now(test_consec_3.id, test_consec_5.id)
  end

  subject(:job) { described_class.perform_later(good_submission.id) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(good_submission.id)
      .on_queue('pending_execution')
  end

  describe 'queuing a submission' do
    subject do
      perform_enqueued_jobs { described_class.perform_later(good_submission.id) }
    end

    before do
      perform_enqueued_jobs { described_class.perform_later(good_submission.id) }
    end

    it 'runs the submission on the tests' do
      expect(Execution.where(submission_id: good_submission.id).pluck(:output)).to match_array(
        Test.find([test_consec_3.id, test_consec_5.id]).pluck(:expected_output)
      )
    end

    it 'does not create duplicate Execution records' do
      expect { subject }.to_not(change { Execution.count })
    end

    it 'does not rerun on old tests' do
      expect(TestExecutor).to_not receive(:run_test)
      subject
    end

    let(:consec_6) { create(:consec, n: 6) }
    let(:test_consec_6) { create(:test, user: teacher, problem: problem, db_file_id: consec_6.id) }
    it 'will run only new tests' do
      FillExpectedOutputJob.perform_now(test_consec_6.id)
      test_consec_6.reload

      expect(TestExecutor).to receive(:run_test).once.with(good_submission, test_consec_6).and_call_original
      subject
    end
  end

  describe 'queuing multiple submissions' do
    let(:submission2_file) { fixture_file_upload("#{fixture_path}/files/BadSolution.java") }
    let(:submission2_db_file) do
      create(:submission_db_file,
             name: submission2_file.original_filename,
             contents: submission2_file.read)
    end
    let!(:submission2) do
      create(:submission,
             user: student,
             problem: problem,
             db_file_id: submission2_db_file.id,
             language: FileHelper.filename_to_language(submission2_file.original_filename))
    end

    it 'runs both submissions on the tests' do
      perform_enqueued_jobs do
        described_class.perform_later(good_submission.id, submission2.id)
      end
      expect(Execution.where(submission_id: [good_submission.id, submission2.id]).count).to eq(2 * problem.tests.count)
    end
  end
end
