# db/migrate/xxxxx_create_group_conversations_users_join_table.rb
class CreateGroupConversationsUsersJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :group_conversations_users, id: false do |t|
      t.bigint :group_conversation_id, null: false
      t.bigint :user_id, null: false
    end

    add_index :group_conversations_users, [ :group_conversation_id, :user_id ],
              unique: true,
              name: 'index_gc_users_on_conversation_and_user'
  end
end
