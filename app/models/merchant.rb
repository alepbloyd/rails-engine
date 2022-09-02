class Merchant < ApplicationRecord
  extend Searchable

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices
end
