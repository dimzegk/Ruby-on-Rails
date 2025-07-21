# spec/models/contact_spec.rb
require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { build(:contact) }

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:contact).class_name('User') }
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(contact).to be_valid
    end

    it 'is not valid with duplicate user/contact pair' do
      user = create(:user)
      other_user = create(:user)
      create(:contact, user: user, contact: other_user)

      # Προσπάθεια να δημιουργήσουμε ίδιο ζεύγος
      duplicate = build(:contact, user: user, contact: other_user)
      expect(duplicate).not_to be_valid
    end
  end

  describe '.find_by_users' do
    it 'finds the contact regardless of user order' do
      user1 = create(:user)
      user2 = create(:user)
      contact = create(:contact, user: user1, contact: user2)

      expect(Contact.find_by_users(user1.id, user2.id)).to eq contact
      expect(Contact.find_by_users(user2.id, user1.id)).to eq contact
    end
  end
end
