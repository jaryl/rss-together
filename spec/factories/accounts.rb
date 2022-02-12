FactoryBot.define do
  factory :account, class: "RssTogether::Account" do
    email { Faker::Internet.safe_email }
    password { "123123123" }

    trait :invalid do
      email { "" }
    end
  end
end
