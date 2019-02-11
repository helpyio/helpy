FactoryBot.define do
  factory :api_key do
    name { "MyApiKey" }

    trait :expired do
      date_expired { 1.month.ago }
    end
  end
end
