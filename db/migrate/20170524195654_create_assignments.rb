class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.string :name
      t.text :description
      t.references :course

      t.timestamps
    end
  end
end
