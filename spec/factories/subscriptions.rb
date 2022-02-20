FactoryBot.define do
  factory :subscription, class: "RssTogether::Subscription" do
    group
    feed
    account

    trait :invalid do
      group { nil }
    end
  end
end
