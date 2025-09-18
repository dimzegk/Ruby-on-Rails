require 'rails_helper'

describe OrderConversationsService do
  describe '#call' do
    it 'returns ordered conversations in descending order' do
      user = create(:user)

      # Πρώτη συνομιλία (παλαιότερη)
      conversation1 = create(:private_conversation,
                             sender_id: user.id,
                             recipient: create(:user))
      message1 = create(:private_message,
                        conversation: conversation1,
                        sender_id: user.id,
                        created_at: 1.day.ago)

      # Δεύτερη συνομιλία (μέση)
      conversation2 = create(:group_conversation,
                             users: [ user ])
      message2 = create(:group_message,
                        conversation: conversation2,
                        user: user,
                        created_at: 5.hours.ago)

      # Τρίτη συνομιλία (πιο πρόσφατη)
      conversation3 = create(:private_conversation,
                             sender_id: user.id,
                             recipient: create(:user))
      message3 = create(:private_message,
                        conversation: conversation3,
                        sender_id: user.id,
                        created_at: 1.hour.ago)

      ordered = OrderConversationsService.new(user: user).call

      expect(ordered).to eq [ conversation3, conversation2, conversation1 ]
    end
  end
end
