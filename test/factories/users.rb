FactoryBot.define do
  factory :user do
    sequence(:email)    { |n| "person#{n}@example.com" }
    sequence(:password) { |n| "person@{n}" }
    name                { "John" }
    role                { 'agent' }
    team_list           { 'something' }
  end
end
