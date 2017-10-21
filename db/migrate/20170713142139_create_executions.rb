class CreateExecutions < ActiveRecord::Migration[5.1]
  def change
    create_table :executions do |t|
      t.binary :output
      t.binary :std_error
      t.integer :return_code
      t.references :submission, null: false
      t.references :test, null: false

      t.timestamps
    end
  end
end
