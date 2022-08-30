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

  def show_merchant
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      merchant = item.merchant
      render json: MerchantSerializer.new(merchant)
    else
      render status: 404
    end
  end

  def create
    # if item_params.permitted?
    if item_params[:name] != nil && item_params[:description] != nil && item_params[:unit_price] != nil && item_params[:merchant_id] != nil 
      render json: ItemSerializer.new(Item.create(item_params)), status: 201
    else
      render :json => {:error => "All attributes (name, description, unit_price, merchant_id) are required"}.to_json, :status => 400
    end
  end

  def destroy
    if Item.exists?(params[:id])
      Item.delete(params[:id])
      render status: 201
    else
      render :json => {:error => "Item does not exist"}.to_json, :status => 400
    end
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

  private

  def item_params
    params.require(:item).permit(:name,:description, :unit_price, :merchant_id)
  end

end