require "rails_helper"

describe Api::V1::ReservationsController, type: :controller do
  render_views

  let(:json_parsed_body) { JSON.parse(response.body) }
  let(:request_body) do
    {
      code: "ZZZZcode",
      start_date: Time.current.beginning_of_day,
      end_date: 10.days.from_now.beginning_of_day,
      currency:  "NZD",
      number_of_nights: 5,
      number_of_guests: 25,
      status: "accepted",
      payout_price: 10000,
      security_price: 900,
      total_price: 10900,
      guest_attributes: {
        first_name: "James",
        last_name: "Doe",
        email: "james.doe@example.com",
        phone: "1111"
      }
    }
  end

  describe "GET /reservations" do
    let(:action) { -> { get :index, format: :json } }

    before do
      cache(:reservation1, created_at: 1.day.ago)
      cache(:reservation2, created_at: 2.days.ago)
      action.call
    end

    it "returns all reservations of the site" do
      expect(response).to have_http_status(:success)
      expect(json_parsed_body.first).to include("code" => "YYYYcode")
      expect(json_parsed_body.last).to include("code" => "XXXXcode")
    end
  end

  describe "POST /reservations" do
    let(:action) { -> { post :create, params: params, format: :json } }

    context "when valid attributes are sent" do
      let(:params) { request_body }

      it "creates a new reservation with guest details" do
        expect{ action.call }.to change(Reservation, :count).by(1)
          .and change(Guest, :count).by(1)
      end

      it "returns structured response" do
        action.call
        expect(response).to have_http_status(:created)
        expect(json_parsed_body).to include("code" => "ZZZZcode")
          .and include("currency" => "NZD")
          .and include("end_date" => 10.days.from_now.beginning_of_day)
          .and include("guest" => { "email" => "james.doe@example.com", 
                                    "first_name" => "James", 
                                    "guest_id" => 1, 
                                    "last_name" => "Doe", 
                                    "phone" => ["1111"] })
          .and include("number_of_guests" => 25)
          .and include("number_of_nights" => 5)
          .and include("payout_price" => 10000)
          .and include("security_price" => 900)
          .and include("start_date" => Time.current.beginning_of_day)
          .and include("status" => "accepted")
          .and include("total_price" => 10900)
      end
    end

    context "when blank request body is supplied" do
      let(:params) { {} }

      before { action.call }

      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed_body["error"]).to include("code" => ["can't be blank"])
          .and include("guest.email" => ["can't be blank", "is invalid"])
          .and include("guest.first_name" => ["can't be blank"])
          .and include("guest.last_name" => ["can't be blank"])
      end
    end

    context "when duplicate code and email is supplied" do
      let(:params) do
        {
          reservation_code: "YYYYcode",
          guest: {
            email: "john.doe@example.com"
          }
        }
      end

      before do
        cache(:reservation1)
        action.call
      end

      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed_body["error"]).to include("code" => ["has already been taken"])
          .and include("guest.email" => ["has already been taken"])
      end
    end

    context "when invalid email is supplied" do
      let(:params) { { guest: { email: "john.doe@example.com@@@xx" } } }

      before do
        cache(:reservation1)
        action.call
      end

      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed_body["error"]).to include("guest.email" => ["is invalid"])
      end
    end
  end

  context "PATCH /reservations/:id" do
    let(:reservation) { cache(:reservation1) }
    let(:action) { -> { patch :update, params: params, format: :json } }

    context "when valid request data is sent" do
      let(:params) do
        { id: reservation.id,
          reservation: {
            status: "denied",
            start_date: 2.days.from_now.beginning_of_day,
            end_date: 5.days.from_now.beginning_of_day,
            guests: 30
          }
        }
      end

      before { action.call }

      it "updates the specified attribute" do
        expect(response).to have_http_status(:ok)
        expect(json_parsed_body).to include("status" => "denied")
          .and include("start_date" => 2.days.from_now.beginning_of_day)
          .and include("end_date" => 5.days.from_now.beginning_of_day)
          .and include("number_of_guests" => 30)
      end
    end

    context "when duplicate request data is sent" do
      let(:params) do
        {
          id: reservation.id,
          reservation: {
            code: "XXXXcode",
            guest_attributes: {
              email: "jane.doe@example.com"
            }
          }
        }
      end

      before do
        cache(:reservation2)
        action.call
      end

      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed_body["error"]).to include("code" => ["has already been taken"])
          .and include("guest.email" => ["has already been taken"])
      end
    end

    context "when wrong email format data is sent" do
      let(:params) do
        {
          id: reservation.id,
          reservation: {
            guest_attributes: {
              email: "jane.doe@example.com@@"
            }
          }
        }
      end

      before do
        cache(:reservation2)
        action.call
      end

      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed_body["error"]).to include("guest.email" => ["is invalid"])
      end
    end
  end
end
