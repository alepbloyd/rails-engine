class ItemFinder

  attr_reader :name,
              :name_present,
              :min_price,
              :min_present,
              :max_price,
              :max_present

  def initialize(name = nil, min_price = nil, max_price = nil)
    @name = name
    @name_present = name.present?
    @min_price = min_price
    @min_present = min_price.present?
    @max_price = max_price
    @max_present = max_price.present?
  end

  def min_below_zero?
    @min_price.to_i < 0
  end

  def max_below_zero?
    @max_price.to_i < 0
  end

  def search_one
    if self.min_below_zero? || self.max_below_zero?
      "Below zero error"
    elsif @name_present && (@max_present || @min_present)
      "Name and Price error"
    elsif @name_present
      Item.find_one_by_name(@name)
    elsif @min_present && @max_present
      Item.find_one_by_price(@min_price.to_i,@max_price.to_i)
    elsif @min_present
      Item.find_one_by_price(@min_price.to_i, Float::INFINITY)
    elsif @max_present
      Item.find_one_by_price(0,@max_price.to_i)
    end
  end

  def search_all
    if self.min_below_zero? || self.max_below_zero?
      "Below zero error"
    elsif @name_present && (@max_present || @min_present)
      "Name and Price error"
    elsif @name_present
      Item.find_all_by_name(@name)
    elsif @min_present && @max_present
      Item.find_all_by_price(@min_price.to_i,@max_price.to_i)
    elsif @min_present
      Item.find_all_by_price(@min_price.to_i, Float::INFINITY)
    elsif @max_present
      Item.find_all_by_price(0,@max_price.to_i)
    end
  end

end