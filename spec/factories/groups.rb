FactoryBot.define do
  factory :group, class: "RssTogether::Group" do
    name { Faker::Hobby.activity }

    trait :invalid do
      name { "" }
    end
  end
end
