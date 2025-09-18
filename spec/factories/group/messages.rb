# spec/factories/group/messages.rb
FactoryBot.define do
  factory :group_message, class: 'Group::Message' do
    association :conversation, factory: :group_conversation
    association :user
    content { "This is a test group message" }
    seen_by { [] }
    added_new_users { [] }
  end
end
