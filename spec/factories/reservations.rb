FactoryBot.define do
  factory :reservation1, class: Reservation do
    code { "YYYYcode" }
    start_date { 1.day.ago }
    end_date { 10.days.from_now }
    currency { "AUD" }
    number_of_nights { 3 }
    number_of_guests { 5 }
    status { "accepted" }
    payout_price { 123 }
    security_price { 500 }
    total_price { 623 }
    guest_attributes do
      {
        "first_name" => "John",
        "last_name" => "Doe",
        "email" => "john.doe@example.com",
        "phone" => ["123", "321"]
      }
    end

    factory :reservation2 do
      code { "XXXXcode" }
      guest_attributes do
        {
          "first_name" => "Jane",
          "last_name" => "Doe",
          "email" => "jane.doe@example.com",
          "phone" => ["54321"]
        }
      end
    end
  end
end
