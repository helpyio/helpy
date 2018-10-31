FactoryBot.define do
  factory :topic do
    sequence(:name) { |n| "something in lowercase #{n}" }
    forum
    user
    current_status { 'new' }
    team_list      { 'something' }
  end
end
