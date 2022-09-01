class Api::V1::MerchantItemsController < ApplicationController

  def index
    if params[:merchant_id].to_i.to_s != params[:merchant_id]
      error_response("Merchant ID cannot be a non-numeric string", 404)
    else
      merchant = Merchant.find(params[:merchant_id])
      item_json_response(merchant.items)
    end
  end

end