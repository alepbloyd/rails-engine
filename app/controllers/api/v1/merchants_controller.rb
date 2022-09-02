class Api::V1::MerchantsController < ApplicationController
  before_action :access_merchant, only: [:show]
  before_action :access_merchants, only: [:index]
  before_action :make_finder, only: [:find, :find_all]

  def index
    merchant_json_response(@merchants)
  end

  def show
    merchant_json_response(@merchant)
  end

  def find
    results = @merchant_finder.search_one
    
    if results.nil?
      render json: { data: {} }, status: 200
    else
      merchant_json_response(results)
    end
  end

  def find_all
  end

  private

  def access_merchant
    @merchant = Merchant.find(params[:id])
  end

  def access_merchants
    @merchants = Merchant.all
  end

  def make_finder
    @merchant_finder = MerchantFinder.new(params[:name])
  end

end