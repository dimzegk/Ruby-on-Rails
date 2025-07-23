class Group::Conversation < ApplicationRecord
  self.table_name = "group_conversations"

  has_and_belongs_to_many :users,
                          class_name: "User",
                          join_table: "group_conversations_users"

  has_many :messages,
           class_name: "Group::Message",
           foreign_key: "conversation_id",
           dependent: :destroy

  validates :name, presence: true
end
