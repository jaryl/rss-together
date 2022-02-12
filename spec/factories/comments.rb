FactoryBot.define do
  factory :comment, class: "RssTogether::Comment" do
    account
    item

    content { Faker::Lorem.sentences }

    trait :invalid do
      content { nil }
    end
  end
end
