FactoryBot.define do
  factory :comment, class: "RssTogether::Comment" do
    author factory: :membership
    item

    content { Faker::Lorem.paragraph }

    trait :invalid do
      content { nil }
    end
  end
end
