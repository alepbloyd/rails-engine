class Api::V1::ItemsController < ApplicationController
  before_action :access_item, only: [:show,:destroy,:update]
  before_action :access_items, only: [:index]
  before_action :make_finder, only: [:find, :find_all]

  def index
    item_json_response(@items)
  end

  def show
    item_json_response(@item)
  end

  def create
    if item_params[:name] != nil && item_params[:description] != nil && item_params[:unit_price] != nil && item_params[:merchant_id] != nil 
      render json: ItemSerializer.new(Item.create(item_params)), status: 201
    else
      render :json => {:error => "All attributes (name, description, unit_price, merchant_id) are required"}.to_json, :status => 400
    end
  end

  def destroy
    Item.delete(@item)
    render status: 201
  end

  def update
    @item.update!(item_params)
    item_json_response(@item)
  end

  def find
    results = @item_finder.search_one

    if results == "Below zero error" || results == "Name and Price error"
      error_response(results, 400)
    else
      item_json_response(results)
    end
  end

  def find_all
    results = @item_finder.search_all

    if results == "Below zero error" || results == "Name and Price error"
      error_response(results, 400)
    else
      item_json_response(results)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name,:description, :unit_price, :merchant_id)
  end

  def access_item
    @item = Item.find(params[:id])
  end

  def access_items
    @items = Item.all
  end

  def access_merchant
    # @merchant = Merchant.find(item_params[:merchant_id])
  end

  def make_finder
    @item_finder = ItemFinder.new(params[:name],params[:min_price],params[:max_price])
  end

end