class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render :json => {:error => "Not found"}.to_json, :status => 404
    end
  end

  def find
    if params[:name] != nil && params[:name] != ""
      merchant = Merchant.case_insensitive_search(params[:name]).first
      if merchant.nil?
        render json: { data: {} }, status: 200
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render status: 404
    end
  end

end