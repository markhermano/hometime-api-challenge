FactoryBot.define do
  factory :guest1, class: Guest do
    first_name { "John" }
    last_name { "Doe" }
    email { "john.doe@example.com" }
    phone { ["123", "321"] }
  end
end
