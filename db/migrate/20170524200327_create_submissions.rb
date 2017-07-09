class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.references :user, null: false
      t.references :problem, null: false
      t.string :language, null: false
      t.string :filename, null: false
      t.string :content_type
      t.binary :file_contents

      t.timestamps
    end
  end
end
