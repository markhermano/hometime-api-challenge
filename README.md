# HOMETIME API Challenge

## Running the App

```bash
git clone git@github.com:markhermano/hometime-api-challenge.git
cd hometime-api-challenge
```

## Local machine


#### 1. Install dependencies

```bash
bundle install # install ruby gems
```

#### 2. Setup database

```bash
rails db:create
rails db:migrate
```

#### 3. Run the app

```bash
rails s
```

## With Docker

#### 1. Run the app with docker-compose

```bash
docker-compose up
```
<br>

## API Docs

### `POST` `/api/v1/reservations`
Requests
```bash
curl --request POST \
  --url http://localhost:3000/api/v1/reservations \
  --header 'Content-Type: application/json' \
  --data '{
	"reservation_code": "YYY12345678",
	"start_date": "2021-04-14",
	"end_date": "2021-04-18",
	"nights": 4,
	"guests": 4,
	"adults": 2,
	"children": 2,
	"infants": 0,
	"status": "accepted",
	"guest": {
		"first_name": "Wayne",
		"last_name": "Woodbridge",
		"phone": "639123456789",
		"email": "wayne_woodbridge@bnb.com"
	},
	"currency": "AUD",
	"payout_price": "4200.00",
	"security_price": "500",
	"total_price": "4700.00"
}'
```
Response
```bash
HTTP/1.1 201 Created
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 0
X-Content-Type-Options: nosniff
X-Download-Options: noopen
....
{
  "id": 1,
  "code": "YYY12345678",
  "start_date": "2021-04-14T00:00:00.000Z",
  "end_date": "2021-04-18T00:00:00.000Z",
  "created_at": "2023-01-15T16:00:43.174Z",
  "updated_at": "2023-01-15T16:00:43.174Z",
  "currency": "AUD",
  "number_of_nights": 4,
  "number_of_guests": 4,
  "status": "accepted",
  "payout_price": 4200,
  "security_price": 500,
  "total_price": 4700,
  "guest_details": {
    "number_of_children": 2,
    "number_of_infants": 0,
    "number_of_adults": 2
  },
  "guest": {
    "guest_id": 1,
    "first_name": "Wayne",
    "last_name": "Woodbridge",
    "email": "wayne_woodbridge@bnb.com",
    "phone": [
      "639123456789"
    ]
  }
}
```
Request
```bash
curl --request POST \
  --url http://localhost:3000/api/v1/reservations \
  --header 'Content-Type: application/json' \
  --data '{
	"reservation": {
		"code": "XXX12345678",
		"start_date": "2021-03-12",
		"end_date": "2021-03-16",
		"expected_payout_amount": "3800.00",
		"guest_details": {
			"localized_description": "4 guests",
			"number_of_adults": 2,
			"number_of_children": 2,
			"number_of_infants": 0
		},
		"guest_email": "wayne_woodbridge2@bnb.com",
		"guest_first_name": "Wayne",
		"guest_last_name": "Woodbridge",
		"guest_phone_numbers": [
			"639123456789",
			"639123456789"
		],
		"listing_security_price_accurate": "500.00",
		"host_currency": "AUD",
		"nights": 4,
		"number_of_guests": 4,
		"status_type": "accepted",
		"total_paid_amount_accurate": "4300.00"
	}
}'
```
Response
```bash
HTTP/1.1 201 Created
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 0
X-Content-Type-Options: nosniff
X-Download-Options: noopen
....
{
  "id": 1,
  "code": "XXX12345678",
  "start_date": "2021-03-12T00:00:00.000Z",
  "end_date": "2021-03-16T00:00:00.000Z",
  "created_at": "2023-01-15T16:34:33.954Z",
  "updated_at": "2023-01-15T16:34:33.954Z",
  "currency": "AUD",
  "number_of_nights": 4,
  "number_of_guests": 4,
  "status": "accepted",
  "payout_price": 3800,
  "security_price": 500,
  "total_price": 4300,
  "guest_details": {
    "number_of_children": 2,
    "number_of_infants": 0,
    "number_of_adults": 2,
    "localized_description": "4 guests"
  },
  "guest": {
    "guest_id": 1,
    "first_name": "Wayne",
    "last_name": "Woodbridge",
    "email": "wayne_woodbridge2@bnb.com",
    "phone": [
      "639123456789",
      "639123456789"
    ]
  }
}
```
<br>

### `PATCH` `/api/v1/reservations/:id`
Requests
```bash
curl --request PATCH \
  --url http://localhost:3000/api/v1/reservations/1 \
  --header 'Content-Type: application/json' \
  --data '{
	"start_date": "2023-04-14",
	"end_date": "2023-04-18",
	"guests": 10,
	"status": "denied"
}'
```
Response
```bash
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 0
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Permitted-Cross-Domain-Policies: none
....
{
  "id": 1,
  "code": "XXX12345678",
  "start_date": "2023-04-14T00:00:00.000Z",
  "end_date": "2023-04-18T00:00:00.000Z",
  "created_at": "2023-01-15T16:34:33.954Z",
  "updated_at": "2023-01-15T16:38:05.011Z",
  "currency": "AUD",
  "number_of_nights": 4,
  "number_of_guests": 10,
  "status": "denied",
  "payout_price": 3800,
  "security_price": 500,
  "total_price": 4300,
  "guest_details": {
    "number_of_children": 2,
    "number_of_infants": 0,
    "number_of_adults": 2,
    "localized_description": "4 guests"
  },
  "guest": {
    "guest_id": 1,
    "first_name": "Wayne",
    "last_name": "Woodbridge",
    "email": "wayne_woodbridge2@bnb.com",
    "phone": [
      "639123456789",
      "639123456789"
    ]
  }
}
```

