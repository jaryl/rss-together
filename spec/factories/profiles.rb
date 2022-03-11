FactoryBot.define do
  factory :profile, class: "RssTogether::Profile" do
    account

    display_name { Faker::Internet.username }
    timezone do
      val = Faker::Address.time_zone
      ActiveSupport::TimeZone::MAPPING.find { |k, v| v == val }.first
    end

    trait :invalid do
      account { nil }
      display_name { "" }
      timezone { "" }
    end
  end
end
