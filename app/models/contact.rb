class Contact < ApplicationRecord
  # Κάθε επαφή ανήκει σε έναν χρήστη (αυτός που στέλνει την αίτηση)
  belongs_to :user

  # Και επίσης, κάθε επαφή συνδέεται με έναν άλλον χρήστη (τον παραλήπτη)
  belongs_to :contact, class_name: "User"

  # Μοναδικότητα επαφής - δεν μπορεί να υπάρξει διπλή επαφή μεταξύ των δύο χρηστών
  validates :user_id, uniqueness: { scope: :contact_id }

  # ✅ Στατική μέθοδος που βρίσκει την επαφή ανεξάρτητα από ποιος την ξεκίνησε
  def self.find_by_users(user_id, contact_id)
    where(user_id: user_id, contact_id: contact_id)
      .or(where(user_id: contact_id, contact_id: user_id))
      .first
  end

  # Μπορείς να προσθέσεις και helper μέθοδο αν χρειαστεί:
  def accepted?
    accepted
  end
  after_create_commit { ContactRequestBroadcastJob.perform_later(self) }
end
