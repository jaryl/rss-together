FactoryBot.define do
  factory :item, class: "RssTogether::Item" do
    feed

    title { Faker::Book.title }
    content { Faker::Lorem.sentences }
    link { Faker::Internet.url }

    description { Faker::Lorem.sentences }
    author { Faker::Name.name }

    trait :invalid do
      title { "" }
      description { "" }
      link { "" }
    end
  end
end
