class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
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
    # if item_params.permitted?
    # refactor to use .save once figure out why I strong params is not working for me here
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

  def find_all
    if (params[:min_price].present? || params[:max_price].present?) && params[:name].present?
      render status: 400
    elsif params[:name].present?
      items = Item.find_all_case_insensitive(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price].present? && params[:min_price].to_i < 0
      render status: 400
    elsif params[:max_price].present? && params[:max_price].to_i < 0
      render status: 400
    elsif params[:min_price].present? && params[:max_price].present?
      items = Item.find_by_min_and_max(params[:min_price],params[:max_price])
      render json: ItemSerializer.new(items)
    elsif params[:min_price].present?
      items = Item.find_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    elsif params[:max_price].present?
      items = Item.find_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name,:description, :unit_price, :merchant_id)
  end

end