FactoryBot.define do
  factory :account, class: "RssTogether::Account" do
    email { "john.doe@example.net" }
    password { "123123123" }

    trait :invalid do
    end
  end
end
