FactoryBot.define do
  factory :bookmark, class: "RssTogether::Bookmark" do
    account
    item

    trait :invalid do
      account { nil }
    end
  end
end
