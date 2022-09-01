require './app/lib/modules/name_searchable.rb'

class Item < ApplicationRecord
  extend NameSearchable

  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_all_case_insensitive(search_string)
    where("lower(name) LIKE ?", "%#{search_string.downcase}%").order(:name)
  end

  def self.find_by_price(min_price, max_price)
    where(unit_price: min_price..max_price).order(:name)
  end

end