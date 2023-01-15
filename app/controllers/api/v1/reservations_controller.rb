class Api::V1::ReservationsController < ApplicationController
  MAX_PER_PAGE = 20

  before_action :group_params, except: :index

  rescue_from ActiveRecord::RecordNotFound, with: -> { render_error("Not found", :not_found) }

  def index
    @reservations = Reservation.includes(:guest).order(created_at: :desc)
      .paginate(page: params.fetch(:page) { 1 }.to_i, per_page: limit_per_page(MAX_PER_PAGE))
    
    extract_pagination_from!(@reservations)
  end

  def show; end

  def create
    @reservation = Reservation.new(processed_params)

    if @reservation.save
      render :show, status: :created
    else
      render_error(@reservation.errors, :unprocessable_entity)
    end
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update(processed_params)
      render :show, status: :ok
    else
      render_error(@reservation.errors, :unprocessable_entity)
    end
  end

  private

  def processed_params
    @processed_params ||= PayloadMappingHandler.call(params: permitted_params, action: params[:action])
  end

  def group_params
    params[:reservation] = flatted_params(params)
  end

  def flatted_params(param)
    param.each_pair.reduce({}) do |data, (key, val)|
      val.is_a?(ActionController::Parameters) ? data.merge(flatted_params(val)) : data.merge("#{key}".to_sym => val)
    end
  end

  def permitted_params
    params.require(:reservation).permit(:id, *ReservationPayloadMappings.list)
  end
end
