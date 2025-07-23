class User < ApplicationRecord
  # Devise authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Posts & Messages
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

  # === Contacts ===

  # Direct contact requests
  has_many :contacts_sent, class_name: "Contact", foreign_key: "user_id", dependent: :destroy

  # Received contact requests
  has_many :received_contacts, class_name: "Contact", foreign_key: "contact_id", dependent: :destroy

  # Accepted contacts (outgoing)
  has_many :accepted_sent_contact_requests, -> { where(contacts: { accepted: true }) },
           through: :contacts_sent,
           source: :contact

  # Accepted contacts (incoming)
  has_many :accepted_received_contact_requests, -> { where(contacts: { accepted: true }) },
           through: :received_contacts,
           source: :user

  # Pending contacts (outgoing)
  has_many :pending_sent_contact_requests, -> { where(contacts: { accepted: false }) },
           through: :contacts_sent,
           source: :contact

  # Pending contacts (incoming)
  has_many :pending_received_contact_requests, -> { where(contacts: { accepted: false }) },
           through: :received_contacts,
           source: :user

  # === Contact Query Methods ===

  # Όλες οι αποδεκτές επαφές (όπου accepted = true, είτε έστειλες είτε έλαβες)
  def all_active_contacts
  accepted_sent_contact_requests | accepted_received_contact_requests
end
  def contacts
    accepted_sent_contact_requests | accepted_received_contact_requests
  end

  # Όλα τα pending αιτήματα (είτε έστειλες είτε έλαβες)
  def pending_contacts
    pending_sent_contact_requests | pending_received_contact_requests
  end

  # Έλεγξε αν έχεις accepted contact με έναν άλλο χρήστη
  def contact_with?(other_user)
    Contact.find_by_users(id, other_user.id)&.accepted
  end

  # Έλεγξε αν υπάρχει ήδη συνομιλία μεταξύ σας
  def already_in_contact?(other_user)
    Private::Conversation.exists?(sender_id: id, recipient_id: other_user.id) ||
      Private::Conversation.exists?(sender_id: other_user.id, recipient_id: id)
  end

  # Βρες τη Contact εγγραφή μεταξύ σου και κάποιου άλλου χρήστη (αν υπάρχει)
  def contact(other_user)
    Contact.find_by(user_id: id, contact_id: other_user.id)
  end
  has_and_belongs_to_many :group_conversations,
                        class_name: "Group::Conversation",
                        join_table: "group_conversations_users"

has_many :group_messages,
         class_name: "Group::Message",
         foreign_key: "sender_id",
         dependent: :destroy
end
