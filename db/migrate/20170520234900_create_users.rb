# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.string :github_id
      t.string :google_id

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :github_id, unique: true
    add_index :users, :google_id, unique: true
  end
end
