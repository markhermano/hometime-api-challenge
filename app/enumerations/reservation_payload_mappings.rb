class ReservationPayloadMappings < EnumerateIt::Base
  associate_values(
    code: [%i[code reservation_code]],
    start_date: [%i[start_date]],
    end_date: [%i[end_date]],
    currency: [%i[currency host_currency]],
    payout_price: [%i[payout_price expected_payout_amount]],
    security_price: [%i[security_price listing_security_price_accurate]],
    total_price: [%i[total_price total_paid_amount_accurate]],
    number_of_nights: [%i[nights number_of_nights]],
    number_of_guests: [%i[number_of_guests guests]],
    status: [%i[status status_type]],
    first_name: [%i[first_name guest_first_name]],
    last_name: [%i[last_name guest_last_name]],
    email: [%i[guest_email email]],
    phone: [%i[phone guest_phone_numbers] << { guest_phone_numbers: [] }],
    number_of_children: [%i[children number_of_children]],
    number_of_infants: [%i[infants number_of_infants]],
    number_of_adults: [%i[adults number_of_adults]],
    localized_description: [%i[localized_description]]
  )
end
