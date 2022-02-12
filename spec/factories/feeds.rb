FactoryBot.define do
  factory :feed, class: "RssTogether::Feed" do
    url { Faker::Internet.url }

    trait :invalid do
      url { "" }
    end
  end
end
