FactoryBot.define do
  factory :private_message, class: 'Private::Message' do
    body { 'This is a test message' }
    association :conversation, factory: :private_conversation
    association :sender, factory: :user
  end
end
