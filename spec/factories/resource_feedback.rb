FactoryBot.define do
  factory :feedback, class: "RssTogether::ResourceFeedback" do
    resource { association :feed }

    title { "An error has occurred" }
    message { Faker::Lorem.sentences }

    trait :invalid do
      title { "" }
      message { "" }
    end
  end
end
