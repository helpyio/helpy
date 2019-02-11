FactoryBot.define do
  factory :doc do
    title { "something in lowercase" }
    body  { 'test test test' }
    category
  end
end
