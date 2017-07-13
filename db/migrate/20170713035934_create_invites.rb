class CreateInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :invites, id: :uuid do |t|
      t.string :email
      t.bigint :inviter_id
      t.references :course

      t.timestamps
      t.index :inviter_id
    end
  end
end
