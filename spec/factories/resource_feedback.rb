FactoryBot.define do
  factory :feedback, class: "RssTogether::ResourceFeedback" do
    resource { association :feed }

    key { "some-error-has-occurred" }
    message { Faker::Lorem.paragraph }

    trait :invalid do
      key { "" }
      message { "" }
    end
  end
end
