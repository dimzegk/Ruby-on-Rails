FactoryBot.define do
  factory :group_message, class: 'Group::Message' do
    content { 'This is a test message for group chat' }
    association :conversation, factory: :group_conversation
    association :user
  end
end
