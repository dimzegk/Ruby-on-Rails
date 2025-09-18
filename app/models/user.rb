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


  has_many :contacts_sent, class_name: "Contact", foreign_key: "user_id", dependent: :destroy
  has_many :received_contacts, class_name: "Contact", foreign_key: "contact_id", dependent: :destroy

  has_many :accepted_sent_contact_requests, -> { where(contacts: { accepted: true }) },
           through: :contacts_sent,
           source: :contact

  has_many :accepted_received_contact_requests, -> { where(contacts: { accepted: true }) },
           through: :received_contacts,
           source: :user

  has_many :pending_sent_contact_requests, -> { where(contacts: { accepted: false }) },
           through: :contacts_sent,
           source: :contact

  has_many :pending_received_contact_requests, -> { where(contacts: { accepted: false }) },
           through: :received_contacts,
           source: :user



has_and_belongs_to_many :group_conversations,
                        class_name: "Group::Conversation",
                        join_table: "group_conversations_users",
                        association_foreign_key: "group_conversation_id"

  has_many :group_messages,
           class_name: "Group::Message",
           foreign_key: "user_id",
           dependent: :destroy



  def all_active_contacts
    accepted_sent_contact_requests | accepted_received_contact_requests
  end

  def contacts
    accepted_sent_contact_requests | accepted_received_contact_requests
  end

  def pending_contacts
    pending_sent_contact_requests | pending_received_contact_requests
  end

  def contact_with?(other_user)
    Contact.find_by_users(id, other_user.id)&.accepted
  end

  def already_in_contact?(other_user)
    Private::Conversation.exists?(sender_id: id, recipient_id: other_user.id) ||
      Private::Conversation.exists?(sender_id: other_user.id, recipient_id: id)
  end

  def contact(other_user)
    Contact.find_by(user_id: id, contact_id: other_user.id)
  end
end
