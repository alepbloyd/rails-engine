module Response
  def merchant_json_response(object, status = :ok)
    render json: MerchantSerializer.new(object), status: status
  end

  def item_json_response(object, status = :ok)
    render json: ItemSerializer.new(object), status: status
  end

  def error_response(message, status = :not_found)
    render json: message, status: status
  end
end