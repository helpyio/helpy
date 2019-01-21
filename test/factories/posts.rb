FactoryBot.define do
  factory :post do
    body { "this is a reply" }
    kind { "first" }
    user
    topic
  end
end
