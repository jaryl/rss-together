FactoryBot.define do
  factory :group_transfer, class: "RssTogether::GroupTransfer" do
    group
    recipient factory: :membership

    trait :invalid do
      group { nil }
      recipient { nil }
    end
  end
end
