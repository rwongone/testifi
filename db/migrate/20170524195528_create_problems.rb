class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.string :name
      t.references :assignment

      t.timestamps
    end
  end
end
