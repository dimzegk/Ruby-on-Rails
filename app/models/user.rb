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
end
