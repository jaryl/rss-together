FactoryBot.define do
  factory :mark, class: "RssTogether::Mark" do
    account
    item

    trait :invalid do
      account { nil }
    end
  end
end
