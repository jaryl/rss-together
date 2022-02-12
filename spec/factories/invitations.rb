FactoryBot.define do
  factory :invitation, class: "RssTogether::Invitation" do
    group

    email { "john.doe@example.net" }

    trait :invalid do
      email { "" }
    end
  end
end
