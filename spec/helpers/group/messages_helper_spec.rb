require 'rails_helper'

RSpec.describe Group::MessagesHelper, type: :helper do
  context '#group_message_seen_by' do
    let(:message) { create(:group_message) }

    it 'returns an array with users' do
      users = create_list(:user, 2)
      users.each { |user| message.seen_by << user.id }
      message.save
      names = users.map(&:name)
      expect(helper.group_message_seen_by(message)).to eq(names)
    end

    it 'returns an empty array' do
      expect(helper.group_message_seen_by(message)).to eq([])
    end
  end

  context '#message_content_partial_path' do
    let(:user) { create(:user) }
    let(:message) { create(:group_message) }

    it "returns same_user_content partial's path" do
      previous_message = create(:group_message, user: user)
      expect(helper.message_content_partial_path(user, message, previous_message)).to eq(
        'group/messages/message/same_user_content'
      )
    end

    it "returns different_user_content partial's path when users differ" do
      previous_message = create(:group_message)
      expect(helper.message_content_partial_path(user, message, previous_message)).to eq(
        'group/messages/message/different_user_content'
      )
    end

    it "returns different_user_content partial's path when previous is nil" do
      expect(helper.message_content_partial_path(user, message, nil)).to eq(
        'group/messages/message/different_user_content'
      )
    end
  end

  context '#group_message_date_check_partial_path' do
    let(:new_message) { create(:group_message) }

    it "returns a new_date partial's path when dates differ" do
      previous_message = create(:group_message, created_at: 3.days.ago)
      new_message.update(created_at: Time.current)
      expect(helper.group_message_date_check_partial_path(new_message, previous_message)).to eq(
        'group/messages/message/new_date'
      )
    end

    it "returns an empty partial's path when dates match" do
      previous_message = create(:group_message, created_at: Time.current)
      new_message.update(created_at: Time.current)
      expect(helper.group_message_date_check_partial_path(new_message, previous_message)).to eq(
        'shared/empty_partial'
      )
    end

    it "returns an empty partial's path when previous is nil" do
      expect(helper.group_message_date_check_partial_path(new_message, nil)).to eq(
        'shared/empty_partial'
      )
    end
  end
end
