require 'helpers/rails_helper'

RSpec.describe FillExpectedOutputJob, type: :job do
  include ActiveJob::TestHelper
  include ActionDispatch::TestProcess

  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:assignment) { create(:assignment, course: course) }
  let!(:problem) { create(:problem, assignment: assignment) }
  let(:solution_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:solution_db_file) { create(:submission_db_file,
                                    name: solution_file.original_filename,
                                    contents: solution_file.read) }
  let!(:solution) { create(:submission,
                           user: teacher,
                           problem: problem,
                           db_file_id: solution_db_file.id,
                           language: FileHelper.filename_to_language(solution_file.original_filename)) }

  let(:consec_3) { create(:consec, n: 3) }
  let(:consec_5) { create(:consec, n: 5) }
  let!(:test_consec_3) { create(:test, user: teacher, problem: problem, db_file_id: consec_3.id) }
  let!(:test_consec_5) { create(:test, user: teacher, problem: problem, db_file_id: consec_5.id) }

  before do
    problem.update(solution_id: solution.id)
  end

  it "queues the job" do
    expect { FillExpectedOutputJob.perform_later(test_consec_3.id) }.to have_enqueued_job(FillExpectedOutputJob)
      .with(test_consec_3.id)
      .on_queue("pending_expected_output")
  end

  describe "queuing a job" do
    it "fills the expected output of the test" do
      expect { perform_enqueued_jobs {
        FillExpectedOutputJob.perform_later(test_consec_3.id)
      } }.to change { Test.find(test_consec_3.id).expected_output }
    end
  end

  describe "queuing multiple tests" do
    it "fills expected output for both tests" do
      expect { perform_enqueued_jobs {
        FillExpectedOutputJob.perform_later(test_consec_3.id, test_consec_5.id)
      } }.to change { Test.find(test_consec_3.id).expected_output }
      .and change { Test.find(test_consec_5.id).expected_output }
    end
  end
end
