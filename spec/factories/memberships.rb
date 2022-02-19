FactoryBot.define do
  factory :membership, class: "RssTogether::Membership" do
    account
    group

    display_name { Faker::Internet.username }

    trait :invalid do
      account { nil }
      display_name { "." }
    end
  end
end
