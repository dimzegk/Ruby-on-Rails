module Private
  class Conversation < ApplicationRecord
    self.table_name = "private_conversations"

    belongs_to :sender,    class_name: "User"
    belongs_to :recipient, class_name: "User"

    has_many :messages,
             -> { order(created_at: :asc) },
             class_name: "Private::Message",
             foreign_key: :conversation_id,
             dependent: :destroy
    scope :all_by_user, ->(user_id) {
      where("sender_id = :uid OR recipient_id = :uid", uid: user_id)
    }

    scope :between_users, ->(u1, u2) {
      where("(sender_id = :u1 AND recipient_id = :u2) OR (sender_id = :u2 AND recipient_id = :u1)",
            u1: u1, u2: u2)
    }

    def opposed_user(user_or_id)
      uid = user_or_id.is_a?(User) ? user_or_id.id : user_or_id
      sender_id == uid ? recipient : sender
    end
  end
end
