FactoryBot.define do
  factory :subscription_request, class: "RssTogether::SubscriptionRequest" do
    membership

    target_url { Faker::Internet.url }

    trait :invalid do
      target_url { "some-invalid-url" }
    end
  end
end
