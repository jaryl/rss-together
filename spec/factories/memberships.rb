FactoryBot.define do
  factory :membership, class: "RssTogether::Membership" do
    account
    group

    trait :invalid do
      account { nil }
    end
  end
end
