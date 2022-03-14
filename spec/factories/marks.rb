FactoryBot.define do
  factory :mark, class: "RssTogether::Mark" do
    reader factory: :membership
    item

    trait :invalid do
      reader { nil }
    end
  end
end
