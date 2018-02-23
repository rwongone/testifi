# frozen_string_literal: true

class Execution < ApplicationRecord
  belongs_to :submission
  belongs_to :test

  def passed?
    !errored? && output == test.expected_output
  end

  def failed?
    !errored? && output != test.expected_output
  end

  def errored?
    !return_code.zero?
  end

  def status
    return "passed" if passed?
    return "failed" if failed?
    return "errored" if errored?
  end
end
