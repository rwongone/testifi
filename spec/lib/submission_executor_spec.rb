require './app/lib/submission_executor.rb'
require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe SubmissionExecutor do
  let(:submission) { create(:submission, language: :java, filename: 'Solution.java') }

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
