FactoryBot.define do
  factory :subscription, class: "RssTogether::Subscription" do
    group
    feed

    trait :invalid do
      group { nil }
    end
  end
end
