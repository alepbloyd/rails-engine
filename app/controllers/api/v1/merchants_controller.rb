class Api::V1::MerchantsController < ApplicationController

  def index
    merchant_json_response(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    merchant_json_response(merchant)
  end

  def find
    merchant = Merchant.find_one_by_name(params[:name])
    
    if merchant.nil?
      render json: { data: {} }, status: 200
    else
      merchant_json_response(merchant)
    end
  end

  def find_all
  end

end