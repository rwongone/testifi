class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.string :name
      t.string :filename
      t.binary :file_contents
      t.string :hint
      t.references :problem

      t.timestamps
    end
  end
end
