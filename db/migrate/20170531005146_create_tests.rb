class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.string :name
      t.string :hint
      t.references :problem
      t.bigint :db_file_id, null: false

      t.timestamps

      t.index :db_file_id
    end
  end
end
