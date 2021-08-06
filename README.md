<!-- ABOUT THE PROJECT -->
## About The Project
A RESTful Rails API for a Tea Subscription Service.

## Table of contents
[**Built Using**](#built-using) |
[**Database Schema**](#database-schema) |
[**Setup**](#setup) |
[**Endpoints**](#endpoints) |
[**Testing**](#testing) |
[**Making a Contribution**] (#making-a-contribution) |
[**Developer**](#developer)

<!-- DEVELOPERS -->
## Created By
Mike Foy [GitHub](https://github.com/foymikek) [LinkedIn](https://www.linkedin.com/in/michael-foy-707ba7b4/)


## Built Using
* [Ruby](https://www.ruby-lang.org/en/documentation/) (version 2.5.3p105)
* [Ruby on Rails](https://rubyonrails.org/) (version 5.2.6)
* [PostgreSQL](https://www.postgresql.org/) (version 13)

This project was tested with:
* [RSpec](https://github.com/rspec/rspec-rails) version 3.10
* [Postman](https://www.postman.com/) Explore and test the API endpoints
* [pry] https://github.com/pry/pry

## Setup
- Fork and clone this repository
- change directories into `tea-api` and run the command `bundle install` in your terminal
- To set up the database and seed it, run `rails db:{create,mirgrate,seed}` or `rails db:setup`
- Start your server with the `rails s` command
- Now you're ready to consume the endpoints below

## Endpoints

All endpoints run off base URL http://localhost:3000 on a local machine.
#### Subscribe a customer to a tea subscription
| Method   | URI                                      | Description                              |
| -------- | ---------------------------------------- | ---------------------------------------- |
| `POST` | `/api/v1/customers/:customer_id/subscriptions`| Add a subscription record |

Example Request:
Needs following information in the request body
```
body:
{
  "tea_id": 1,
  "title": "Subscription for delicious tea",
  "price": 12.05,
  "status": "active",
  "frequency": 1
}
```
Example Response:
```
{
  "data": {
      "id": "9",
      "type": "subscription",
      "attributes": {
          "id": 9,
          "customer_id": 1,
          "tea_id": 5,
          "title": "Subscription for delicious tea",
          "price": 12.05,
          "status": "active",
          "frequency": 1
      }
  }
}
```
#### Cancel a customers tea subscription
| Method   | URI                                      | Description                              |
| -------- | ---------------------------------------- | ---------------------------------------- |
| `PATCH` | `/api/v1/customers/:customer_id/subscriptions/:id`| Updates the customer's subscription status to inactive |

Example Request:
The URI includes the customer id and the subscription id so this request requires the status to be sent in the params.  
Status can be sent "inactive". Inversely, to activate an inactive subscription the status could be sent as "active".  
URL: `http://localhost:3000/api/v1/customers/1/subscriptions/3`  
Params: `status: "inactive`

Example Response:
```
{
  "data": {
      "id": "3",
      "type": "subscription",
      "attributes": {
          "id": 3,
          "customer_id": 1,
          "tea_id": 3,
          "title": "Ut praesentium magni.",
          "price": 12.44,
          "status": "inactive",
          "frequency": 1
      }
  }
}
```

#### See all of a customers tea subscriptions (active and cancelled)
| Method   | URI                                      | Description                              |
| -------- | ---------------------------------------- | ---------------------------------------- |
| `GET` | `/api/v1/customers/:customer_id/subscriptions`| Retrives all subscriptions for customer |



Example Request:
URL: `http://localhost:3000/api/v1/customers/1/subscriptions`

Example Response:
```
{
    "data": [
        {
            "id": "3",
            "type": "subscription",
            "attributes": {
                "id": 3,
                "customer_id": 1,
                "tea_id": 3,
                "title": "Ut praesentium magni.",
                "price": 12.44,
                "status": "inactive",
                "frequency": 1
            }
        },
        {
            "id": "6",
            "type": "subscription",
            "attributes": {
                "id": 6,
                "customer_id": 1,
                "tea_id": 1,
                "title": "Subscription for delicious tea",
                "price": 12.05,
                "status": "active",
                "frequency": 1
            }
        }
    ]
}
```

## Testing
- Tested with Rspec
- Model and request tests
- 100% coverage
- To run tests, use the command `bundle exec rspec`
- Te see coverage, use the command `open coverage/index.html`

## Making a Contribution
1. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
2. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
3. Push to the Branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request


## Developer
##### Mike Foy • [GitHub](https://github.com/foymikek) • [LinkedIn](https://www.linkedin.com/in/michael-foy-707ba7b4/)
