FactoryBot.define do
  factory :profile, class: "RssTogether::Profile" do
    account

    display_name { Faker::Internet.username }
    timezone { Faker::Address.time_zone }

    trait :invalid do
      account { nil }
      display_name { "" }
      timezone { "" }
    end
  end
end
