class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.string :name
      t.string :hint
      t.string :expected_output
      t.references :problem
      t.references :user
      t.bigint :db_file_id, null: false

      t.timestamps

      t.index :db_file_id
    end
  end
end
