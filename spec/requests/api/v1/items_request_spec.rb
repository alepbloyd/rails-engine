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

end