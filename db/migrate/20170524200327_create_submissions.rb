class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.references :user, null: false
      t.references :problem, null: false
      t.string :language, null: false

      t.timestamps
    end
  end
end
