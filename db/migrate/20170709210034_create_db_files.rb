class CreateDbFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :db_files do |t|
      t.string :name, null: false
      t.string :type
      t.binary :contents, null: false

      t.timestamps
    end
  end
end
