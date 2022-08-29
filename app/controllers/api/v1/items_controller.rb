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

end