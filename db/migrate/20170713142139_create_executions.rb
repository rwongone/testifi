class CreateExecutions < ActiveRecord::Migration[5.1]
  def change
    create_table :executions do |t|
      t.binary :output, null: false
      t.references :submission, null: false
      t.references :test, null: false
    end
  end
end
