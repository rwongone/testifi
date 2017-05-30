class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.references :user
      t.references :problem
      t.string :language, null: false
      t.string :filepath, null: false

      t.timestamps
    end
  end
end
