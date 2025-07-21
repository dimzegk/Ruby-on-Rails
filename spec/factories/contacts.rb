FactoryBot.define do
  factory :contact do
    association :user
    association :contact, factory: :user
    accepted { false }
  end
end
