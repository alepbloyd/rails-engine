# Rails-Engine

## About

Module 3, week 2, solo project for Turing School of Software and Design. This project demonstrates creation of API endpoints for a fictitious e-commerce platform - allowing API users CRUD interaction with items and merchants, as well as search capabilities. 

## DB Schema
<img width="1011" alt="image" src="https://user-images.githubusercontent.com/17027357/188053141-f87f36cc-1552-464b-abf3-ce7c1c5bfdc4.png">

## API Endpoints

### Merchant Endpoints

- `GET /api/v1/merchants` - retrieve all merchants
- `GET /api/v1/merchants/{{merchant_id}}` - retrieve specified merchant
- `GET /api/v1/merchants/{{merchant_id}}/items` - retrieve all items for specified merchant
- `GET /api/v1/merchants/find?name={{search_string}}` - retrieves first alphabetical, case-insensitive, search result
- `GET /api/v1/merchants/find_all?name={{search_string}}` - retrieves all name query results sorted alphabetically

### Item Endpoints

- `GET /api/v1/items` - retrieve all items
- `GET /api/v1/items/{{item_id}}` - retrive specified item
- `POST /api/v1/items` - create an item given valid parameters (name, description, unit_price, and merchant_id)
- `PATCH /api/v1/items` - update an item given valid parameters
- `DELETE /api/v1/items/{{item_id}}` - delete specified item
- `GET /api/v1/items/{{item_id}}/merchant` - retrieve merchant information for given item
- `GET /api/v1/items/find?name={{search_string}}` - retrieves first alphabetical, case-insensitive, search result
- `GET /api/v1/items/find_all?name={{search_string}}` - retrieves all name query results sorted alphabetically
- `GET /api/v1/items/find_all?min_price={{search_string}}` - retrieves all items above minimum price query
- `GET /api/v1/items/find_all?max_price={{search_string}}` - retrieves all items below max price query
- Max and min price queries can be combined in one query (`GET /api/v1/items/find_all?min_price={{min_search}}&max_price={{max_search}}`) to retrieve items in a given price range.

## Gems and Versions

- `ruby 2.7.4`
- `rails 5.2.8`
- `jsonapi-serializer`
- `simplecov`
- `factory_bot_rails`
- `faker`
