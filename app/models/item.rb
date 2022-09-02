class Item < ApplicationRecord
  extend Searchable

  belongs_to :merchant
  has_many :invoices, through: :merchant
  has_many :invoice_items, through: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

end