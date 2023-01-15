class PayloadMappingHandler
  include Service

  def initialize(params:, action:)
    @params = params.to_h.symbolize_keys
    @action = action
  end

  def call
    return create_params if action == "create"

    update_params
  end

  private

  attr_reader :params, :action

  def create_params
    @create_params ||= {
      code: processed_params[:code],
      start_date: processed_params[:start_date],
      end_date: processed_params[:end_date],
      currency: processed_params[:currency],
      payout_price: processed_params[:payout_price],
      security_price: processed_params[:security_price],
      total_price: processed_params[:total_price],
      number_of_nights: processed_params[:number_of_nights],
      number_of_guests: processed_params[:number_of_guests],
      status: processed_params[:status],
      guest_details: guest_details.slice(*(processed_params.keys & guest_details.keys)),
      guest_attributes: guest_attributes
    }
  end

  def guest_details
    @guest_details ||= {
      number_of_children: processed_params[:number_of_children],
      number_of_infants: processed_params[:number_of_infants],
      number_of_adults: processed_params[:number_of_adults],
      localized_description: processed_params[:localized_description]
    }
  end

  def guest_attributes
    @guest_attributes ||={
      first_name: processed_params[:first_name],
      last_name: processed_params[:last_name],
      email: processed_params[:email],
      phone: ([] << processed_params[:phone]).flatten
    }
  end

  def processed_params
    @processed_params ||= begin
      params_hash = {}
      ReservationPayloadMappings.keys.each_with_index do |key, index|
        matched_key = params.keys & ReservationPayloadMappings.list[index]
        next if matched_key.blank?

        params_hash[key] = params[matched_key.first]
      end
      params_hash
    end
  end

  def update_params
    @update_params ||= begin
      sliced_params.each_pair.reduce({}) do |data, (key, val)|
        if guest_attributes.keys.include?(key)
          rebuild_nested_params(data, :guest_attributes, key, val)
        elsif guest_details.keys.include?(key)
          rebuild_nested_params(data, :guest_details, key, val)
        else
          data.merge("#{key}".to_sym => val)
        end
      end
    end
  end

  def rebuild_nested_params(data, param_key, key, value)
    data[param_key] = {} unless data[param_key].present?
    data[param_key].store(key, value)
    data
  end

  def sliced_params
    @sliced_params ||= processed_params.tap { |key| create_params.slice(key) }
  end
end
