require './app/lib/test_executor.rb'
require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe TestExecutor do
  include ActionDispatch::TestProcess

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course: course) }
  let!(:problem) { create(:problem, assignment: assignment) }
  let(:good_solution_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:submission_db_file) { create(:submission_db_file,
                                    name: good_solution_file.original_filename,
                                    contents: good_solution_file.read) }
  let!(:submission) { create(:submission, user: student, problem: problem, db_file_id: submission_db_file.id) }

  subject { described_class }

  describe ".create_testing_image" do
    # All expectations in one test, so we only actually create the image once.
    it "creates a singleton Docker::Image for the Submission" do
      expect(subject.images).to be_empty
      expect(Docker::Image).to receive(:build_from_dir).once.and_call_original

      image = subject.create_testing_image(submission)
      subject.create_testing_image(submission)

      expect(image).to be_instance_of(Docker::Image)
      expect(subject.images[submission.language]).to eq(image)
    end
  end

  context "when executing tests with an existing image" do
    let(:consec_3) { create(:consec, n: 3) }
    let(:consec_5) { create(:consec, n: 5) }
    let(:test_consec_3) { create(:test, user: student, problem: problem, db_file_id: consec_3.id) }
    let(:test_consec_5) { create(:test, user: student, problem: problem, db_file_id: consec_5.id) }
    let(:bad_solution_file) { fixture_file_upload("#{fixture_path}/files/BadSolution.java") }
    let(:bad_submission_db_file) { create(:submission_db_file,
                                          name: bad_solution_file.original_filename,
                                          contents: bad_solution_file.read) }
    let!(:bad_submission) { create(:submission, user: student, problem: problem, db_file_id: bad_submission_db_file.id) }

    before do
      subject.create_testing_image(submission)

      # solution_id needs to be set after both objects have been created
      problem.solution_id = submission.id
    end

    describe ".run_tests" do
      it "executes all Tests for the Submission's Problem using the Submission" do
        expect(subject).to receive(:run_test).exactly(problem.tests.length).times

        subject.run_tests(submission)
      end
    end

    describe ".run_test" do
      it "returns true if the Submission output matches expected output" do
        expect(subject.run_test(submission, test_consec_3)).to be true
        expect(subject.run_test(submission, test_consec_5)).to be true
      end

      it "returns false if the Submission output differs from expected output" do
        expect(subject.run_test(bad_submission, test_consec_3)).to be false
        expect(subject.run_test(bad_submission, test_consec_5)).to be false
      end

      it "computes expected output iff expected output is missing on the Test" do
        expect(test_consec_3.expected_output).to be_nil
        expect(subject).to receive(:fill_expected_output).
          with(problem, test_consec_3).
          once.
          and_call_original

        subject.run_test(bad_submission, test_consec_3)
        expect(test_consec_3.expected_output).to eq("6\n")
      end
    end

    describe ".output_of" do
      it "returns the result of executing the Test on the Submission code" do
        output = subject.output_of(submission, test_consec_3)
        expect(output).to eq("6\n")
      end
    end
  end
end
