FactoryBot.define do
factory :group_message, class: 'Group::Message' do
  content { 'This is a test message for group chat' }
  conversation { association(:group_conversation) }
  user
end
end
