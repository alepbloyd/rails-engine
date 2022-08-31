require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of all merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchant).to have_key(:id)

    expect(merchant[:id].to_i).to eq(id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'returns an error getting merchant by id if merchant does not exist' do
  
    good_id = create(:merchant).id

    bad_id = good_id + 1

    get "/api/v1/merchants/#{bad_id}"

    expect(response).to_not be_successful
  end

  it 'returns all items for a given merchant id' do
    merchant_good = create(:merchant)
    merchant_bad = create(:merchant)
    items_good = []
    items_bad = []

    5.times do
      items_good << FactoryBot.create(:item, merchant_id: merchant_good.id)
    end

    2.times do
      items_bad << FactoryBot.create(:item, merchant_id: merchant_bad.id)
    end

    get "/api/v1/merchants/#{merchant_good.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant_good.id)

      expect(item[:attributes][:merchant_id]).to_not eq(merchant_bad.id)
    end
  end

  it 'returns one merchant that matches a given search term, if there is only one result' do
    merchant_1 = FactoryBot.create(:merchant, name: "Snake Shoppe")
    merchant_2 = FactoryBot.create(:merchant, name: "Fish Factory")

    search_string = "Snake"

    get "/api/v1/merchants/find?name=#{search_string}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)

    expect(merchant[:id].to_i).to eq(merchant_1.id)

    expect(merchant[:attributes]).to have_key(:name)

    expect(merchant[:attributes][:name]).to eq(merchant_1.name)
  end

  it 'returns the first merchant in case-insensitive alphabetical order if multiple matches are found' do
    merchant_1 = FactoryBot.create(:merchant, name: "B - Snake Shoppe")
    merchant_2 = FactoryBot.create(:merchant, name: "a - Snake Shoppe")

    search_string = "Snake"

    get "/api/v1/merchants/find?name=#{search_string}"

    expect(response).to be_successful

    
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)

    expect(merchant[:id].to_i).to eq(merchant_2.id)

    expect(merchant[:attributes]).to have_key(:name)

    expect(merchant[:attributes][:name]).to eq(merchant_2.name)
  end

  it 'is case insensitive in search' do
    merchant_1 = FactoryBot.create(:merchant, name: "B - Snake Shoppe")
    merchant_2 = FactoryBot.create(:merchant, name: "a - Snake Shoppe")

    search_string = "SnAkE"

    get "/api/v1/merchants/find?name=#{search_string}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)

    expect(merchant[:id].to_i).to eq(merchant_2.id)

    expect(merchant[:attributes]).to have_key(:name)

    expect(merchant[:attributes][:name]).to eq(merchant_2.name)
  end

  it 'returns an empty array if no records match search' do
    merchant_1 = FactoryBot.create(:merchant, name: "B - Snake Shoppe")
    merchant_2 = FactoryBot.create(:merchant, name: "a - Snake Shoppe")

    search_string = "BigBugs"

    get "/api/v1/merchants/find?name=#{search_string}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)
  end
end