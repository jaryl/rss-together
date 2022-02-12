FactoryBot.define do
  factory :group, class: "RssTogether::Group" do
    name { "Group name" }

    trait :invalid do
      name { "" }
    end
  end
end
