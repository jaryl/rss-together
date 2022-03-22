FactoryBot.define do
  factory :item, class: "RssTogether::Item" do
    feed

    title { Faker::Book.title }
    content { Faker::Lorem.paragraph }
    link { Faker::Internet.url }

    description { Faker::Lorem.sentence }
    author { Faker::Name.name }
    published_at { Faker::Date.backward(days: 365 * 8) }

    trait :invalid do
      title { "" }
      description { "" }
      link { "" }
    end
  end
end
