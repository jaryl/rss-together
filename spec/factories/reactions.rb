FactoryBot.define do
  factory :reaction, class: "RssTogether::Reaction" do
    membership
    item

    value { "like" }

    trait :invalid do
      membership { nil }
      value { "" }
    end
  end
end
