class Contact < ApplicationRecord
  belongs_to :user

  belongs_to :contact, class_name: "User"

  validates :user_id, uniqueness: { scope: :contact_id }

  def self.find_by_users(user_id, contact_id)
    where(user_id: user_id, contact_id: contact_id)
      .or(where(user_id: contact_id, contact_id: user_id))
      .first
  end

  def accepted?
    accepted
  end
  after_create_commit { ContactRequestBroadcastJob.perform_later(self) }
end
