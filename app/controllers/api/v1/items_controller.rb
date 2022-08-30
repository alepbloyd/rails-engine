class Api::V1::ItemsController < ApplicationController

  def index
    if params[:merchant_id] != nil
      merchant = Merchant.find(params[:merchant_id])
      items = merchant.items
    else
      items = Item.all
    end

    render json: ItemSerializer.new(items)
  end

  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])

      render json: ItemSerializer.new(item)
    else
      render :json => {:error => "Not found"}.to_json, :status => 404
    end
  end

  def create
    render json: Item.create(item_params)
  end

  private

    def item_params
      params.require(:item).permit(:name,:description,:unit_price,:merchant_id)
    end

end