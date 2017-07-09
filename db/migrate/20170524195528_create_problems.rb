class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.string :name
      t.text :description
      t.string :soln_filename
      t.binary :soln_file_contents
      t.references :assignment

      t.timestamps
    end
  end
end
