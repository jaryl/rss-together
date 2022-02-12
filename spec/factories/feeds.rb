FactoryBot.define do
  factory :feed, class: "RssTogether::Feed" do
    url { "https://example.net" }

    trait :invalid do
      url { "" }
    end
  end
end
