FactoryBot.define do
  factory :invitation, class: "RssTogether::Invitation" do
    group
    sender factory: :account

    email { Faker::Internet.safe_email }

    trait :invalid do
      email { "" }
    end
  end
end
