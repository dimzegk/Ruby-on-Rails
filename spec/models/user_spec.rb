require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Associations' do
    it 'has_many posts' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has_many contacts_sent' do
      association = described_class.reflect_on_association(:contacts_sent)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq 'Contact'
      expect(association.options[:foreign_key]).to eq 'user_id'
    end

    it 'has_many received_contacts' do
      association = described_class.reflect_on_association(:received_contacts)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq 'Contact'
      expect(association.options[:foreign_key]).to eq 'contact_id'
    end

    it 'has_many accepted_sent_contact_requests' do
      association = described_class.reflect_on_association(:accepted_sent_contact_requests)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :contacts_sent
      expect(association.options[:source]).to eq :contact
    end

    it 'has_many accepted_received_contact_requests' do
      association = described_class.reflect_on_association(:accepted_received_contact_requests)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :received_contacts
      expect(association.options[:source]).to eq :user
    end

    it 'has_many pending_sent_contact_requests' do
      association = described_class.reflect_on_association(:pending_sent_contact_requests)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :contacts_sent
      expect(association.options[:source]).to eq :contact
    end

    it 'has_many pending_received_contact_requests' do
      association = described_class.reflect_on_association(:pending_received_contact_requests)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :received_contacts
      expect(association.options[:source]).to eq :user
    end
  end

  context 'Methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

   before do
  other_user1 = create(:user)
  other_user2 = create(:user)
  other_user3 = create(:user)
  other_user4 = create(:user)

  # ο χρήστης έχει στείλει 1 pending και 1 accepted request
  create(:contact, user: user, contact: other_user1) # pending_sent
  create(:contact, user: user, contact: other_user2, accepted: true) # accepted_sent

  # ο χρήστης έχει λάβει 1 pending και 1 accepted request
  create(:contact, user: other_user3, contact: user) # pending_received
  create(:contact, user: other_user4, contact: user, accepted: true) # accepted_received
end

    it 'accepted_sent_contact_requests gets only accepted requests' do
      expect(user.accepted_sent_contact_requests.count).to eq 1
    end

    it 'accepted_received_contact_requests gets only accepted requests' do
      expect(user.accepted_received_contact_requests.count).to eq 1
    end

    it 'pending_sent_contact_requests gets only unaccepted requests' do
      expect(user.pending_sent_contact_requests.count).to eq 1
    end

    it 'pending_received_contact_requests gets only unaccepted requests' do
      expect(user.pending_received_contact_requests.count).to eq 1
    end

    it '#contacts returns all accepted contacts' do
      expect(user.contacts).to match_array([
        user.accepted_sent_contact_requests.first,
        user.accepted_received_contact_requests.first
      ])
    end

    it '#pending_contacts returns all pending contacts' do
      expect(user.pending_contacts).to match_array([
        user.pending_sent_contact_requests.first,
        user.pending_received_contact_requests.first
      ])
    end

    it '#contact_with? returns true only for accepted contact' do
      accepted_user = user.accepted_sent_contact_requests.first
      pending_user = user.pending_sent_contact_requests.first

      expect(user.contact_with?(accepted_user)).to be true
      expect(user.contact_with?(pending_user)).to be false
    end

    it '#contact returns the contact record between users' do
      contact = user.contacts_sent.last
      expect(user.contact(contact.contact)).to eq contact
    end
  end
end
