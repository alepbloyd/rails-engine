class Api::V1::ItemsController < ApplicationController

  def index
    items = Item.all
    item_json_response(items)
  end

  def show
    item = Item.find(params[:id])
    item_json_response(item)
  end

  def create
    # if item_params.permitted?
    # refactor to use .save once figure out why I strong params is not working for me here
    if item_params[:name] != nil && item_params[:description] != nil && item_params[:unit_price] != nil && item_params[:merchant_id] != nil 
      render json: ItemSerializer.new(Item.create(item_params)), status: 201
    else
      render :json => {:error => "All attributes (name, description, unit_price, merchant_id) are required"}.to_json, :status => 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    Item.delete(item)
    render status: 201
  end

  def update
    if Item.exists?(params[:id])
      if item_params.has_key?("merchant_id")
        if Merchant.exists?(item_params[:merchant_id])
            render json: ItemSerializer.new(Item.update(params[:id],item_params)), status: 200
        else
          render status: 404
        end
      else
        render json: ItemSerializer.new(Item.update(params[:id],item_params)), status: 200
      end
    else
      render status: 404
    end
  end

  def find
    finder = ItemFinder.new(params[:name],params[:min_price],params[:max_price])

    results = finder.search_one

    if results == "Below zero error" || results == "Name and Price error"
      error_response(results, 400)
    else
      item_json_response(results)
    end
  end

  def find_all
    finder = ItemFinder.new(params[:name],params[:min_price],params[:max_price])
    results = finder.search_all

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

end