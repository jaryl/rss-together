FactoryBot.define do
  factory :item, class: "RssTogether::Item" do
    feed

    title { Faker::Book.title }
    description { Faker::Lorem.sentences }
    url { Faker::Internet.url }

    trait :invalid do
      title { "" }
      description { "" }
      url { "" }
    end
  end
end
