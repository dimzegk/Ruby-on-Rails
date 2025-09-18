FactoryBot.define do
  factory :group_conversation, class: 'Group::Conversation' do
    name { "Test Group Conversation" }

    transient do
      users { [] }
    end

    after(:create) do |conversation, evaluator|
      if evaluator.users.present?
        evaluator.users.each do |user|
          conversation.users << user unless conversation.users.include?(user)
        end
      end
    end
  end
end
