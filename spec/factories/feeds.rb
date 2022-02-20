FactoryBot.define do
  factory :feed, class: "RssTogether::Feed" do
    title { Faker::Book.title }
    link { Faker::Internet.url }
    description { Faker::Lorem.sentence }

    trait :invalid do
      title { "" }
      link { "" }
      description { "" }
    end
  end
end
