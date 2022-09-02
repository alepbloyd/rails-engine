class ItemFinder

  attr_reader :name,
              :min_price,
              :max_price

  def initialize(name = nil, min_price = nil, max_price = nil)
    @name = name
    @min_price = min_price
    @max_price = max_price
  end

  def name_present?
    @name.present?
  end

  def min_present?
    @min_price.present?
  end

  def max_present?
    @max_price.present?
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
    elsif self.name_present? && (self.min_present? || self.max_present?)
      "Name and Price error"
    elsif self.name_present?
      Item.find_one_by_name(@name)
    elsif self.min_present? && self.max_present?
      Item.find_one_by_price(@min_price.to_i,@max_price.to_i)
    elsif self.min_present?
      Item.find_one_by_price(@min_price.to_i, Float::INFINITY)
    elsif self.max_present?
      Item.find_one_by_price(0,@max_price.to_i)
    end
  end

  def search_all
    if self.min_below_zero? || self.max_below_zero?
      "Below zero error"
    elsif self.name_present? && (self.min_present? || self.max_present?)
      "Name and Price error"
    elsif self.name_present?
      Item.find_all_by_name(@name)
    elsif self.min_present? && self.max_present?
      Item.find_all_by_price(@min_price.to_i,@max_price.to_i)
    elsif self.min_present?
      Item.find_all_by_price(@min_price.to_i, Float::INFINITY)
    elsif self.max_present?
      Item.find_all_by_price(0,@max_price.to_i)
    end
  end

end