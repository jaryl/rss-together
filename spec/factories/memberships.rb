FactoryBot.define do
  factory :membership, class: "RssTogether::Membership" do
    account
    group { association :group, owner: account }

    display_name_override { Faker::Internet.username }

    trait :invalid do
      account { nil }
      display_name_override { "." }
    end
  end
end
