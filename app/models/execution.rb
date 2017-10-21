class Execution < ApplicationRecord
  belongs_to :submission
  belongs_to :test

  def passed?
    raise "Test #{test.id} missing expected output" if test.expected_output.nil?

    return_code == 0 && output == test.expected_output
  end

  def failed?
    raise "Test #{test.id} missing expected output" if test.expected_output.nil?

    return_code == 0 && output != test.expected_output
  end

  def errored?
    return_code != 0
  end
end
