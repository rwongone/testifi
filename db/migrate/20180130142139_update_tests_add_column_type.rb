# frozen_string_literal: true

class UpdateTestsAddColumnType < ActiveRecord::Migration[5.1]
  def change
    add_column :tests, :type, :string
  end
end
