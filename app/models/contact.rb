class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: 'User'

  validates :user_id, uniqueness: { scope: :contact_id }

  # Βρίσκει εγγραφή ανεξαρτήτως σειράς user/contact
  def self.find_by_users(user_id, contact_id)
    where(user_id: user_id, contact_id: contact_id).or(
      where(user_id: contact_id, contact_id: user_id)
    ).first
  end
end
