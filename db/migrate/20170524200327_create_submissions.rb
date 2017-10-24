# frozen_string_literal: true

class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.references :user, null: false
      t.references :problem, null: false
      t.string :language, null: false
      t.bigint :db_file_id, null: false

      t.timestamps

      t.index :db_file_id
    end
  end
end
