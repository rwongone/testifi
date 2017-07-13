class CreateInvites < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'

    create_table :invites, id: :uuid do |t|
      t.string :email
      t.bigint :inviter_id
      t.bigint :course_id

      t.timestamps
      t.index :inviter_id
    end
  end
end
