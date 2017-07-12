require './app/lib/test_executor.rb'
require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe TestExecutor do
  include ActionDispatch::TestProcess

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:submission_db_file) { create(:submission_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read) }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: submission_db_file.id) }

  subject { described_class }

  describe "#create_testing_image" do
    before do
      subject.class_variable_set(:@@images, {})
    end

    # All expectations in one test, so we only actually create the image once.
    it "creates a singleton Docker::Image for the Submission" do
      expect(subject.class_variable_get(:@@images)).to be_empty
      expect(Docker::Image).to receive(:build_from_dir).once.and_call_original

      image = subject.create_testing_image(submission)
      subject.create_testing_image(submission)

      expect(image).to be_instance_of(Docker::Image)
      expect(subject.class_variable_get(:@@images)[submission.language]).to eq(image)
    end
  end

  context "when the Submission's image has already been created"

  describe "#run_tests" do
    it "executes all associated Tests for the Problem on a given Submission" do
      pending("to be implemented")
    end
  end

  describe "#output_of" do
    it "returns the result of executing the Test on the Submission code" do
      output = subject.output_of(submission, test)
      expect(output).to eq('')
    end

    it "runs the canonical solution if the expected output is missing" do
      pending("to be implemented")
    end

    it "does not run the canonical solution if the expected output is present" do
      pending("to be implemented")
    end
  end

  describe "#run_solution" do
    it "executes the canonical solution for a Problem" do
      pending("to be implemented")
    end

    it "stores the expected output in the associated Test" do
      pending("to be implemented")
    end
  end
end
