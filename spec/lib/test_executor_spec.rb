require './app/lib/submission_executor.rb'
require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe SubmissionExecutor do
  include ActionDispatch::TestProcess

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course) }
  let(:assignment) { create(:assignment, course_id: course.id) }
  let!(:problem) { create(:problem, assignment_id: assignment.id) }
  let(:uploaded_file) { fixture_file_upload("#{fixture_path}/files/Solution.java") }
  let(:db_file) { create(:submission_db_file, name: uploaded_file.original_filename, contents: uploaded_file.read) }
  let!(:submission) { create(:submission, user_id: student.id, problem_id: problem.id, db_file_id: db_file.id) }

  subject { described_class }

  describe "#create_testing_image" do
    it "returns a Docker::Image" do
      image = subject.create_testing_image(submission)
      expect(image).to be_instance_of(Docker::Image)
    end
  end

  describe "#run_tests" do
    it "executes all associated Tests for the Problem on a given Submission" do
      pending("to be implemented")
    end
  end

  describe "#run_test" do
    it "returns the result of executing the Test on the Submission code" do
      pending("to be implemented")
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
