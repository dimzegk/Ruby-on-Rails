class Group::Conversation < ApplicationRecord
  self.table_name = "group_conversations"

has_and_belongs_to_many :users,
                        class_name: "User",
                        join_table: "group_conversations_users",
                        foreign_key: "group_conversation_id",
                        association_foreign_key: "user_id"

  has_many :messages,
           class_name: "Group::Message",
           foreign_key: "conversation_id",
           dependent: :destroy

  validates :name, presence: true
 def members_relation
    return users   if respond_to?(:users)
    return members if respond_to?(:members)
    raise "Group::Conversation: define users or members association"
  end
  def recalc_name!(order: :name, sep: ", ")
    rel = members_relation
    rel = rel.reorder(order) if rel.klass.column_names.include?(order.to_s)
    names = rel.pluck(:name).map(&:to_s).map(&:strip).reject(&:blank?).uniq
    update!(name: names.join(sep))
  end
end