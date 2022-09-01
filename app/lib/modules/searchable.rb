module Searchable

  def find_one_by_name(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order(name: :desc).first
  end

  def find_all_by_name(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order(name: :asc)
  end

  def find_one_by_price(min_price, max_price)
    where(unit_price: min_price..max_price).order(name: :desc).first
  end

  def find_all_by_price(min_price, max_price)
    where(unit_price: min_price..max_price).order(name: :asc)
  end

end