class Item < ApplicationRecord
  extend Searchable

  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

end