FactoryBot.define do
  factory :account, class: "RssTogether::Account" do
    email { Faker::Internet.safe_email }
    password { "123123123" }
    status { :verified }

    trait :invalid do
      email { "" }
    end

    trait :verified do
      status { :verified }
    end

    trait :unverified do
      status { :unverified }
    end
  end
end
