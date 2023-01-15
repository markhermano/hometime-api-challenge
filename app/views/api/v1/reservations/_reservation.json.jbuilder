json.extract! reservation, :id, :code, :start_date, :end_date, :created_at, :updated_at, :currency,
                           :number_of_nights, :number_of_guests, :status, :payout_price, :security_price,
                           :total_price, :guest_details

json.guest do
  json.guest_id reservation.guest.id
  json.first_name reservation.guest.first_name
  json.last_name reservation.guest.last_name
  json.email reservation.guest.email
  json.phone reservation.guest.phone
end
