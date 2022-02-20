FactoryBot.define do
  factory :item, class: "RssTogether::Item" do
    feed

    title { Faker::Book.title }
    description { Faker::Lorem.sentences }
    link { Faker::Internet.url }

    trait :invalid do
      title { "" }
      description { "" }
      link { "" }
    end
  end
end
