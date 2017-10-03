FactoryGirl.define do
  factory :topic do
    name { "something in lowercase" }
    forum
    user
  end
end
