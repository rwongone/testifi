# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :invites, id: :uuid do |t|
      t.string :email, null: false
      t.bigint :inviter_id, null: false
      t.bigint :redeemer_id
      t.references :course, null: false

      t.timestamps
      t.index :inviter_id
      t.index :redeemer_id
    end
  end
end
