class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.string :name
      t.text :description
      t.references :assignment
      t.bigint :solution_id # this is a foreign key for a canonical submission

      t.timestamps

      t.index :solution_id
    end

  end
end
