class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_many :private_messages,
           class_name: "Private::Message",
           dependent: :destroy
  has_many :private_conversations,
           foreign_key: :sender_id,
           class_name: "Private::Conversation",
           dependent: :destroy
  has_many :received_private_conversations,
           foreign_key: :recipient_id,
           class_name: "Private::Conversation",
           dependent: :destroy
           def already_in_contact?(other_user)
  Private::Conversation.exists?(sender_id: self.id, recipient_id: other_user.id) ||
    Private::Conversation.exists?(sender_id: other_user.id, recipient_id: self.id)
end
end
