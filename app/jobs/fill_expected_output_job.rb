class FillExpectedOutputJob < ApplicationJob
  queue_as :pending_expected_output

  def perform(*test_ids)
    tests = Test.includes(:problem, problem: :solution).find(test_ids)

    tests.each do |test|
      test.fill_expected_output!
    end
  end
end
