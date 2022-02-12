FactoryBot.define do
  factory :subscription, class: "RssTogether::Subscription" do
    group
    feed

    trait :invalid do
    end
  end
end
