class Api::V1::MerchantItemsController < ApplicationController

  def index
    if params[:merchant_id].to_i.to_s != params[:merchant_id]
      render :json => {:error => "merchant ID cannot be a non-numeric string"}.to_json, :status => 404
    elsif Merchant.exists?(params[:merchant_id])
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render status: 404
      return
    end
  end

end