FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "#{name}@example.com".gsub(/\s+/, '').downcase }
  end
end