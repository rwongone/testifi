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
  let(:solution_db_file) { create(:submission_db_file,
                                    name: solution_file.original_filename,
                                    contents: solution_file.read) }
  let!(:solution) { create(:submission,
                           user: teacher,
                           problem: problem,
                           db_file_id: solution_db_file.id,
                           language: FileHelper.filename_to_language(solution_file.original_filename)) }
  let!(:good_submission) { create(:submission,
                                  user: student,
                                  problem: problem,
                                  db_file_id: solution_db_file.id,
                                  language: FileHelper.filename_to_language(solution_file.original_filename)) }
  before do
    problem.update(solution_id: solution.id)
  end

  subject(:job) { described_class.perform_later(good_submission.id) }

  it "queues the job" do
    expect { job }.to have_enqueued_job(described_class)
        .with(good_submission.id)
        .on_queue("submission")
  end

  describe "queuing a submission" do
    let(:consec_3) { create(:consec, n: 3) }
    let(:consec_5) { create(:consec, n: 5) }
    let!(:test_consec_3) { create(:test, user: teacher, problem: problem, db_file_id: consec_3.id) }
    let!(:test_consec_5) { create(:test, user: teacher, problem: problem, db_file_id: consec_5.id) }


    it "runs the submission on the tests" do
      expect{ perform_enqueued_jobs { job } }.to change{ Execution.count }.by(2)
    end

    it "does not create duplicate Execution records" do
      perform_enqueued_jobs { job }
      expect{ perform_enqueued_jobs { job } }.to_not change{ Execution.count }
    end
  end

end
