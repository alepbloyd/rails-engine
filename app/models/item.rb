class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_all_case_insensitive(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order(:name)
  end

  def self.find_by_min_price(min_price)
    where("unit_price >= ?", min_price.to_i).order(:name)
  end

  def self.find_by_max_price(max_price)
    where("unit_price <= ?", max_price.to_i).order(:name)
  end

  def self.find_by_min_and_max(min_price,max_price)
    where(unit_price: min_price..max_price).order(:name)
  end
end