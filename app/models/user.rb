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

  # Contacts
  has_many :received_contacts, class_name: 'Contact', foreign_key: 'contact_id', dependent: :destroy
  has_many :contacts_sent, class_name: 'Contact', foreign_key: 'user_id', dependent: :destroy

  # Όλες οι αποδεκτές επαφές
  def contacts
    user_ids = Contact.where("(user_id = ? OR contact_id = ?) AND accepted = ?", id, id, true)
                      .pluck(:user_id, :contact_id)
                      .flatten
                      .uniq - [id]
    User.where(id: user_ids)
  end

  def contact_with?(other_user)
    Contact.find_by_users(id, other_user.id)&.accepted
  end

  # Υπάρχει ήδη συνομιλία;
  def already_in_contact?(other_user)
    Private::Conversation.exists?(sender_id: self.id, recipient_id: other_user.id) ||
      Private::Conversation.exists?(sender_id: other_user.id, recipient_id: self.id)
  end
end
