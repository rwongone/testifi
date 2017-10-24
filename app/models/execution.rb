# frozen_string_literal: true

class Execution < ApplicationRecord
  belongs_to :submission
  belongs_to :test

  def passed?
    raise "Test #{test.id} missing expected output" if test.expected_output.nil?

    !errored? && output == test.expected_output
  end

  def failed?
    raise "Test #{test.id} missing expected output" if test.expected_output.nil?

    !errored? && output != test.expected_output
  end

  def errored?
    !return_code.zero?
  end
end
