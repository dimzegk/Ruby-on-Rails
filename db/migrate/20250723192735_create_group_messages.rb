class CreateGroupMessages < ActiveRecord::Migration[8.0]
def change
    create_table :group_messages do |t|
      t.text :content, null: false
      t.text :seen_by         # serialized Array
      t.text :added_new_users # serialized Array
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: { to_table: :group_conversations }

      t.timestamps
    end
  end
end
