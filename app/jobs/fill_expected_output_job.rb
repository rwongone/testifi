class FillExpectedOutputJob < ApplicationJob
  queue_as :pending_expected_output

  def perform(*test_ids)
    tests = Test.includes(:problem, problem: :solution).find(test_ids)

    tests.each do |test|
      fill_expected_output(test, test.problem.solution)
    end
  end

  def fill_expected_output(test, solution)
    test.expected_output = TestExecutor.run_test(solution, test)
    test.save!
  end
end
