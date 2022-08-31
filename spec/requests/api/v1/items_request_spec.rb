require 'rails_helper'

describe 'Items API' do
  it 'sends a list of all items' do
    merchants = create_list(:merchant,3)

    items = []

    10.times do
      items << FactoryBot.create(:item, merchant_id: merchants.sample.id)
    end

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(10)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'can get one item by id' do
    merchant = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant.id)
    item_2 = FactoryBot.create(:item, merchant_id: merchant.id)
    item_3 = FactoryBot.create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item_1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)

    expect(item[:id].to_i).to eq(item_1.id)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'returns an error getting item by id if item does not exist' do
    merchant = create(:merchant)

    good_id = FactoryBot.create(:item, merchant_id: merchant.id).id

    bad_id = good_id + 1

    get "/api/v1/items/#{bad_id}"

    expect(response).to_not be_successful
  end

  it 'can create a new item' do
    merchant = create(:merchant)

    item_params = ({
      name: "Snake Juice",
      description: "Whole bottle of gross stuff.",
      unit_price: 200,
      merchant_id: merchant.id
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'returns an error if item is not successfully created' do
    merchant = create(:merchant)

    item_params = ({
      description: "Whole bottle of gross stuff.",
      unit_price: 200,
      merchant_id: merchant.id
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
  end

  it 'can destroy an item' do
    merchant = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant.id)
    item_2 = FactoryBot.create(:item, merchant_id: merchant.id)
    item_3 = FactoryBot.create(:item, merchant_id: merchant.id)

    expect(Item.count).to eq(3)

    delete "/api/v1/items/#{item_1.id}"

    expect(response.status).to eq(201)

    expect(Item.count).to eq(2)

    expect{Item.find(item_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns an error if destroy is unsuccessful' do
    merchant = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant.id)

    bad_id = item_1.id + 1

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{bad_id}"

    expect(response.status).to eq(400)

    expect(Item.count).to eq(1)
  end

  it 'can edit an item' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)

    previous_name = item_1.name
    previous_description = item_1.description
    previous_unit_price = item_1.unit_price
    previous_merchant_id = item_1.merchant_id

    item_params = {
      name: "Snake Soup",
      description: "It is for snakes, not made of them",
      unit_price: 500,
      merchant_id: merchant_2.id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: item_params})

    item_1 = Item.find_by(id: item_1.id)

    expect(response).to be_successful
    
    expect(item_1.name).to_not eq(previous_name)
    expect(item_1.description).to_not eq(previous_description)
    expect(item_1.unit_price).to_not eq(previous_unit_price)
    expect(item_1.merchant_id).to_not eq(previous_merchant_id)

    expect(item_1.name).to eq("Snake Soup")
    expect(item_1.description).to eq("It is for snakes, not made of them")
    expect(item_1.unit_price).to eq(500)
    expect(item_1.merchant_id).to eq(merchant_2.id)
  end

  it 'returns an error if trying to edit non-existent item' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)

    bad_item_id = item_1.id + 1

    item_params = {
      name: "Snake Soup",
      description: "It is for snakes, not made of them",
      unit_price: 500,
      merchant_id: merchant_2.id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{bad_item_id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response.status).to eq(404)
  end

  it 'returns an error if attempting to update item to a non-existent merchant id' do
    merchant_1 = create(:merchant)
    bad_merchant_id = merchant_1.id + 1

    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)

    item_params = {
      name: "Snake Soup",
      description: "It is for snakes, not made of them",
      unit_price: 500,
      merchant_id: bad_merchant_id
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response.status).to eq(404)
  end

  it 'can update an item with only partial data' do
    merchant_1 = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)

    previous_name = item_1.name

    item_params = {
      name: "Snake Soup"
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to be_successful

    item_1 = Item.find_by(id: item_1.id)

    expect(item_1.name).to_not eq(previous_name)
  end

  it 'can get merchant information for a given item' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)

    get "/api/v1/items/#{item_1.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:name]).to eq(merchant_1.name)
  end

  it 'returns error getting merchant information if item is not found' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
    bad_item_id = item_1.id + 1

    get "/api/v1/items/#{bad_item_id}/merchant"

    expect(response).to_not be_successful
  end

  it 'returns one item that matches a given search term, if there is only one result' do
    merchant = create(:merchant)

    item_1 = FactoryBot.create(:item, name: "Snake Snax", merchant_id: merchant.id)
    item_2 = FactoryBot.create(:item, name: "Fish Flakes", merchant_id: merchant.id)

    search_string = "Snake"

    get "/api/v1/items/find_all?name=#{search_string}"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(1)

    item = items.first

    expect(item).to have_key(:id)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq(item_1.name)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to eq(item_1.description)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to eq(item_1.unit_price)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to eq(item_1.merchant_id)
  end

  it 'returns all items matching search term, in case-insensitive alphabetical order' do
    merchant = create(:merchant)

    item_1 = FactoryBot.create(:item, name: "c - Snake Snax", merchant_id: merchant.id)
    item_2 = FactoryBot.create(:item, name: "a - Big SNAKE", merchant_id: merchant.id)
    item_3 = FactoryBot.create(:item, name: "b - small snake small", merchant_id: merchant.id)

    item_4 = FactoryBot.create(:item, name: "Fish Flakes", merchant_id: merchant.id)
    item_5 = FactoryBot.create(:item, name: "Dog Dinner", merchant_id: merchant.id)
    item_6 = FactoryBot.create(:item, name: "Bird Biscuits", merchant_id: merchant.id)

    search_string = "snake"

    get "/api/v1/items/find_all?name=#{search_string}"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    expect(items.first[:attributes][:name]).to eq(item_2.name)
    expect(items.second[:attributes][:name]).to eq(item_3.name)
    expect(items.third[:attributes][:name]).to eq(item_1.name)
  end

end