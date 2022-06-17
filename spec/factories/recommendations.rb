FactoryBot.define do
  factory :recommendation, class: "RssTogether::Recommendation" do
    membership
    item

    trait :invalid do
      membership { nil }
    end
  end
end
